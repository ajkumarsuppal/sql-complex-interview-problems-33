--Write a query to find the total number of people present inside the hospital.
-- exploring tables
select
   *
from
   hospital
order by
   emp_id,
   time;

--The CTE identifies the latest recorded time for each employee. Joining back to the hospital table retrieves the event that occurred at that time. Filtering on action = 'in' then selects only those employees whose most recent action indicates they are currently inside the hospital.
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