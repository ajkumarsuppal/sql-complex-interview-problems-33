-- Primary solution.
-- Chosen as default for readability and extensibility.
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