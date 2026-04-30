# Code-Generation Templates

This file holds the copy-paste-ready templates the GPT emits when the user requests an **Export / Codegen** response (e.g., "give me the Python", "export as Power Query M", "show me the SQL", "as VBA"). The templates below are skeletons — the GPT must dynamically inject the **exact** sheet name and column names discovered during the Parse-First Metadata Scan (see `headcount-schema-dictionary.md` § *Parse-First Metadata Scan*). Never emit placeholders like `<insert column names>` or `// TODO: file path`.

## Universal Rules

1. **No placeholders.** Every column name, sheet name, and file name in the emitted code must be a literal value pulled from the parse-first scan. If a value is unknown, halt and ask — do not emit a stub.
2. **No hardcoded absolute paths.** Use the user's filename as a relative reference; for Power Query, generate a dynamic-path block (named range + `Excel.CurrentWorkbook`).
3. **No hardcoded column letters.** Locate columns by header string, not by `A:A` / `C:C`.
4. **Defensive imports.** Each template includes the safeguard the article identifies (`MissingField.UseNull`, `usecols=`, `all_varchar=true`, `RangeCopyType.values`, `LookAt:=xlWhole` + `xlUp`).
5. **Echo the parse-first context.** Above each emitted code block, print a one-line summary of the schema the code targets: `Sheet: <name> | Columns: <list>`. This makes the contract explicit.
6. **One language per response unless the user asks for multiple.** Default to Pandas if the user says "export as code" without specifying a language.

## Routing Heuristic — Which Language to Suggest

| User signal | Recommend |
|---|---|
| "I want to repeat this monthly in Excel" / refresh-friendly | **Power Query M** |
| "Standard Python" / "into a notebook" / moderate file size | **Pandas** |
| "Big file" / "out of memory" / "SQL" | **DuckDB** |
| "R" / "tidyverse" / "ggplot downstream" | **R (readxl + dplyr)** |
| "Excel on the Web" / "Power Automate" / "no macros allowed" | **Office Scripts (TypeScript)** |
| "Macro" / "legacy desktop Excel only" / "VBA" | **VBA** |

If the user does not specify, default to **Pandas** and offer a one-line "Want this as M, DuckDB SQL, R, Office Scripts, or VBA instead?" follow-up.

## 1. Power Query M (Advanced Editor)

**Use when:** the user wants a refreshable, in-Excel pipeline.

**Mandatory safeguards:**
- Dynamic file path via a named range `DynamicPath` with `=LEFT(CELL("filename"),SEARCH("[",CELL("filename"))-1)`.
- `MissingField.UseNull` on `Table.SelectColumns` so a missing column does not throw `[Expression.Error]`.

**Setup instruction (emit *above* the code):**
> In Excel, create a named range called `DynamicPath` containing the formula `=LEFT(CELL("filename"),SEARCH("[",CELL("filename"))-1)`. Then open Power Query → Home → Advanced Editor and paste the code below.

**Template:**
```m
let
    FolderPath  = Excel.CurrentWorkbook(){[Name="DynamicPath"]}[Content]{0}[Column1],
    FullPath    = FolderPath & "<FILE_NAME>.xlsx",
    Source      = Excel.Workbook(File.Contents(FullPath), null, true),
    SheetData   = Source{[Item="<SHEET_NAME>", Kind="Sheet"]}[Data],
    Promoted    = Table.PromoteHeaders(SheetData, [PromoteAllScalars=true]),
    Selected    = Table.SelectColumns(
        Promoted,
        {<COLUMN_LIST_M>},
        MissingField.UseNull
    )
in
    Selected
```

`<COLUMN_LIST_M>` is a comma-separated list of double-quoted user-mapped column names, e.g. `"<col_a>", "<col_b>", "<col_c>"` populated from the parse-first scan and the user's Column Aliases.

## 2. Python — Pandas

**Use when:** moderate file size, downstream analysis in a notebook.

**Mandatory safeguards:**
- `usecols=` with the explicit list — never load all columns and drop later.
- `engine="openpyxl"` for `.xlsx`.
- `sheet_name=` set to the literal sheet name from the parse-first scan.

