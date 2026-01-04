# Design Thinking — Hotel Room Search Count

## Initial Understanding
The problem initially looked like a simple aggregation task:
count how many times each room type was searched.

However, the presence of a comma-separated column immediately indicated that the
data was not in a usable analytical form.

---

## Early Observations
The `filter_room_types` column violates First Normal Form.
Any correct solution would need to:
- Split values into rows
- Normalize them
- Aggregate afterward

At first glance, it was tempting to split and count directly.

---

## Key Realization: This Is a Normalization Problem
The real challenge was not counting, but **restoring the correct grain of the data**.

Each row represents one search event.
Each search event can contain multiple room types.
Therefore, the correct intermediate representation must be:
> One row per room type per search event.

---

## Exploring STRING_SPLIT
Using `STRING_SPLIT` with `CROSS APPLY` correctly expanded rows.
However, early queries accidentally deduplicated by selecting `DISTINCT value, a.*`,
which worked only because the current schema made rows appear unique.

This was identified as fragile and unsafe.

---

## Defining the Search Event
A key decision was defining the search event as `(user_id, date_searched)`.

This allowed deduplication to be scoped correctly:
- Deduplicate room types **within** a search
- Do not deduplicate across searches

This distinction clarified where and how deduplication should occur.

---

## Handling Duplicates Correctly
An explicit test case with:
`'private room,private room'`
highlighted that direct aggregation would overcount.

This confirmed that deduplication must happen **before** aggregation, and
**per search event**, not globally.

---

## Handling Empty Values
Malformed input such as:
`'entire home, , private room'`
produced empty strings after trimming.

An important insight was that:
- Empty room types are invalid rows
- Invalid rows must be removed using filtering, not value substitution

This reinforced the separation between:
- Row validity (`WHERE`)
- Value transformation (`SELECT`)

---

## Rejecting the Naive Aggregation
A direct `GROUP BY trim(value)` was explored and intentionally rejected
because it violated the per-search deduplication rule.

Keeping this rejected approach in `alt-solution.sql` helped clarify why
the final solution is structured the way it is.

---

## Final Approach
The final approach emerged clearly once all decisions were explicit:
1. Split comma-separated values
2. Trim and remove empty values
3. Deduplicate per `(user_id, date_searched, room_type)`
4. Aggregate by `room_type`

At that point, the SQL became straightforward.

---

## Takeaways
- Data shape matters more than aggregation syntax
- Deduplication must match business semantics
- Invalid data should be filtered out, not transformed
- Writing exploratory queries helps surface hidden assumptions

This problem reinforced the importance of reasoning about data grain
before writing final SQL.