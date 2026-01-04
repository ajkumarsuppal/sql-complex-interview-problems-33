# Hospital Management — Explanation

## Problem Restatement
The hospital maintains a log of employee movements using `in` and `out` actions with timestamps.
Each row represents a single event for an employee.

The task is to determine the **total number of people currently present inside the hospital** based on the available event history.

---

## Business Interpretation
An employee is considered **present inside the hospital** if their **most recent recorded action** is `in`.

If the most recent action is `out`, the employee is considered outside, regardless of any earlier `in` events.

---

## Technical Interpretation
The table contains multiple rows per employee, representing a sequence of events over time.
To determine the current state of each employee:

1. The event history must be reduced to the **latest event per employee**.
2. The action associated with that event determines whether the employee is inside or outside.
3. Employees whose latest action is `in` are counted.

---

## Solution Walkthrough

### Step 1: Identify the latest event per employee
A common table expression (CTE) is used to compute the maximum timestamp for each `emp_id`.

```sql
select max(time) as maxtime, emp_id
from hospital
group by emp_id
```
This collapses the event history to one row per employee, identifying their most recent activity.

---
## Step 2: Retrieve the action at the latest timestamp
The result of the first CTE is joined back to the `hospital` table to retrieve the action associated with the latest timestamp.

Only rows where the action is `in` are retained.

### This ensures that:
- The employee’s final state is evaluated
- Earlier events do not influence the result
---
## Step 3: Count employees currently inside

The final query counts the number of employees whose most recent action is in, producing a single scalar result.
---
## Assumptions
- The `time` column correctly represents the chronological order of events.
- Each employee has at most one event at their maximum timestamp.
- Valid action values are limited to `in` and `out`.
- “Currently present” refers to the state as of the latest recorded event.
---
## Edge Case Handling
- Employees with only an out record are correctly excluded.
- Employees who exit and re-enter are evaluated based solely on their latest action.
- Employees with a single in record are correctly included.
---
## Alternative Approaches (Summary)
- An alternative approach explored during development involved identifying the latest timestamp per `(emp_id, action)`.
- This was rejected because it produces multiple rows per employee and does not resolve a single final state.
- The chosen approach was preferred for clarity, correctness, and explicit state resolution.
---
## Conclusion

By resolving each employee’s final state based on their most recent event and aggregating only those whose state is in, the solution correctly and deterministically computes the number of people currently present inside the hospital.