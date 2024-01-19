--baitap1
SELECT 
  *,
  ROUND(
    ((curr_year_spend - prev_year_spend)/ prev_year_spend)*100,2) yoy_rate
FROM 
(SELECT
  EXTRACT(year FROM transaction_date) AS year,
  product_id,
  spend curr_year_spend,
  LAG(spend) OVER(
    PARTITION BY product_id 
    ORDER BY product_id,
    EXTRACT(year FROM transaction_date)) prev_year_spend
FROM user_transactions) new

--baitap2
SELECT
  card_name,
  issued_amount
FROM
(SELECT 
  *,
  ROW_NUMBER() OVER(
    PARTITION BY card_name
    ORDER BY  issue_year) AS rank
FROM monthly_cards_issued ) new
WHERE rank = 1
ORDER BY issued_amount DESC

--baitap3
SELECT 
  user_id,
  spend,
  transaction_date
FROM 
(SELECT 
  *,
  ROW_NUMBER() OVER(
    PARTITION BY user_id
    ORDER BY transaction_date) AS rank
FROM transactions) new
WHERE rank = 3

--baitap4
SELECT 
  transaction_date,
  user_id,
  purchase_count
FROM (
SELECT
  transaction_date,
  user_id,
  COUNT(product_id) AS purchase_count,
  RANK() OVER(
    PARTITION BY user_id 
    ORDER BY transaction_date DESC) AS rank
FROM user_transactions
GROUP BY user_id, transaction_date) new
WHERE rank = 1
ORDER BY transaction_date

--baitap5
SELECT 
  user_id,
  tweet_date,
  ROUND(AVG(tweet_count) OVER(
  PARTITION BY user_id 
  ORDER BY tweet_date
  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) rolling_avg_3d
FROM tweets;

/*anh giai thich giup em cau len ROWS BETWEEN 2 PRECEDING AND CURRENT ROW voi a*/

--baitap6
