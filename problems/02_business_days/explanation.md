# Explanation — Business Days Excluding Weekends and Public Holidays (Problem 02)

## Problem Statement

Given a set of support tickets with a `create_date` and a `resolved_date`, calculate the number of **business days** taken to resolve each ticket.

A **business day** is defined as:
- A weekday (Monday to Friday)
- That is **not** a public holiday

Weekends (Saturday and Sunday) and public holidays must be excluded from the count.

---

## Schema Overview

### tickets
- `ticket_id`
- `create_date`
- `resolved_date`

### holidays
- `holiday_date`
- `reason`

Each ticket represents a date range that must be evaluated day by day.

---

## High-Level Approach

This solution models **time as data**, not as a mathematical difference.

Instead of attempting to calculate business days using `DATEDIFF` and adjustments, we:
1. Expand each ticket into **one row per calendar date**
2. Classify each date as:
   - weekday vs weekend
   - holiday vs non-holiday
3. Aggregate only the rows that qualify as business days

This approach prioritizes:
- correctness
- explainability
- extensibility

---
## Step 1 — Ticket-Aware Date Expansion (Recursive CTE)
The first step is to generate **one row per date per ticket**, from `create_date` to `resolved_date` (inclusive).
```sql
WITH daterange AS (
    SELECT
        ticket_id,
        create_date,
        create_date AS curr_date,
        resolved_date
    FROM tickets

    UNION ALL

    SELECT
        ticket_id,
        create_date,
        DATEADD(DAY, 1, curr_date),
        resolved_date
    FROM daterange
    WHERE curr_date < resolved_date
)
```
### Why recursion?
- Each ticket has a dynamic date range
- SQL Server does not provide a built-in date sequence generator
- Recursive CTEs allow us to express row-by-row date progression
- UNION ALL is mandatory for recursion to preserve intermediate states.
---
## Step 2 — Row-Level Classification
Each generated date is enriched with attributes that determine whether it qualifies as a `business day`.
```sql
classified_dates AS (
    SELECT
        d.*,
        DATENAME(WEEKDAY, curr_date) AS day_name,
        CASE 
            WHEN h.holiday_date IS NULL THEN 0
            ELSE 1
        END AS is_holiday,
        CASE 
            WHEN DATENAME(WEEKDAY, curr_date) IN ('Saturday', 'Sunday') THEN 0
            ELSE 1
        END AS is_weekday
    FROM daterange d
    LEFT JOIN holidays h
        ON h.holiday_date = d.curr_date
)

```
## Design decisions
- LEFT JOIN is used to mark holidays, not filter them out
- Weekends and holidays are treated as independent exclusion rules
- Classification happens at row level to preserve explainability

This ensures:
- No double-exclusion when a holiday falls on a weekend
- Full transparency during debugging and review
---
## Step 3 — Business Day Aggregation
A business day is defined as:
```
is_weekday = 1 AND is_holiday = 0
```
```sql
SELECT
    ticket_id,
    SUM(
        CASE 
            WHEN is_weekday = 1 AND is_holiday = 0 THEN 1
            ELSE 0
        END
    ) AS business_days
FROM classified_dates
GROUP BY ticket_id
ORDER BY ticket_id;

```
## Why conditional aggregation?
- Keeps logic explicit and readable
- Avoids prematurely filtering rows
- Easier to extend (half-days, SLAs, region-specific calendars)

## Results Validation
| ticket_id | business_days |
| --------- | ------------- |
| 1         | 3             |
| 2         | 9             |
| 3         | 10            |

## Each result aligns with:
- weekday exclusion
- holiday exclusion
- inclusive date boundaries

## Boundary Assumptions
- Both create_date and resolved_date are included
- Holidays occurring on weekends do not reduce business days twice
- Weekday names are evaluated using English locale (DATENAME)

These assumptions are consistent across the solution and should be documented in real-world systems.

## Alternative Approaches Considered
### 1. Mathematical DATEDIFF-based logic
- Faster
- Harder to reason about
- Error-prone with edge cases
### 2. Pre-built calendar table
- Ideal in production systems
- Not available in this problem
### 3. EXISTS / NOT EXISTS filtering
- Viable alternative
- Less transparent than row-level classification

The chosen approach prioritizes clarity and correctness over brevity.

## Why This Is the Primary Solution
- Explicit modeling of time
- Strong debugging and explainability
- Naturally handles overlapping rules
- Extensible to real-world scenarios