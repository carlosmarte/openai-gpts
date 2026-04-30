# Code-Generation Templates — Filter-Table-Parameterized

When the user asks for code (`as Python`, `as M`, `as DuckDB SQL`, `VBA`, `Office Script`, `as R`), the GPT emits a copy-paste-ready code block that **applies the same Filter table** the user just saw against the user's literal sheet/column names from the Parse-First Metadata Scan.

The templates below are skeletons. The GPT injects:
- **Sheet name** — the literal string from the scan (e.g., `'Employees Q1 2026'`).
- **Column names** — the literal headers from the scan, *not* the canonical names from `Column.md` (the user's file may use `EmpNum` even though that resolves to canonical `employee_id`).
- **Filter clauses** — the predicates from the user's `Filters applied` table, translated into the target language's idiom.

Never emit placeholders like `<insert column names>`, `// TODO`, `your_path`, or `column_name`.

---

## Standard output envelope

Every code emission follows this envelope so the user can verify provenance at a glance:

```
**Generated for:** Sheet `<literal sheet>`, columns `<literal_col_a>`, `<literal_col_b>`, …
**Language:** <Python / M / DuckDB SQL / VBA / Office Scripts / R>
**Setup notes:** <one-line install / config note relevant to the language>

```<lang>
<code block>
```

**Filter table (re-emitted as comment header):**
| Column used | Logic applied | Reasoning |
|---|---|---|
| ... | ... | ... |
```

---

## Pandas (default if unspecified)

```python
import pandas as pd

df = pd.read_excel(
    "<literal_path>.xlsx",
    sheet_name="<literal sheet>",
    usecols=["<literal_col_a>", "<literal_col_b>", "<literal_col_c>"],
    engine="openpyxl",
)
df["<date_col>"] = pd.to_datetime(df["<date_col>"], errors="coerce")

# Filter table re-applied:
mask = (
    (df["<literal_col_a>"] == "EMEA")
    & (df["<date_col>"] >= "2026-01-01")
    & (df["<date_col>"] <  "2026-04-01")
)
matched = df.loc[mask, ["<literal_col_a>", "<literal_col_b>", "<literal_col_c>"]]
print(f"Matched {len(matched)} of {len(df)} rows")
matched.head(10)
```

**Setup notes:** `pip install pandas openpyxl`. Use `engine="openpyxl"` for `.xlsx`.

---

## Power Query M (Excel refresh)

```m
let
    DynamicPath = Excel.CurrentWorkbook(){[Name="DataFilePath"]}[Content]{0}[Column1],
    Source = Excel.Workbook(File.Contents(DynamicPath), null, true),
    Sheet = Source{[Item="<literal sheet>", Kind="Sheet"]}[Data],
    Headers = Table.PromoteHeaders(Sheet, [PromoteAllScalars=true]),
    Selected = Table.SelectColumns(Headers,
        {"<literal_col_a>", "<literal_col_b>", "<literal_col_c>"},
        MissingField.UseNull),
    DateTyped = Table.TransformColumnTypes(Selected, {{"<date_col>", type date}}),
    Filtered = Table.SelectRows(DateTyped, each
        [<literal_col_a>] = "EMEA"
        and [<date_col>] >= #date(2026,1,1)
        and [<date_col>] <  #date(2026,4,1))
in
    Filtered
```

**Setup notes:** Create a named range `DataFilePath` containing the workbook path so refresh works without hardcoding. `MissingField.UseNull` makes the projection forgiving if a column is later removed.

---

## DuckDB SQL (large-file path)

```sql
INSTALL excel; LOAD excel;

WITH src AS (
    SELECT *
    FROM read_xlsx(
        '<literal_path>.xlsx',
        sheet = '<literal sheet>',
        all_varchar = true
    )
)
SELECT
    "<literal_col_a>",
    "<literal_col_b>",
    "<literal_col_c>"
FROM src
WHERE "<literal_col_a>" = 'EMEA'
  AND CAST("<date_col>" AS DATE) >= DATE '2026-01-01'
  AND CAST("<date_col>" AS DATE) <  DATE '2026-04-01';
```

**Setup notes:** `all_varchar = true` avoids type-inference surprises on dirty data; cast date columns explicitly. DuckDB's `excel` extension handles 200k+ row files without loading all into RAM.

---

## R (dplyr + readxl)

```r
library(readxl)
library(dplyr)

df <- read_excel("<literal_path>.xlsx", sheet = "<literal sheet>") |>
  select(`<literal_col_a>`, `<literal_col_b>`, `<literal_col_c>`) |>
  mutate(`<date_col>` = as.Date(`<date_col>`))

matched <- df |>
  filter(
    `<literal_col_a>` == "EMEA",
    `<date_col>` >= as.Date("2026-01-01"),
    `<date_col>` <  as.Date("2026-04-01")
  )

cat(sprintf("Matched %d of %d rows\n", nrow(matched), nrow(df)))
head(matched, 10)
```

**Setup notes:** Backtick-quote column names that contain spaces or punctuation. `readxl` handles `.xlsx` natively; no Java dependency.

---

## Office Scripts (TypeScript, Excel-on-the-web safe)

```typescript
function main(workbook: ExcelScript.Workbook) {
  const ws = workbook.getWorksheet("<literal sheet>");
  const table = ws.getTables()[0] ?? ws.getRangeByIndexes(0, 0, ws.getUsedRange().getRowCount(), ws.getUsedRange().getColumnCount());
  const cols = ["<literal_col_a>", "<literal_col_b>", "<literal_col_c>"];
  const dest = workbook.addWorksheet(`Filtered_${new Date().toISOString().slice(0, 10)}`);

  cols.forEach((col, i) => {
    const src = ws.getTables()[0].getColumnByName(col).getRangeBetweenHeaderAndTotal();
    dest.getCell(0, i).copyFrom(src, ExcelScript.RangeCopyType.values, false, false);
  });
  // Filter logic applied via dest.getRangeByIndexes(...) + AutoFilter — see envelope comment for the
  // mapped predicate translated from the Filter table.
}
```

**Setup notes:** Office Scripts requires a worksheet table; if the user's data is a plain range, prepend `ws.addTable(...)`. Cell-by-cell loops are forbidden — `copyFrom` is the bulk path.

---

## VBA (legacy desktop Excel)

```vb
Sub ApplyFilter()
    Application.ScreenUpdating = False
    Dim ws As Worksheet: Set ws = ThisWorkbook.Sheets("<literal sheet>")
    Dim hdr As Range: Set hdr = ws.Rows(1).Find(What:="<literal_col_a>", LookAt:=xlWhole)
    Dim lastRow As Long: lastRow = ws.Cells(ws.Rows.Count, hdr.Column).End(xlUp).Row
    Dim dest As Worksheet
    Set dest = ThisWorkbook.Sheets.Add(After:=ws)
    dest.Name = "Filtered_" & Format(Now, "YYYYMMDD")
    ws.Range(ws.Cells(1, 1), ws.Cells(lastRow, ws.UsedRange.Columns.Count)).AutoFilter _
        Field:=hdr.Column, Criteria1:="EMEA"
    ws.UsedRange.SpecialCells(xlCellTypeVisible).Copy Destination:=dest.Range("A1")
    ws.AutoFilterMode = False
    Application.ScreenUpdating = True
End Sub
```

**Setup notes:** `.Find(...,LookAt:=xlWhole)` matches the literal header — never hardcode column letters like `Range("C:C")`. Bracket the macro with `ScreenUpdating = False/True` for performance.

---

## Anti-patterns the GPT must refuse

- **Placeholders.** `<insert column names>`, `// TODO: file path`, `your_path`, `column_name`.
- **Hardcoded column letters** in VBA (`Range("C:C")`) — always use `.Find` against the literal header.
- **Full-table scan-then-drop** in DuckDB — push the filter into the SQL.
- **Cell-by-cell loops** in Office Scripts — use `copyFrom` with `RangeCopyType.values`.
- **Silent column rename** in Pandas / R — preserve the literal header from the scan; don't normalize to canonical names.
- **`engine="auto"`** in Pandas for `.xlsx` — be explicit (`engine="openpyxl"`).
