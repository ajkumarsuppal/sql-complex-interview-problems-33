
---

## 🧠 `design-thinking.md`

# Design Thinking — Hospital Management

## Initial Understanding
The table logs entry and exit events for employees.
The phrase “people present inside the hospital” implies a *current state*, not a historical count.

This immediately suggested that the latest event per employee is what matters.

---

## Early Thoughts
The first instinct was to look at `in` and `out` counts, but that approach felt fragile:
- Employees can exit and re-enter
- The table does not represent a running total
- There is no guaranteed starting state

So the problem felt more like a **state resolution problem** than a counting problem.

---

## First Exploration
An early query grouped by `emp_id` and `action` to find the maximum time per action.
This exposed a flaw:
- It returned two rows per employee if both actions existed
- It failed to collapse history into a single state

That made it clear that `action` could not be part of the grouping key.

---

## Key Insight
The unit of truth is the **employee**, not the event type.

The correct approach had to:
1. Reduce each employee’s history to exactly one row
2. Determine the action at that point in time

Only after that could counting be done safely.

---

## Refined Approach
The solution was broken into logical steps:
- Identify the latest timestamp per employee
- Join back to retrieve the corresponding action
- Filter to employees whose final action is `in`
- Count the result

This structure made correctness easy to reason about and easy to explain.

---

## Final Check
Before finalizing, the solution was validated against:
- Employees with multiple transitions
- Employees with only `out` events
- Employees whose first event was `out`

In all cases, evaluating only the most recent action produced the correct state.

---

## Takeaway
This problem reinforced the importance of:
- Separating **state determination** from **aggregation**
- Being explicit about assumptions
- Avoiding clever shortcuts that hide logic

The final solution prioritizes clarity and correctness over compactness.
