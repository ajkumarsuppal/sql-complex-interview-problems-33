/* ============================================================
 Problem 05 — Employee Relationship Management
 alt-solution.sql
 
 Purpose:
 - Capture multiple valid ways to solve the problem
 - Show progression from group reasoning → filtering employees
 - Compare JOIN, EXISTS, and WINDOW FUNCTION approaches
 ============================================================ */
-- ------------------------------------------------------------
-- 0. Inspect base data
-- ------------------------------------------------------------
-- One row represents one employee
select
    *
from
    emp_salary;

-- ------------------------------------------------------------
-- 1. Identify department–salary combinations shared by >1 employee
-- ------------------------------------------------------------
-- This query works at GROUP grain:
-- One row = one (dept_id, salary) combination
-- It answers: which combinations are shared?
with cte as (
    select
        dept_id,
        salary,
        count(emp_id) as cnt
    from
        emp_salary
    group by
        dept_id,
        salary
    having
        count(emp_id) > 1
)
select
    *
from
    cte;

-- ------------------------------------------------------------
-- 2. GROUP BY + JOIN approach (two-phase logic)
-- ------------------------------------------------------------
-- Phase 1: Find qualifying (dept_id, salary) groups
-- Phase 2: Return all employees belonging to those groups
--
-- This approach is explicit and very reviewer-friendly.
with cte as (
    select
        dept_id,
        salary,
        count(emp_id) as cnt
    from
        emp_salary
    group by
        dept_id,
        salary
    having
        count(emp_id) > 1
)
select
    e.emp_id,
    e.name,
    e.salary,
    e.dept_id
from
    emp_salary e
    join cte on e.dept_id = cte.dept_id
    and e.salary = cte.salary;

-- ------------------------------------------------------------
-- 3. EXISTS-based approach (correlated subquery)
-- ------------------------------------------------------------
-- For each employee:
-- Ask whether their (dept_id, salary) group has more than one member
--
-- This reads close to business logic and is often optimized
-- as a semi-join by the SQL engine.
select
    e.emp_id,
    e.name,
    e.salary,
    e.dept_id
from
    emp_salary e
where
    exists (
        select
            1
        from
            emp_salary x
        where
            x.dept_id = e.dept_id
            and x.salary = e.salary
        group by
            x.dept_id,
            x.salary
        having
            count(x.emp_id) > 1
    );

-- ------------------------------------------------------------
-- 4. Window function approach (row-aware grouping)
-- ------------------------------------------------------------
-- Instead of collapsing rows, this approach:
-- - Keeps row grain = employee
-- - Annotates each row with group size
-- - Filters rows based on that annotation
--
-- This avoids joins and is often the cleanest expression.
select
    e.emp_id,
    e.name,
    e.salary,
    e.dept_id
from
    (
        select
            e.emp_id,
            e.name,
            e.salary,
            e.dept_id,
            count(*) over (partition by dept_id, salary) as cnt
        from
            emp_salary e
    ) e
where
    e.cnt > 1;