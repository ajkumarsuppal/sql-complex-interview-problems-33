# Problem 04 — Hotel Room Search Count

## Problem Summary
Users search for hotel rooms using one or more room-type filters.
Each search event may include multiple room types, stored as a comma-separated list.

The objective is to identify **which room types are searched the most**, along with the
number of searches for each room type, ordered by search count in descending order.

---

## Data Model
The `airbnb_searches` table captures hotel search events:

- `user_id` — identifier of the user performing the search
- `date_searched` — date of the search
- `filter_room_types` — comma-separated list of room types selected during the search

A single row represents **one search event**, but may contain multiple room types.

---

## Key Insight
This problem is not primarily about aggregation—it is about **data normalization**.

Important considerations:
- A single search may include multiple room types.
- Each **unique room type within a search** should be counted once.
- Duplicate room types within the same search do not represent additional intent.
- Empty or malformed room-type values must be ignored.

---

## Approach Overview
The solution follows these steps:

1. Normalize the comma-separated `filter_room_types` column into rows
2. Trim whitespace and remove empty values
3. Deduplicate room types **per search event**
4. Aggregate counts by room type
5. Sort results by search count in descending order

This ensures that each room-type search intent is counted correctly.

---

## Files in This Folder

| File | Purpose |
|-----|--------|
| `schema.sql` | Table definition |
| `seed.sql` | Sample data including edge cases |
| `solution.sql` | Final, production-ready solution |
| `alt-solution.sql` | Exploratory queries and rejected approaches |
| `explanation.md` | Detailed technical and business explanation |
| `design-thinking.md` | Chronological reasoning and key insights |
| `expected_output.csv` | Expected query result |
| `diagram.md` | Logical representation of the transformation |

---

## How to Run
1. Execute `schema.sql`
2. Execute `seed.sql`
3. Run `solution.sql`

---

## Expected Output
A result set containing each room type and the number of searches for it,
sorted in descending order of search count.

Example:

|room_type | no_of_searches|
|----------|----------------|
|private room | 4|
|entire home | 2|
|shared room | 2|


---

## Notes
- Deduplication is intentionally scoped to a single search event.
- The solution prioritizes correctness and clarity over brevity.
- Intermediate exploration is preserved in `alt-solution.sql` for learning purposes.
