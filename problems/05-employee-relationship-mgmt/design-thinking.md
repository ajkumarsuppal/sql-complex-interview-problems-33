# Design Thinking — Employee Relationship Management

## Initial Impression
At first glance, the problem appeared simple:
“employees with the same salary in the same department.”

However, early attempts at self-joining revealed that the problem
was not about comparing rows directly.

---

## Key Realization
The important insight was that the comparison unit is not the employee,
but the **(dept_id, salary) group**.

Employees should be included only if their group contains more than
one member.

---

## Early Misstep
An early self-join attempt compared employees to themselves, which
provided no meaningful filtering. This highlighted that the problem
was not row-based, but group-based.

---

## Reframing the Problem
The problem was reframed into two phases:

1. Identify department–salary groups with more than one employee
2. Return employees belonging to those groups

This reframing made the solution space much clearer.

---

## Exploring Multiple Approaches
Three valid approaches were explored:
- GROUP BY + JOIN
- EXISTS with correlated subquery
- Window functions

Each approach expressed the same logic at a different level of abstraction.

---

## Final Choice
The window-function approach was selected as the primary solution
because it:
- Keeps row-level detail intact
- Avoids joins and subqueries
- Makes the group relationship explicit per employee

---

## Key Takeaways
- Group-level logic can still produce row-level results
- Window functions are ideal when rows need awareness of group properties
- Understanding data grain is more important than SQL syntax
