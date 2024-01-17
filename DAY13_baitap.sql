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
