-- Primary solution.
-- Chosen as default for readability and extensibility.
with mxt as (
    select
        max(time) as maxtime,
        emp_id
    from
        hospital
    group by
        emp_id
),
filter_action as (
    select
        mxt.emp_id,
        action
    from
        mxt
        join hospital on hospital.emp_id = mxt.emp_id
    where
        hospital.time = maxtime
        and hospital.action = 'in'
)
select
    count(emp_id) as total_employees_checked_in
from
    filter_action;