**Template:**
```python
import pandas as pd

target_columns = [<COLUMN_LIST_PY>]

df = pd.read_excel(
    "<FILE_NAME>.xlsx",
    sheet_name="<SHEET_NAME>",
    usecols=target_columns,
    engine="openpyxl",
)

print(df.head())
```

`<COLUMN_LIST_PY>` is a comma-separated list of single-quoted canonical names.

## 3. Python — DuckDB

**Use when:** the file is large, the user mentions out-of-memory issues, or the user asks for SQL.

**Mandatory safeguards:**
- `INSTALL excel; LOAD excel;` before the first `read_xlsx`.
- `all_varchar = true` to defuse mixed-type columns; cast to numeric/date downstream.
- Filter on a non-null column to drop empty rows that Excel artifacts often inject.

**Template:**
```python
import duckdb

con = duckdb.connect()
con.execute("INSTALL excel; LOAD excel;")

query = """
SELECT <COLUMN_LIST_SQL>
FROM read_xlsx(
    '<FILE_NAME>.xlsx',
    sheet = '<SHEET_NAME>',
    all_varchar = true
)
WHERE <PRIMARY_NON_NULL_COLUMN> IS NOT NULL
"""

df = con.execute(query).df()
print(df.head())
```

`<COLUMN_LIST_SQL>` is a comma-separated list of bare-or-quoted column identifiers; quote any name that contains spaces or special characters using `"…"` (SQL identifier quoting).

## 4. R — readxl + dplyr

**Use when:** the user is in a tidyverse / statistical workflow.

**Mandatory safeguards:**
- Pipe directly into `dplyr::select()` rather than relying on `col_types = "skip"` positional mapping.
- Pass `skip = N` to `read_excel()` only if the parse-first scan reveals title rows above the header row.

**Template:**
```r
library(readxl)
library(dplyr)

file_path    <- "<FILE_NAME>.xlsx"
target_sheet <- "<SHEET_NAME>"

extracted_data <- read_excel(path = file_path, sheet = target_sheet) %>%
    select(<COLUMN_LIST_R>)

glimpse(extracted_data)
```

`<COLUMN_LIST_R>` is a comma-separated list of bare user-mapped column names; wrap any name containing spaces or special characters in backticks (e.g. `` `<col with space>` ``).

## 5. Office Scripts (TypeScript)

**Use when:** the user is on Excel on the Web or wants a Power Automate-orchestrated flow with no local file-system access.

**Mandatory safeguards:**
- Use `getColumnByName(...).getRangeBetweenHeaderAndTotal()` rather than cell-by-cell loops.
- Use `targetCell.copyFrom(sourceRange, ExcelScript.RangeCopyType.values, false, false)` so formulas are evaluated to static values.
- Auto-fit on the destination sheet.

**Template:**
```typescript
function main(workbook: ExcelScript.Workbook) {
    const sourceSheet = workbook.getWorksheet("<SHEET_NAME>");
    const table = sourceSheet.getTables()[0];

    const columnsToExtract: string[] = [<COLUMN_LIST_TS>];
    const newSheet = workbook.addWorksheet("Extracted_Data");

    let currentPasteCol = 0;
    for (const colName of columnsToExtract) {
        const sourceRange = table.getColumnByName(colName).getRangeBetweenHeaderAndTotal();
        const targetCell  = newSheet.getCell(1, currentPasteCol);
        newSheet.getCell(0, currentPasteCol).setValue(colName);
        targetCell.copyFrom(
            sourceRange,
            ExcelScript.RangeCopyType.values,
            false,
            false
        );
        currentPasteCol++;
    }

    newSheet.getUsedRange().getFormat().autofitColumns();
}
```

`<COLUMN_LIST_TS>` is a comma-separated list of double-quoted canonical names.

**Pre-flight check the GPT must perform:** Office Scripts requires a real Excel `Table` object on the source sheet. If the parse-first scan saw a plain range (no `Table` listed), tell the user: *"Office Scripts needs the source data to be formatted as a Table (Insert → Table). Convert it, then re-run."*

