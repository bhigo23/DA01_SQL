--baitap1
SELECT DISTINCT city FROM station 
WHERE ID % 2 = 0 
--baitap2
SELECT COUNT(city) - COUNT(DISTINCT CITY) 
FROM station
--baitap3
SELECT CEILING(AVG(salary) - (AVG(REPLACE(salary,'0','')))) 
FROM employees
--baitap4
SELECT ROUND(CAST(SUM(order_occurrences*item_count)/SUM(order_occurrences) AS DECIMAL),1) 
FROM items_per_order
--baitap5
SELECT candidate_id FROM candidates
WHERE skill IN ('PostgreSQL','Tableau','Python')
GROUP BY candidate_id
HAVING COUNT(candidate_id) = 3
--baitap6
SELECT user_id,
MAX(DATE(post_date)) - MIN(DATE(post_date)) AS days_between
FROM posts
WHERE (post_date) BETWEEN '2021-01-01' AND '2021-12-31' 
GROUP BY user_id
HAVING COUNT(user_id) >= 2
--baitap7
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC
--baitap8
SELECT manufacturer,
COUNT(drug) AS drug_count,
ABS(SUM(cogs - total_sales)) AS total_loss
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC
--baitap9
