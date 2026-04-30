# Analytical Formulas — Filter / Project / Aggregate Patterns (F1–F8)

This file is the GPT's pattern library for row-per-employee analysis. Every Logic block in a response cites the F-number(s) used. The GPT does not invent alternative formulations.

The patterns operate on the resolved DataFrame (post-load, post-`Column.md` resolution). Each pattern lists its inputs (canonical column names from `Column.md`), the pandas idiom, and notes on when it fires.

---

## F1 — Filter (predicate over rows)

**Purpose:** Apply a boolean predicate to the DataFrame to retain rows that match the user's question.

**Inputs:** any subset of resolved columns; comparison operators (`==`, `!=`, `<`, `<=`, `>`, `>=`, `in`, `between`, `contains`); boolean combinators (`&`, `|`, `~`).

**Pandas idiom:**
```python
mask = (df.region == 'EMEA') & (df.tenure_years > 5) & (df.manager_level >= 'M3')
matched = df[mask]
```

**Notes:** This is the default operation. Every response that returns rows starts here.

---

## F2 — Project (column selection)

**Purpose:** Limit the displayed columns to those the user's question implies, plus identifier-like columns from `Column.md` for traceability.

**Inputs:** list of resolved column names.

**Pandas idiom:**
```python
projection = ['employee_id', 'name', 'region', 'tenure_years', 'manager_level']
matched[projection]
```

**Notes:** Default projection always includes the highest-priority identifier from `Column.md` (`employee_id` if present, else `name`, else the first PII-tagged column). This keeps spot-check tables grounded in something the user can cross-reference.

---

## F3 — Aggregate (count / sum / mean / median)

**Purpose:** Reduce the filtered DataFrame to a single number or a group-by summary.

**Inputs:** filtered DataFrame; aggregation function; optional group-by column.

**Pandas idiom:**
```python
matched.shape[0]                                  # count
matched.tenure_years.mean()                       # mean
matched.groupby('department').size()              # count by group
matched.groupby('region').tenure_years.median()   # median by group
```

**Notes:** Aggregations always run on the *filtered* DataFrame, not the full file. Always state the matched-row count alongside any aggregation so the reader knows the denominator.

---

## F4 — Hierarchy-Join (manager-level inheritance + transitive chain)

**Purpose:** Resolve hierarchy-aware predicates that require manager-level inheritance ("managers at level ≥ M3") or transitive walks ("everyone under VP X").

**Inputs:** `manager_id`, `employee_id`, `ORG-chart.md` level convention.

**Pandas idiom (level inheritance, when `manager_level` is absent):**
```python
def compute_level(df):
    children = df.groupby('manager_id').size().to_dict()
    levels = {}
    def walk(eid):
        if eid in levels: return levels[eid]
        if eid not in children: levels[eid] = 'M0'; return 'M0'
        max_child = max(int(walk(c)[1:]) for c in df[df.manager_id == eid].employee_id)
        levels[eid] = f'M{max_child + 1}'
        return levels[eid]
    df.employee_id.apply(walk)
    return df.assign(manager_level=df.employee_id.map(levels))
```

**Pandas idiom (transitive subtree, "under VP X"):**
```python
def under(eid, df):
    direct = set(df[df.manager_id == eid].employee_id)
    frontier = list(direct)
    while frontier:
        next_layer = set(df[df.manager_id.isin(frontier)].employee_id) - direct
        direct |= next_layer
        frontier = list(next_layer)
    return df[df.employee_id.isin(direct)]
```

**Notes:** Computed once per run, cached in memory. Cite F4 in Logic when any hierarchy clause fires.

---

## F5 — Date-Range (predicate over date columns)

**Purpose:** Translate natural-language date phrases ("Q1 2026", "since 2024-01-01", "last 90 days") into explicit predicates.

**Inputs:** date-typed column from `Column.md`; phrase parser.

**Pandas idiom:**
```python
df[(df.hire_date >= '2026-01-01') & (df.hire_date < '2026-04-01')]   # Q1 2026
df[df.hire_date >= '2024-01-01']                                      # since 2024-01-01
df[df.hire_date >= (pd.Timestamp.today() - pd.Timedelta(days=90))]    # last 90 days
```

**Phrase resolution:** see `headcount-schema-dictionary.md` § *Date-Column Handling* for the canonical phrase → boundary table.

**Notes:** Always surface the resolved boundary dates in the `Filters applied` table's Reasoning column. Quarter and fiscal-year boundaries depend on org calendar — ask if ambiguous.

---

## F6 — Roll-up (parent-level aggregation via ORG-chart)

**Purpose:** Aggregate from leaf level up to a parent level in the manager hierarchy.

**Inputs:** filtered DataFrame; an aggregation function; a roll-up depth (e.g., `manager_level == 'M3'`) or a specific parent (e.g., "everyone under VP X").

**Pandas idiom (parent count via F4 subtree):**
```python
parents = df[df.manager_level == 'M3']
roll_up = {p.employee_id: under(p.employee_id, df).shape[0] for _, p in parents.iterrows()}
```

**Notes:** F6 composes F1 (parent filter) + F4 (subtree walk) + F3 (aggregate over each subtree). Cite all three in Logic.

---

## F7 — Top-N (rank within a filtered subset)

**Purpose:** Return the top or bottom N rows by a numeric column.

**Inputs:** filtered DataFrame; numeric column; N; direction.

**Pandas idiom:**
```python
matched.nlargest(10, 'tenure_years')
matched.groupby('department').size().nlargest(5)
```

**Notes:** Spot-check is capped at 10. If the user explicitly asks for more, surface the full count + a refinement suggestion ("This returns 47 rows — want me to narrow further?").

---

## F8 — Cross-Tab (group-by × group-by)

**Purpose:** Two-dimensional aggregation — e.g., "headcount by region × department".

**Inputs:** filtered DataFrame; two group-by columns; aggregation function.

**Pandas idiom:**
```python
pd.crosstab(matched.region, matched.department)
matched.pivot_table(index='region', columns='department', values='employee_id', aggfunc='count')
```

**Notes:** F8 is the heaviest output — render only when the question explicitly asks for two dimensions. Otherwise prefer F3 (single group-by). Suppress any cell where n<5 per `compliance-pii-guardrails.md` if the cross-tab targets a demographic dimension.

---

## Pattern Composition Cheat-Sheet

| User question shape | Pattern chain |
|---|---|
| "Show me X" (filter only) | F1 + F2 |
| "Count of X" | F1 + F3 |
| "Top N by Y" | F1 + F7 |
| "X by department" | F1 + F3 (group-by) |
| "X by region × department" | F1 + F8 |
| "Everyone under VP Y" | F4 (subtree) + F2 |
| "Managers at level ≥ M3" | F4 (level inheritance) + F1 + F2 |
| "Hires in Q1 2026" | F1 + F5 |
| "Headcount per VP" | F4 + F6 |

The Logic block should name every pattern in the chain, in order.
