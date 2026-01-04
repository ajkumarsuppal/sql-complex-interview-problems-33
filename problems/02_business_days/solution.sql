-- Primary solution.
-- Chosen as default for readability and extensibility.
with daterange as (
    select
        ticket_id,
        create_date,
        create_date as curr_date,
        resolved_date
    from
        tickets --where ticket_id=1
    UNION
    ALL
    select
        ticket_id,
        create_date,
        dateadd(day, 1, curr_date),
        resolved_date
    from
        daterange
    where
        curr_date < resolved_date --and ticket_id=1
),
classified_dates as (
    select
        d.*,
        h.*,
        datename(WEEKDAY, curr_date) as day_name,
        (
            case
                when h.holiday_date is null then 0
                else 1
            end
        ) as is_holiday,
        (
            case
                when datename(WEEKDAY, curr_date) in ('Saturday', 'Sunday') then 0
                else 1
            end
        ) as is_weekday
    from
        daterange d
        left JOIN holidays h on h.holiday_date = d.curr_date
)
select
    ticket_id,
    sum(
        case
            when is_weekday = 1
            and is_holiday = 0 then 1
            else 0
        end
    ) as business_days
from
    classified_dates
group by
    ticket_id
order by
    ticket_id;