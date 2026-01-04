-- exploring tables
select
   *
from
   tickets;

select
   *
from
   holidays;

select
   create_date,
   DATENAME(W, create_date) --, DAY(create_date) --gives day number of month 
,
   resolved_date,
   DATENAME(DW, resolved_date)
   /*'W' or 'WEEKDAY' or 'DW' gives name of day in DATENAME*/
,
   DATEPART(Weekday, resolved_date)
   /*gives saturday as 7 and sunday as 1 using W or Weekday or DW*/
from
   tickets;

--
select
   ticket_id,
   create_date,
   DATEDIFF(DAY, create_date, resolved_date) as diff,
   resolved_date
from
   tickets;

--this gives me dates between 2 dates which is essential to figure out days b/w create_date and resolved_date
declare @startdate date = '2022-08-01';

declare @enddate date = '2022-08-03';

with daterange as (
   select
      @startdate as datevalue
   UNION
   ALL
   select
      DATEADD(day, 1, datevalue)
   from
      daterange
   where
      datevalue < @enddate
)
select
   datevalue
from
   daterange;

--we need to join this logic to our tickets table and then later join holidays table too
--For each ticket, generate one row per calendar date between create_date and resolved_date.
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
)
select
   ticket_id,
   create_date,
   curr_date,
   DATEPART(weekday, create_date) as sunday1_to_saturday7,
   DATENAME(weekday, curr_date),
   resolved_date
from
   daterange
order by
   ticket_id;

--
with daterange as (
   select
      ticket_id,
      create_date as curr_date,
      resolved_date
   from
      tickets --where ticket_id=1
   UNION
   ALL
   select
      ticket_id,
      dateadd(day, 1, curr_date),
      resolved_date
   from
      daterange
   where
      curr_date < resolved_date --and ticket_id=1
)
select
   ticket_id,
   count(1) as calendar_days,
   sum(
      case
         when DATENAME(weekday, curr_date) in ('Saturday', 'Sunday') then 0
         else 1
      end
   ) as no_of_business_days
from
   daterange -- where
   --    ticket_id = 1
GROUP BY
   ticket_id;

--For each generated date, you can now see whether it is a holiday or not.
with daterange as (
   select
      ticket_id,
      create_date as curr_date,
      resolved_date
   from
      tickets --where ticket_id=1
   UNION
   ALL
   select
      ticket_id,
      dateadd(day, 1, curr_date),
      resolved_date
   from
      daterange
   where
      curr_date < resolved_date --and ticket_id=1
)
select
   *
from
   daterange
   left JOIN holidays on holidays.holiday_date = daterange.curr_date;

--
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
)
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
   left JOIN holidays h on h.holiday_date = d.curr_date;

--A business day is a row where is_weekday = 1 AND is_holiday = 0
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