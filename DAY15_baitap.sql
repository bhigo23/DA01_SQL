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
SELECT 
  COUNT(merchant_id) AS payment_count 
FROM (
SELECT 
  merchant_id,
  credit_card_id,
  transaction_timestamp,
  LAG(transaction_timestamp) OVER(
    PARTITION BY merchant_id, credit_card_id, amount
     ORDER BY transaction_timestamp, credit_card_id) AS next_time,
  EXTRACT( EPOCH FROM 
    transaction_timestamp - (LAG(transaction_timestamp) OVER(
      PARTITION BY merchant_id, merchant_id, credit_card_id, amount
      ORDER BY transaction_timestamp)) )/60 gap_time,
  amount
FROM transactions) sub
WHERE gap_time <= 10

--baitap7
SELECT 
  category,
  product,
  total_spend
FROM (
SELECT 
  category, 
  product, 
  SUM(spend) AS total_spend,
  RANK() OVER (
    PARTITION BY category 
    ORDER BY SUM(spend) DESC) AS rank 
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product) sub
WHERE rank <= 2 

--baitap8
SELECT 
  artist_name,
  rank_
FROM (
SELECT 
  a.artist_name,
  DENSE_RANK() OVER (
    ORDER BY COUNT(b.song_id) DESC) AS rank_
FROM artists AS a
JOIN songs AS b ON a.artist_id = b.artist_id
JOIN global_song_rank AS c ON b.song_id = c.song_id
WHERE rank <= 10
GROUP BY a.artist_name) sub
WHERE rank_ <= 5
