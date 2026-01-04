-- use as given 
-- (can paste the INSERTs provided)
delete from
    airbnb_searches;

insert into
    airbnb_searches
values
    (1, '2022-01-01', 'entire home,private room'),
    (1, '2022-01-01', 'entire home, , private room'),
    (2, '2022-01-02', 'entire home,shared room'),
    (3, '2022-01-02', 'private room,shared room'),
    (4, '2022-01-03', 'private room'),
    (5, '2022-01-04', 'private room,private room');