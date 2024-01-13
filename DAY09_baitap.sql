--baitap1
SELECT
SUM(CASE 
  WHEN device_type = 'laptop' THEN 1
  ELSE 0
END) laptop_views,
SUM(CASE
  WHEN device_type IN ('tablet','phone') THEN 1
  ELSE 0
END) mobile_views
FROM viewership
GROUP BY laptop_views, mobile_views
--baitap2
SELECT x,y,z, 
CASE 
  WHEN x+y > z AND x+z > y AND y+z > x THEN 'Yes'
  ELSE 'No'
END triangle
FROM triangle
--baitap3
SELECT 
ROUND(SUM(CASE 
  WHEN call_category IS NULL or call_category='n/a' THEN 1.0 ELSE 0 END)/COUNT(case_id)*100.0,1) 
AS call_percentage
FROM callers
--baitap4
SELECT name FROM customer
WHERE referee_id != 2 OR referee_id IS NULL
--baitap5
select survived,
SUM(CASE 
  WHEN pclass = 1 THEN 1
  ELSE 0
END) first_class,
SUM(CASE 
  WHEN pclass = 2 THEN 1
  ELSE 0
END) second_class,
SUM(CASE 
  WHEN pclass = 3 THEN 1
  ELSE 0
END) third_class
from titanic
GROUP BY survived
