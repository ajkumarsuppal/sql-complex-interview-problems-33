/* ============================================================
 Problem 04 — Hotel Room Search Count
 alt-solution.sql
 
 Purpose:
 - Capture exploratory queries
 - Show normalization of comma-separated values
 - Document pitfalls (accidental deduplication)
 - Demonstrate why per-search deduplication is required
 
 This file is intentionally NOT minimal.
 ============================================================ */
-- ------------------------------------------------------------
-- 0. Raw data inspection
-- ------------------------------------------------------------
-- Understand the shape of the input and validate seed changes
select
    *
from
    airbnb_searches;

-- ------------------------------------------------------------
-- 1. Normalizing comma-separated room types (row explosion)
-- ------------------------------------------------------------
-- STRING_SPLIT is used to convert a delimited column into rows.
-- This is the required first step to restore 1NF.
-- At this stage:
--   - whitespace is not handled
--   - duplicates are not handled
--   - empty tokens are not handled
select
    value,
    a.*
from
    airbnb_searches a
    cross apply string_split(filter_room_types, ',') as split_values;

-- ------------------------------------------------------------
-- 2. ⚠️ Accidental deduplication (ANTI-PATTERN)
-- ------------------------------------------------------------
-- This query appears to deduplicate room types but actually
-- deduplicates on *all columns in a.* + value.
--
-- Why this is dangerous:
-- - If filter_room_types formatting changes, dedup breaks
-- - If new columns are added to the table, dedup breaks
-- - Deduplication is accidental, not intentional
--
-- This query is kept intentionally as a learning artifact.
select
    distinct value,
    a.*
from
    airbnb_searches a
    cross apply string_split(filter_room_types, ',') as split_values;

-- ------------------------------------------------------------
-- 3. Define search-event grain and normalize values
-- ------------------------------------------------------------
-- Business decision:
--   - One search event = (user_id, date_searched)
--   - Deduplication must happen PER search event
--   - Duplicate room types within the same search are meaningless
--
-- Technical steps:
--   - TRIM whitespace
--   - Remove empty values (after trimming)
--   - Deduplicate explicitly on (user_id, date_searched, room_type)
select
    distinct a.user_id,
    a.date_searched,
    trim(value) as room_type
from
    airbnb_searches a
    cross apply string_split(filter_room_types, ',') as split_values
where
    len(trim(value)) > 0
order by
    a.user_id,
    a.date_searched;

-- ------------------------------------------------------------
-- 4. ⚠️ Incorrect aggregation (over-counting)
-- ------------------------------------------------------------
-- This query counts room types directly after splitting.
-- It FAILS when a single search contains duplicate room types:
--
-- Example:
--   'private room,private room'
-- gets counted as 2 searches instead of 1.
--
-- This query is intentionally retained to show why
-- per-search deduplication is required.
select
    trim(value) as room_type,
    count(1) as no_of_searches
from
    airbnb_searches a
    cross apply string_split(filter_room_types, ',') as split_values
where
    len(trim(value)) > 0
group by
    trim(value)
order by
    no_of_searches desc;

-- ------------------------------------------------------------
-- 5. Correct aggregation using per-search deduplication
-- ------------------------------------------------------------
-- This CTE represents the canonical "clean" dataset:
--   - One row = one valid room-type search intent
--   - Duplicates within the same search are removed
--   - Empties are excluded
--
-- This shape is safe for global aggregation.
with deduplicated_searches as (
    select
        distinct a.user_id,
        a.date_searched,
        trim(value) as room_type
    from
        airbnb_searches a
        cross apply string_split(filter_room_types, ',') as split_values
    where
        len(trim(value)) > 0
)
select
    room_type,
    count(1) as no_of_searches
from
    deduplicated_searches
group by
    room_type
order by
    no_of_searches desc;