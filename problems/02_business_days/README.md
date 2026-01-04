# 02 — Business Days Excluding Weekends and Public Holidays

## Problem

Write a SQL query to calculate the number of **business days** taken to resolve each ticket, given a `create_date` and a `resolved_date`.

A **business day** is defined as:
- A weekday (Monday to Friday)
- That is **not** a public holiday

Weekends (Saturday and Sunday) and public holidays must be excluded from the count.

---

## Data Model

### tickets
- `ticket_id`
- `create_date`
- `resolved_date`

### holidays
- `holiday_date`
- `reason`

Each ticket represents a date range that must be evaluated day by day.

---

## Approaches Included

This problem is solved using a **row-based time modeling approach**, rather than a purely mathematical date difference.

### Primary Approach (solution.sql)
- Recursive CTE to expand each ticket into one row per calendar date
- Row-level classification of:
  - weekday vs weekend
  - holiday vs non-holiday
- Conditional aggregation to count valid business days

This approach prioritizes:
- correctness
- explainability
- robustness to edge cases
- ease of extension (e.g., SLAs, regional calendars)

### Alternative Approaches (alt-solution.sql)
- Exploratory queries validating weekday behavior
- Discussion of:
  - `DATEDIFF`-based mathematical approaches
  - calendar-table based designs (real-world systems)
  - trade-offs between filtering vs classification
- Incremental reasoning used to arrive at the final solution

---

## How to Run Locally

1. Execute `schema.sql` to create tables
2. Execute `seed.sql` to insert sample data
3. Run `solution.sql` to compute business days per ticket
4. (Optional) Run queries in `alt-solution.sql` to explore alternative approaches

All scripts are written in **Microsoft SQL Server (T-SQL)** syntax.

---

## Expected Output

| ticket_id | business_days |
|----------|----------------|
| 1        | 3              |
| 2        | 9              |
| 3        | 10             |

Results are based on:
- inclusive date boundaries
- weekend exclusion
- holiday exclusion using the `holidays` table

---

## Notes & Assumptions

- Both `create_date` and `resolved_date` are treated as **inclusive**
- Holidays that fall on weekends do **not** reduce business days twice
- Weekday detection uses `DATENAME(WEEKDAY, ...)` and assumes English locale
- Recursive CTE uses `UNION ALL`, as required for deterministic recursion
- This solution favors clarity and correctness over brevity

---

## Why This Approach

Rather than treating time as a numeric difference, this solution models **time as data**.

By expanding each ticket into individual dates:
- business rules become explicit
- edge cases are easier to reason about
- logic is easier to validate and document

This mirrors how production systems handle calendars, SLAs, and operational analytics.

---

## Files in This Folder

- `schema.sql` — table definitions
- `seed.sql` — sample data
- `solution.sql` — primary, production-quality solution
- `alt-solution.sql` — exploratory and alternative approaches
- `explanation.md` — step-by-step reasoning and design decisions
- `design-thinking.md` — raw problem-solving and architectural thought process

---

## Skills Demonstrated

- Recursive CTEs
- Time-series modeling in SQL
- Business rule translation into data logic
- Edge-case handling
- Clear technical documentation
- Portfolio-grade SQL design
