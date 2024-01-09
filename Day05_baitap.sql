--baitap1
SELECT DISTINCT city FROM station 
WHERE ID % 2 = 0 
--baitap2
SELECT COUNT(city) - COUNT(DISTINCT CITY) 
FROM station
