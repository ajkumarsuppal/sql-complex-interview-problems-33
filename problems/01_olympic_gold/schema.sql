-- Purpose:
-- Defines schema for Problem 01 (Olympic Gold Medals)
-- Separated to allow CI, migrations, and reproducibility.
CREATE TABLE events
(
    id int,
    event varchar(255),
    year int,
    GOLD varchar(255),
    SILVER varchar(255),
    BRONZE varchar(255)
);