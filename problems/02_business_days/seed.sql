-- use as given 
-- (can paste the INSERTs provided)
delete from
    tickets;

delete from
    holidays;

insert into
    tickets
values
    (1, '2022-08-01', '2022-08-03'),
    (2, '2022-08-01', '2022-08-12'),
    (3, '2022-08-01', '2022-08-16');

insert into
    holidays
values
    ('2022-08-11', 'Rakhi'),
    ('2022-08-15', 'Independence day');