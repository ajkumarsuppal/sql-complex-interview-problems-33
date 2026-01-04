# Problem 03 — Hospital Management

## Problem Summary
The hospital maintains a log of employee entry and exit events using `in` and `out` actions with timestamps.

The objective is to determine the **total number of people currently present inside the hospital** based on this event history.

---

## Data Model
The `hospital` table records movement events:

- `emp_id` — unique identifier for an employee
- `action` — either `in` or `out`
- `time` — timestamp of the event

Each employee can have multiple events over time.

---

## Key Insight
An employee’s current presence in the hospital is determined solely by their **most recent recorded action**:

- Latest action = `in` → employee is inside
- Latest action = `out` → employee is outside

Earlier events do not affect the current state.

---

## Approach Overview
The solution follows three clear steps:

1. Identify the **latest timestamp per employee**
2. Retrieve the action associated with that timestamp
3. Count employees whose final action is `in`

This approach treats the problem as a **state resolution problem**, not a simple count of events.

---

## Files in This Folder

| File | Purpose |
|-----|--------|
| `schema.sql` | Table definition |
| `seed.sql` | Sample data for validation |
| `solution.sql` | Final, production-ready solution |
| `alt-solution.sql` | Exploratory and intermediate queries |
| `explanation.md` | Detailed explanation and justification |
| `design-thinking.md` | Reasoning journey and key insights |
| `expected_output.csv` | Expected query result |
| `diagram.md` | Logical representation of the solution |

---

## How to Run
1. Execute `schema.sql`
2. Execute `seed.sql`
3. Run `solution.sql`

---

## Expected Output
A single-row result containing the total number of employees currently inside the hospital.


---

## Notes
- The solution assumes timestamps correctly represent event order.
- Each employee has at most one event at their latest timestamp.
- The focus is on clarity, correctness, and explainability.
