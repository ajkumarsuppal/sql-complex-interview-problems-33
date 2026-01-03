-- Primary solution.
-- Chosen as default for readability and extensibility.

--check server name
SELECT @@SERVERNAME AS server_name;
--check current user
SELECT CURRENT_USER;
--check current login
SELECT SUSER_SNAME() AS login_name;
--check schemas in the current database
SELECT *
FROM sys.schemas;
--check current schema
SELECT SCHEMA_NAME() AS current_schema;
--find databases in the server
select *
from sys.databases;
--check databases in the server
SELECT name
FROM sys.databases;

--check current database
SELECT DB_NAME() AS current_db;

--use the olympics database
use sql_problems;
--check tables in the current database
SELECT *
FROM sys.tables;

--view data in events table
SELECT *
FROM dbo.events;
