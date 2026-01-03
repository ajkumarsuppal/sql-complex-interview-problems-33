--1.run the table
select
    *
from
    dbo.events;

--groups players who won gold and their count. list includes player names that are present in silver and bronze columns as well
select
    gold as player_name,
    count(*) as gold_medal_count
from
    events
group by
    gold;

--groups players who won gold and their count. list excludes player names that are present in silver and bronze columns as well
--union all because uniqueness is not required. occuring once or multiple times doesn't change the outcome. avoid unnecessary deduplication step
select
    gold as player_name,
    count(*) as gold_medal_count
from
    events
where
    gold not in (
        select
            silver
        from
            events
        union all
        select
            bronze
        from
            events
    )
group by
    gold;


--approach two: group by having cte
--we will first select all player and their medal_type
select gold as player_name from events
union all
select silver from events
union all
select bronze from events;

--then we add their medal_type for every entry. we will get 36 entries
select gold as player_name,'GOLD' as medal_type from events
union all
select silver, 'SILVER' as medal_type from events
union all
select bronze,'BRONZE' as medal_type from events;

--now we use cte
with cte as (
select gold as player_name,'GOLD' as medal_type from events
union all
select silver, 'SILVER' as medal_type from events
union all
select bronze,'BRONZE' as medal_type from events
)
SELECT  player_name,
    count(1) as gold_medal_count
FROM cte
GROUP BY player_name
HAVING max(medal_type) = 'GOLD';

--not exists
SELECT
  e.GOLD AS player_name,
  COUNT(*) AS gold_medal_count
FROM dbo.events AS e
WHERE e.GOLD IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM dbo.events AS x
    WHERE x.SILVER = e.GOLD
       OR x.BRONZE = e.GOLD
  )
GROUP BY e.GOLD
ORDER BY gold_medal_count DESC, player_name;
