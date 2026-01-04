# Employee Relationship Management — Explanation

## Problem Restatement
Given an employee table containing department and salary information,
return all employees whose **salary is the same within the same department**.

Only employees who share a department–salary combination with at least
one other employee should be included in the result.

---

## Business Interpretation
Each employee belongs to a department and earns a salary.
If multiple employees within the same department earn the same salary,
all such employees should be returned.

Employees whose department–salary combination is unique are excluded.

---

## Technical Interpretation
The problem requires identifying `(dept_id, salary)` combinations
that occur more than once, and then returning all employees that belong
to those combinations.

This is not a row-by-row comparison problem, but a **group-level filtering**
problem where the output grain remains at the employee level.

---

## Solution Walkthrough

### Step 1: Define the grouping key
The relevant grouping key is:
`(dept_id, salary)`

Employees sharing this key belong to the same comparison group.

---

### Step 2: Annotate employees with group size
A window function is used to compute how many employees belong to each
`(dept_id, salary)` group:

- `PARTITION BY dept_id, salary` defines the group
- `COUNT(*) OVER (...)` computes group size
- The result is attached to each employee row

---

### Step 3: Filter qualifying employees
Employees whose group size is greater than 1 are returned.
This ensures:
- No duplicate counting
- No loss of row-level detail
- Clear alignment with business rules

---

## Assumptions
- Employees with NULL `dept_id` or `salary` are not considered comparable
- Salary comparison is equality-based (no numeric ordering required)
- Departments are independent from one another

---

## Alternative Approaches
Two alternative approaches were explored:

1. **GROUP BY + JOIN**  
   Explicit two-phase approach that first finds qualifying groups and
   then joins back to employees.

2. **EXISTS-based filtering**  
   Uses a correlated subquery to check group membership per employee.

Both approaches are correct, but the window-function solution was chosen
for its clarity and expressiveness.

---

## Conclusion
By combining row-level detail with group-level awareness using window
functions, the solution cleanly identifies employees who share salary
values within the same department without unnecessary joins or complexity.
