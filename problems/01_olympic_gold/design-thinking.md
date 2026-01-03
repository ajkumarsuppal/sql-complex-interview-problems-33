
Key observations
•	Medal types are stored as columns, not rows.
•	The same swimmer name can appear:
o	As GOLD in one event
o	As SILVER or BRONZE in another event
•	Therefore, simply counting gold medals is not sufficient.
•	This modeling choice directly influences the solution approach.
________________________________________
3. Step-by-step reasoning toward a solution
Step 3.1 — Count gold medals without constraints
The first logical step was to count gold medals per swimmer:
SELECT
  gold AS player_name,
  COUNT(*) AS gold_medal_count
FROM dbo.events
GROUP BY gold;
What this achieves
•	Groups rows by gold medal winner
•	Counts how many times each swimmer won gold
Why this is insufficient
This result includes swimmers who:
•	Won gold in some events
•	But also won silver or bronze in others
This violates the problem requirement of exclusive gold winners.
________________________________________
Step 3.2 — Identify swimmers who must be excluded
To enforce exclusivity, we must:
•	Detect swimmers who ever appear in SILVER or BRONZE
•	Exclude them entirely, even if they have gold medals
This leads to the key logical requirement:
For a given gold medal winner, ensure that no row exists where the same swimmer appears as silver or bronze.
________________________________________
4. Alternative solution approaches considered
Before finalizing the solution, multiple valid approaches were explored.
________________________________________
4.1 Alternative 1 — NOT IN with UNION ALL
SELECT
  gold AS player_name,
  COUNT(*) AS gold_medal_count
FROM dbo.events
WHERE gold IS NOT NULL
  AND gold NOT IN (
    SELECT silver FROM dbo.events WHERE silver IS NOT NULL
    UNION ALL
    SELECT bronze FROM dbo.events WHERE bronze IS NOT NULL
  )
GROUP BY gold;
Logic
•	Build a combined list of all swimmers who won silver or bronze
•	Exclude any gold medalist whose name appears in that list
Why UNION ALL
•	We only care about existence, not uniqueness
•	A swimmer appearing once or multiple times does not change the outcome
•	Avoids unnecessary deduplication overhead
Drawbacks
•	NOT IN is sensitive to NULL values
•	Requires explicit NULL guarding to remain correct
•	More fragile if future schema or data changes introduce unexpected NULLs
________________________________________
4.2 Alternative 2 — CTE with medal normalization (UNPIVOT-style)
WITH medals AS (
  SELECT GOLD AS player_name, 'GOLD' AS medal_type FROM dbo.events
  UNION ALL
  SELECT SILVER, 'SILVER' FROM dbo.events
  UNION ALL
  SELECT BRONZE, 'BRONZE' FROM dbo.events
)
SELECT
  player_name,
  COUNT(*) AS gold_medal_count
FROM medals
GROUP BY player_name
HAVING MAX(medal_type) = 'GOLD';
Logic
•	Convert medal columns into rows
•	Aggregate per swimmer
•	Keep only swimmers whose maximum medal type is GOLD
Strengths
•	Expressive and flexible
•	Useful when extending logic (weights, rankings, time windows)
Drawbacks
•	More verbose
•	More transformations than required for this problem
•	Slightly harder to reason about for simple exclusion logic
________________________________________
5. Final (primary) solution — NOT EXISTS
After evaluating alternatives, the following solution was chosen as the primary implementation:
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
________________________________________
6. Why NOT EXISTS was chosen as the primary approach
6.1 Logical clarity
The query reads directly as:
“Select gold medal winners for whom no record exists where they appear as silver or bronze.”
This maps exactly to the problem statement.
________________________________________
6.2 NULL safety
•	NOT EXISTS is inherently safe with respect to NULL values
•	It does not suffer from the three-valued logic pitfalls of NOT IN
•	This makes it robust to future data changes
________________________________________
6.3 Performance considerations
•	SQL Server optimizes NOT EXISTS as an anti-semi join
•	The engine can short-circuit once a match is found
•	Indexes on SILVER or BRONZE can be leveraged efficiently
For both current and scaled datasets, this approach is reliable and performant.
________________________________________
6.4 Maintainability
•	Easy to extend if additional exclusion conditions are added
•	Minimal restructuring required
•	Clear intent for future reviewers
________________________________________
7. Assumptions and limitations
•	Swimmer names are assumed to be consistent across rows
•	No surrogate athlete identifier exists
•	Medal columns are mutually exclusive per event
In a production system:
•	Athlete IDs would replace names
•	Medals would likely be stored as rows, not columns

