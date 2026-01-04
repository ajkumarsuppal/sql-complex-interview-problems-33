-- Purpose:
-- Defines schema for Problem 01 (Olympic Gold Medals)
-- Separated to allow CI, migrations, and reproducibility.
create table hospital (
    emp_id int,
    action varchar(10),
    time datetime
);