## 6. VBA (Legacy Desktop Excel)

**Use when:** the user is in legacy desktop Excel, asks for a macro, or has an existing `.xlsm` workbook.

**Mandatory safeguards:**
- `.Find(What:=…, LookAt:=xlWhole)` to locate columns by header string — **never** hardcode `Range("C:C")`.
- `xlUp` to find the dynamic last row per column.
- `Application.ScreenUpdating = False` while running, restored at the end.
- Append a timestamp to the destination sheet name to avoid collisions on re-runs.

**Template:**
```vba
Sub ExtractColumnsDynamically()
    Dim wsSource As Worksheet
    Dim wsDest As Worksheet
    Dim foundHeader As Range
    Dim lastRow As Long
    Dim headersToExtract As Variant
    Dim i As Integer
    Dim destCol As Integer

    Application.ScreenUpdating = False

    Set wsSource = ThisWorkbook.Sheets("<SHEET_NAME>")
    Set wsDest   = ThisWorkbook.Sheets.Add(After:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count))
    wsDest.Name  = "Extracted_Data_" & Format(Now(), "hhmmss")

    headersToExtract = Array(<COLUMN_LIST_VBA>)
    destCol = 1

    For i = LBound(headersToExtract) To UBound(headersToExtract)
        Set foundHeader = wsSource.Rows(1).Find(What:=headersToExtract(i), LookAt:=xlWhole)
        If Not foundHeader Is Nothing Then
            lastRow = wsSource.Cells(wsSource.Rows.Count, foundHeader.Column).End(xlUp).Row
            wsSource.Range( _
                wsSource.Cells(1, foundHeader.Column), _
                wsSource.Cells(lastRow, foundHeader.Column) _
            ).Copy
            wsDest.Cells(1, destCol).PasteSpecial xlPasteValues
            destCol = destCol + 1
        End If
    Next i

    Application.CutCopyMode = False
    Application.ScreenUpdating = True
End Sub
```

`<COLUMN_LIST_VBA>` is a comma-separated list of double-quoted user-mapped column names, e.g. `"<col_a>", "<col_b>"` populated from the parse-first scan.

## Anti-Patterns the GPT Must Refuse to Emit

| Anti-pattern | Why it breaks | Fix |
|---|---|---|
| `Range("C:C").Copy` (VBA) or `df.iloc[:, 2]` (Pandas) | Hardcoded column position breaks the moment the source schema shifts. | Look up by header string. |
| `C:\Users\<name>\Downloads\file.xlsx` | Breaks when the file is emailed or moved. | Power Query: `DynamicPath` named range. Other languages: relative filename. |
| `# TODO: enter columns here` | The GPT already discovered the columns via the parse-first scan. | Inject the literal list. |
| `pd.read_excel(...)` then `.drop(columns=[...])` | Loads the entire file into RAM, defeating the point of `usecols=`. | Use `usecols=` directly. |
| `read_excel(...)` then positional indexing in R | Brittle to schema changes. | Pipe into `dplyr::select(<names>)`. |
| Office Script that loops cell-by-cell | Slow on the web runtime; also exhausts the script's row-budget on large tables. | `getRangeBetweenHeaderAndTotal()` + `copyFrom`. |
| Code with no `Sheet:` / `Columns:` echo above it | The user cannot audit what the code targets without re-deriving it. | Emit a one-line summary above every code block. |

## Output Envelope

Every Codegen Export response must follow this envelope:

```
**Generated for:** <SHEET_NAME> | columns: <comma-separated list>
**Language:** <Power Query M | Pandas | DuckDB | R | Office Scripts | VBA>
**Setup notes:** <one or two lines if the language requires user setup; otherwise "None.">

<code block>

**Logic:** <one or two lines explaining the formula or filter the code applies, mirroring the analytical-formulas.md reference if relevant>
```

Never strip the envelope. The summary lines above and below the code block are how the user audits the output without having to read the code.
