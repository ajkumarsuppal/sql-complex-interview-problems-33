-- Purpose:
-- Defines schema for Problem 01 (Olympic Gold Medals)
-- Separated to allow CI, migrations, and reproducibility.
drop table if exists events;

CREATE TABLE dbo.events
(
    ID int,
    event varchar(255),
    YEAR int,
    GOLD varchar(255),
    SILVER varchar(255),
    BRONZE varchar(255)
);