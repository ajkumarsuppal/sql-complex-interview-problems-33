-- Purpose:
-- Defines schema for Problem 05
-- Separated to allow CI, migrations, and reproducibility.
CREATE TABLE [emp_salary] (
    [emp_id] INTEGER NOT NULL,
    [name] NVARCHAR(20) NOT NULL,
    [salary] NVARCHAR(30),
    [dept_id] INTEGER
);