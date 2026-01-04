-- Primary solution.
-- Chosen as default for readability and extensibility.
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