# Column Dictionary

This file is **loaded at runtime by the GPT** and is **user-overridable** — upload a sidecar with the same name, or supply an inline alias map at the start of the chat, to take precedence over these defaults.

## How the GPT uses this file

1. The Parse-First Metadata Scan reads the literal headers from the user's uploaded `.xlsx`/`.csv`.
2. For each clause in the user's natural-language question, the GPT resolves it to a literal header by walking this dictionary:
   - First, exact match on the canonical name.
   - Else, match against the alias list (case-insensitive).
   - Else, match against the regex search-pattern.
3. If no match is found, the GPT halts and asks the user for an inline alias map rather than guessing.

## Canonical Columns

Each row defines a **canonical name** (used in Logic blocks), a list of **aliases** (case-insensitive header variants), a **regex search-pattern** for fuzzy matching, the column's **type**, and notes.

| Canonical | Aliases | Regex | Type | Notes |
|---|---|---|---|---|
| `employee_id` | `emp_id`, `eid`, `employee_number`, `EmpNum`, `PersonID` | `^(employee\|emp\|person)[_ ]?(id\|number\|num)$` | string | PII; primary identifier |
| `name` | `full_name`, `employee_name`, `display_name` | `^(full[_ ]?)?name$` | string | PII |
| `email` | `work_email`, `corp_email`, `email_address` | `^(work[_ ]?\|corp[_ ]?)?email([_ ]?address)?$` | string | PII |
| `manager_id` | `mgr_id`, `manager_employee_id`, `supervisor_id`, `ReportsTo` | `^(manager\|mgr\|supervisor\|reports[_ ]?to)[_ ]?(id\|emp[_ ]?id)?$` | string | FK to `employee_id`; used by `ORG-chart.md` for hierarchy |
| `manager_level` | `mgr_level`, `mgmt_level`, `level`, `band` | `^(manager\|mgr\|management\|mgmt\|level\|band)$` | string | M0…Mn; computed via `ORG-chart.md` if absent |
| `department` | `dept`, `org`, `function`, `team` | `^(department\|dept\|org\|function\|team)$` | string | Org grouping |
| `region` | `geo`, `geography`, `location_region` | `^(region\|geo\|geography)$` | string | EMEA / AMER / APAC |
| `country` | `nation`, `location_country` | `^(country\|nation)$` | string | ISO-3166 preferred |
| `location` | `office`, `site`, `work_location` | `^(location\|office\|site\|work[_ ]?location)$` | string | City or office |
| `job_title` | `title`, `role`, `position` | `^(job[_ ]?)?(title\|role\|position)$` | string | |
| `job_family` | `discipline`, `function_family` | `^(job[_ ]?family\|discipline)$` | string | |
| `hire_date` | `start_date`, `join_date`, `date_hired`, `OnboardDate` | `^(hire\|start\|join\|onboard)[_ ]?date$` | date | ISO 8601 preferred |
| `term_date` | `end_date`, `exit_date`, `separation_date`, `LastDay` | `^(term\|end\|exit\|separation\|last[_ ]?day)[_ ]?date?$` | date | Null while active |
| `tenure_years` | `years_of_service`, `yos`, `tenure` | `^(tenure([_ ]?years\|yos)?\|years[_ ]?of[_ ]?service\|yos)$` | float | Computed from `hire_date` if absent |
| `employment_status` | `status`, `active_flag` | `^(employment[_ ]?)?status$\|^active([_ ]?flag)?$` | string | Active / Inactive / On Leave |
| `employment_type` | `emp_type`, `worker_type` | `^(emp(loyment)?\|worker)[_ ]?type$` | string | FTE / Contractor / Intern |
| `salary_band` | `comp_band`, `pay_band`, `grade` | `^(salary\|comp\|pay)[_ ]?(band\|grade)$\|^grade$` | string | |
| `cost_center` | `cc`, `cost_centre`, `cost_center_code` | `^(cost[_ ]?cent(er\|re)([_ ]?code)?\|cc)$` | string | |

## How to override

**Option 1 — sidecar upload:** drop a file named `Column.md` into the chat at the start of the run. The sidecar replaces this dictionary for that run.

**Option 2 — inline alias map:** if your file uses headers that don't match any canonical / alias / regex, paste a JSON map at the start of the chat:

```
{
  "<your_header_a>": "employee_id",
  "<your_header_b>": "manager_id",
  "<your_header_c>": "hire_date"
}
```

The GPT records every applied alias in the run footer.

## Notes

- This is a **placeholder dictionary** — populate with the canonical column set your organization actually uses.
- Regex patterns are matched case-insensitively against the literal header strings from the Parse-First scan.
- Date columns are coerced via `pd.to_datetime` after resolution; date-range filter clauses ("Q1 2026", "since 2024-01-01", "last 90 days") are expanded into explicit `>=` / `<` / `BETWEEN` predicates against these columns.
- Columns marked **PII** may be returned verbatim — this dataset is HR-internal. Demographic-attribute filters (race, religion, gender) are gated by `compliance-pii-guardrails.md`.
