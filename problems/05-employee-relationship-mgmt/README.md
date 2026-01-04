# Problem 05 — Employee Relationship Management

## Problem Summary
Return all employees whose salary is the same within the same department.

Only employees who share their department–salary combination with at
least one other employee should be included.

---

## Data Model
The `emp_salary` table contains:

- `emp_id` — employee identifier
- `name` — employee name
- `salary` — salary value
- `dept_id` — department identifier

Each row represents one employee.

---

## Key Insight
This problem is a **group-filtering problem**:

- Group employees by `(dept_id, salary)`
- Keep only groups with more than one employee
- Return all employees belonging to those groups

The output grain remains at the employee level.

---

## Approach Overview
The chosen solution uses a window function:

1. Partition employees by department and salary
2. Compute group size per employee
3. Filter employees whose group size is greater than one

This avoids unnecessary joins while keeping the logic explicit.

---

## Files in This Folder

| File | Purpose |
|-----|--------|
| `schema.sql` | Table definition |
| `seed.sql` | Sample employee data |
| `solution.sql` | Final solution using window functions |
| `alt-solution.sql` | JOIN, EXISTS, and window-based alternatives |
| `explanation.md` | Technical and business explanation |
| `design-thinking.md` | Reasoning process and insights |
| `expected_output.csv` | Expected result set |

---

## How to Run
1. Execute `schema.sql`
2. Execute `seed.sql`
3. Run `solution.sql`

---

## Expected Output
Employees who share salary values within the same department.
