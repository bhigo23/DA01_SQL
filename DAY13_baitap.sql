--baitap1
WITH TWT_duplicate AS 
(SELECT company_id, title, description,
COUNT(job_id) AS j_cnt
FROM job_listings
GROUP BY company_id, title, description)
SELECT 
COUNT(TWT_duplicate.company_id) AS duplicate_companies
FROM TWT_duplicate
WHERE j_cnt = 2

--baitap2
WITH total_spend_each_product AS (
SELECT category, product,
SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT(Year FROM transaction_date) = 2022
GROUP BY category, product)
SELECT Category, product, total_spend
FROM total_spend_each_product
WHERE total_spend > (SELECT AVG(total_spend) FROM total_spend_each_product)
ORDER BY category, total_spend DESC

--baitap3
SELECT COUNT(policy_holder_id) AS member_count
FROM (SELECT policy_holder_id,
      COUNT(case_id) as calls
  FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3) as calls_record

--baitap4
SELECT a.page_id
FROM pages AS a
LEFT JOIN page_likes AS b
ON a.page_id = b.page_id
WHERE b.liked_date IS NULL
ORDER BY a.page_id

--baitap5
/*bài só 5 hơi khó với em, em cũng có đọc solution mà không hiểu gì. Nhưng mà em thấy tốc độ của em khá chậm, hầu hết các bài
em không tự giải được, em phải đọc đi đọc lại solution để tìm cách. Với lại cái kỹ năng Problem Solving của em khá yếu, em nên
làm gì để cải thiện hơn ạ ?*/

--baitap6
SELECT
SUBSTRING(trans_date,1,7) AS month,
country,
COUNT(id) AS trans_count,
SUM(CASE 
    WHEN state = 'approved' THEN 1
    ELSE 0
END) approved_count, 
SUM(amount) AS trans_total_amount,
SUM(CASE 
    WHEN state = 'approved' THEN amount
    ELSE 0
END ) approved_total_amount
FROM transactions
GROUP BY country, month

--baitap7
SELECT product_id, year AS first_year, quantity, price
FROM sales
WHERE (product_id, year) IN (
SELECT product_id, MIN(year) FROM sales
GROUP BY product_id)

--baitap8
SELECT customer_id FROM customer 
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(product_key) FROM product)
      
--baitap9
SELECT a.employee_id FROM employees AS a 
LEFT JOIN employees AS b ON a.manager_id = b.employee_id
WHERE a.salary < 30000
AND b.name IS NULL
AND a.manager_id IS NOT NULL
ORDER BY a.employee_id

--baitap10
SELECT employee_id, department_id FROM employee
WHERE primary_flag = 'Y'
UNION
SELECT employee_id, department_id 
FROM employee
GROUP BY employee_id
HAVING COUNT(department_id) = 1

--baitap11
WITH Rate_count AS (
SELECT a.name AS results   
FROM users AS a
JOIN movierating AS b ON a.user_id = b.user_id
GROUP BY a.name
ORDER BY COUNT(*) DESC, a.name
LIMIT 1),

avg_rating AS (
SELECT a.title AS results   
FROM movies AS a
JOIN movierating AS b ON a.movie_id = b.movie_id
WHERE EXTRACT(year_month FROM b.created_at) = 202002
GROUP BY a.title
ORDER BY AVG(rating) DESC, a.title
LIMIT 1)

SELECT results 
FROM Rate_count  
UNION ALL
SELECT results FROM avg_rating 

--baitap12
WITH all_ids AS (
SELECT a.requester_id AS id,
COUNT(a.accepter_id) AS cnt
FROM RequestAccepted AS a
GROUP BY a.requester_id

UNION ALL

SELECT a.accepter_id AS id,
COUNT(a.requester_id) AS cnt
FROM RequestAccepted AS a
GROUP BY a.accepter_id)

SELECT id, SUM(cnt) AS num
FROM all_ids
GROUP BY id
ORDER BY num DESC
LIMIT 1


