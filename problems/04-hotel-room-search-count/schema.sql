-- Purpose:
-- Defines schema for Problem 01 (Olympic Gold Medals)
-- Separated to allow CI, migrations, and reproducibility.
create table airbnb_searches (
    user_id int,
    date_searched date,
    filter_room_types varchar(200)
);