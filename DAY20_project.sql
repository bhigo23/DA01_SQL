/*TASK 1,2:
Insights: Tổng số lượng đơn hàng, khách hàng cũng như trung bình giá các đơn hàng tăng dần theo tháng*/
WITH total_user_order AS (
SELECT
  FORMAT_DATE("%Y-%m",created_at) AS month_year,
  COUNT(distinct user_id) AS total_user,
  COUNT(distinct order_id) AS total_order FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE FORMAT_DATE("%Y-%m",created_at) BETWEEN '2019-01' AND '2022-04' 
AND status = 'Complete'
GROUP BY 1
ORDER BY 1),

AVG_month_price AS (
SELECT
  FORMAT_DATE("%Y-%m",created_at) AS month_year,
  COUNT(distinct user_id) AS distinct_user,
  (SUM(sale_price) / (SELECT SUM(total_order) FROM total_user_order)) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE FORMAT_DATE("%Y-%m",created_at) BETWEEN '2019-01' AND '2022-04'
AND status = 'Complete'
GROUP BY 1
ORDER BY 1),

/*TASK 3: 
Insights: Trẻ nhất là 12 tuổi và có 1169 KH, lớn nhất là 70 tuổi và có 1055 KH*/
min_max_age AS (
SELECT 
  first_name,
  last_name,
  gender,
  age,
  'Youngest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE age = (SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users)
AND FORMAT_DATE("%Y-%m",created_at) BETWEEN '2019-01' AND '2022-04'
UNION ALL
SELECT 
  first_name,
  last_name,
  gender,
  age,
  'Oldest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE age = (SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users)
AND FORMAT_DATE("%Y-%m",created_at) BETWEEN '2019-01' AND '2022-04'),

--TASK 4
rank_per_month AS (
SELECT 
  *
FROM(
SELECT
  month_year,
  product_name,
  sales,
  cost,
  profit,
  DENSE_RANK() OVER(PARTITION BY month_year ORDER BY profit DESC) AS rank_per_month
FROM (
SELECT 
  FORMAT_DATE("%Y-%m",created_at) AS month_year,
  product_id,
  product_name,
  product_retail_price AS sales,
  cost,
  product_retail_price - cost AS profit
FROM bigquery-public-data.thelook_ecommerce.inventory_items
GROUP BY 1,2,3,4,5)
ORDER BY 1)
WHERE rank_per_month <= 5)

--TASK 5
SELECT 
  FORMAT_date("%Y-%m-%d", sold_at) AS dates,
  product_category,
  SUM(product_retail_price - cost) AS revenue
 FROM bigquery-public-data.thelook_ecommerce.inventory_items
WHERE sold_at IS NOT NULL
AND FORMAT_date("%Y-%m-%d", sold_at) BETWEEN '2022-01-15' AND '2022-04-15'  
GROUP BY 1,2
ORDER BY 1

