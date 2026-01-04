
---

# 🧠 `design-thinking.md`

```md
# Design Thinking — Business Days Calculation (Problem 02)

## Initial Interpretation

At first glance, this problem appears to be a date-difference calculation.
However, real-world business calendars introduce complexity:

- Weekends
- Public holidays
- Overlapping rules
- Boundary conditions

This makes naive `DATEDIFF` approaches insufficient.

---

## Key Insight

> Time should be modeled as **rows**, not as a number.

Once each date is represented explicitly, all business rules become classification problems rather than mathematical tricks.

---

## Exploration Path

### 1. Understand weekday behavior
- Verified `DATENAME` and `DATEPART`
- Observed `DATEFIRST` dependency
- Chose name-based weekday checks for clarity

### 2. Generate date ranges
- Started with scalar variables
- Transitioned to ticket-aware recursion
- Learned to avoid rejoining base tables inside recursion

### 3. Separate concerns
- Date generation
- Date classification
- Aggregation

Each step was validated independently.

---

## Why Classification Beats Filtering

Instead of:
```sql
WHERE weekday AND NOT holiday
```
## We chose:
- explicit flags (is_weekday, is_holiday)
- row-level visibility
- late aggregation

This mirrors real analytics pipelines and improves auditability.

Handling Edge Cases
|Scenario	        |Outcome
|-------------------|---------------------------------
|Holiday on weekend	|Excluded once
|Ticket starts/ends |on weekend	Automatically excluded
|Multiple holidays	|Naturally handled
|Long date ranges	|Controlled via recursion