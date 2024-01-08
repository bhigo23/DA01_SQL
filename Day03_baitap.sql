-- baitap 1
SELECT name FROM city
WHERE population > 120000 and countrycode = 'USA';
-- baitap2
SELECT * FROM city
WHERE countrycode = 'JPN';
-- baitap3
SELECT city, state FROM station;
-- baitap4
SELECT DISTINCT city FROM station
WHERE city LIKE 'A%' 
OR city LIKE 'E%'
OR city LIKE 'I%'
OR city LIKE 'O%'
OR city LIKE 'U%';
-- baitap5
SELECT DISTINCT city FROM station 
WHERE city LIKE '%a'
OR city LIKE '%e'
OR city LIKE '%i'
OR city LIKE '%o'
OR city LIKE '%u';
-- baitap6
SELECT DISTINCT city from station 
WHERE city NOT LIKE 'A%'
AND city NOT LIKE 'E%'
AND city NOT LIKE 'I%'
AND city NOT LIKE 'o%'
AND city NOT LIKE 'U%';
-- baitap7
SELECT name FROM employee
ORDER BY name;
-- baitap8
SELECT name FROM employee
WHERE salary > 2000 and months < 10
ORDER BY employee_id ASC;
-- baitap9
SELECT product_id FROM products 
WHERE low_fats = 'Y'
AND recyclable = 'Y';
-- baitap10
SELECT name FROM customer
WHERE NOT referee_id = 2 OR referee_id IS NULL;
-- baitap11
SELECT name, population, area FROM world
WHERE area >= 3000000 
OR population >= 25000000;
-- baitap12
SELECT DISTINCT author_id as id FROM views
WHERE author_id = viewer_id 
ORDER BY id;
-- baitap13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL;
-- baitap14
select * from lyft_drivers
WHERE yearly_salary <= 30000 
OR yearly_salary >= 70000;
-- baitap15
select advertising_channel from uber_advertising
WHERE money_spent > 100000
AND year = 2019;
