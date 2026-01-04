-- Purpose:
-- Defines schema for Problem 01 (Olympic Gold Medals)
-- Separated to allow CI, migrations, and reproducibility.
create table tickets (
    ticket_id varchar(10),
    create_date date,
    resolved_date date
);

create table holidays (holiday_date date, reason varchar(100));