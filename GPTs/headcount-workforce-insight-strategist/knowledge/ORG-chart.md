# Manager Hierarchy with Inherited Levels

This file is **loaded at runtime by the GPT** and is **user-overridable** — upload a sidecar with the same name, or supply an inline level mapping at the start of the chat, to take precedence over these defaults.

## How the GPT uses this file

When a question implies a manager-hierarchy filter ("under VP X", "managers at level ≥ M3", "everyone in Jane Doe's org"), the GPT:

1. Reads the manager-level convention defined here (M0…Mn).
2. If the data file has a `manager_level` column (resolved via `Column.md`), uses it directly.
3. Otherwise, **computes** each row's level by walking the manager chain: from each row's `manager_id` up through the `employee_id` of its manager, recursively, until the top of the chain (no manager, or self-referential).
4. Uses the result for any hierarchy-aware predicate (e.g., `manager_level >= 'M3'`, `is_under('E1042')`).

## Default Level Convention

| Level | Label | Description |
|---|---|---|
| M0 | Individual Contributor | No direct reports |
| M1 | First-line manager | Manages M0s |
| M2 | Second-line manager | Manages M1s |
| M3 | Director | Manages M2s |
| M4 | Sr. Director / VP | Manages M3s |
| M5 | SVP | Manages M4s |
| M6 | EVP | Manages M5s |
| M7 | C-Suite | Manages M6s |
| M8 | CEO | Top of chain |

Levels above M8 are flattened to M8 unless a sidecar redefines the convention.

## Inheritance Algorithm (when `manager_level` is absent)

For each employee row:

- If `manager_id` is null/empty/self-referential → the row is a chain root; assign it M8 (or the highest level the convention defines).
- Else: `level(row) = max(level(child)) + 1` over all rows whose `manager_id` equals `row.employee_id`. A row with no children is M0 (IC).

The GPT computes this once per run after the Parse-First Metadata Scan and caches it in memory; it is not written back to the source file.

## Filter Examples

- **"managers at level ≥ M3"** → `manager_level >= 'M3'` on the resolved column.
- **"everyone under VP X"** → resolve `X` to an `employee_id` via `name` or `email` (`Column.md`), then filter rows whose transitive `manager_id` chain contains `X`.
- **"second-line managers and above"** → `manager_level >= 'M2'`.
- **"ICs only"** → `manager_level == 'M0'`.
- **"Jane Doe's direct reports"** → resolve Jane to `employee_id`, then filter `manager_id == <jane_id>`.
- **"Jane Doe's full org (transitive)"** → recursive walk of the manager → reports relationship rooted at Jane.

## How to override

**Option 1 — sidecar upload:** drop a file named `ORG-chart.md` into the chat at the start of the run. The sidecar replaces this convention for that run.

**Option 2 — inline level mapping:** if your data file has explicit hierarchy labels in a column (e.g., `Org_Level = 'IC' / 'Manager' / 'Director' / 'VP' / ...`), paste a JSON map at the start of the chat:

```
{
  "IC": "M0",
  "Manager": "M1",
  "Sr Manager": "M2",
  "Director": "M3",
  "VP": "M4",
  "SVP": "M5"
}
```

The GPT records the override in the run footer.

## Notes

- This is a **placeholder convention** — replace with your organization's actual level taxonomy if it differs.
- The algorithm assumes a single-rooted tree (one CEO). If your file has multiple roots (e.g., a joint-venture structure), the GPT flags it as a `[CRITICAL]` data-quality anomaly per `anomaly-detection-rules.md` and asks how to proceed.
- Manager-level inheritance is computed lazily — only when a question's filter clauses require it. Pure attribute-only filters (e.g., region, hire_date) do not trigger this computation.
