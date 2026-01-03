-- Primary solution.
-- Chosen as default for readability and extensibility.
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