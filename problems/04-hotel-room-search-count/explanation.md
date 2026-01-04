# Hotel Room Search Count — Explanation

## Problem Restatement
Users search for hotel rooms using one or more room-type filters.
Each search event may include multiple room types, stored as a comma-separated list.

The task is to determine **which room types are searched the most**, along with the
number of searches for each room type, sorted in descending order of search count.

If a single search includes multiple room types, each unique room type should be
counted independently.

---

## Business Interpretation
Each row in the table represents a **single search event** performed by a user on a
specific date.

Key business rules:
- A search may include multiple room types.
- Each room type in a search represents a distinct search intent.
- Duplicate room types within the same search do **not** represent additional intent
  and should be counted only once.
- Searches performed on different dates or by different users are independent.

---

## Technical Interpretation
The column `filter_room_types` contains comma-separated values, which violates
First Normal Form (1NF). To analyze search frequency correctly, the data must be
normalized so that:

- Each row represents **one room type per search event**
- Empty or invalid room types are excluded
- Deduplication occurs **per search event**, not globally

Once the data is normalized and deduplicated, a simple aggregation can be applied.

---

## Solution Walkthrough

### Step 1: Normalize comma-separated values
The solution uses `STRING_SPLIT` with `CROSS APPLY` to convert the
comma-separated `filter_room_types` column into multiple rows.

Each row now represents a candidate room type from a search.

---

### Step 2: Normalize and validate values
Whitespace is removed using `TRIM`, and empty values (resulting from malformed input
such as consecutive commas or spaces) are excluded.

This ensures only valid room types are considered.

---

### Step 3: Deduplicate per search event
A search event is defined by the combination of `(user_id, date_searched)`.

Within a single search:
- Duplicate room types are removed
- Each room type contributes at most one count

This step prevents overcounting when the same room type appears multiple times in a
single search string.

---

### Step 4: Aggregate globally
After normalization and per-search deduplication:
- The data is grouped by `room_type`
- The number of search events containing each room type is counted
- Results are ordered by search count in descending order

---

## Assumptions
- A user performs at most one search per day.
- Duplicate room types within the same search are not meaningful.
- Empty room-type tokens represent invalid data and should be ignored.
- The order of room types within the filter string is irrelevant.

---

## Edge Case Handling
- Duplicate room types within the same search are counted once.
- The same room type searched on different days or by different users is counted
  multiple times.
- Empty or whitespace-only room types are excluded.
- Malformed strings such as `'entire home, , private room'` are handled correctly.

---

## Alternative Approaches (Summary)
A naive approach that counts room types immediately after splitting was explored.
This approach was rejected because it overcounts duplicate room types within a single
search event.

The chosen approach explicitly normalizes the data and enforces per-search
deduplication, making it more robust and semantically correct.

---

## Conclusion
By restoring the data to a normalized form, enforcing per-search deduplication, and
aggregating only valid room-type search intents, the solution correctly identifies
the most frequently searched room types in a clear, maintainable, and defensible way.
