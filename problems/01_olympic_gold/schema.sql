<<<<<<< HEAD
-- Purpose:
-- Defines schema for Problem 01 (Olympic Gold Medals)
-- Separated to allow CI, migrations, and reproducibility.
=======
>>>>>>> 0420ed086c181223c7fbee7d0be1f681fabd84c7
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