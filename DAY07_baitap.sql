--baitap1
SELECT name FROM students
WHERE marks > 75
ORDER BY RIGHT(name,3), id
--baitap2
SELECT user_id,
CONCAT(UPPER(left(name,1)),
LOWER(RIGht(name, LENGTH(name) - 1))) AS name
FROM users
ORDER BY user_id
--baitap3
SELECT manufacturer,
'$' || ROUND((SUM(total_sales)/1000000),0) || ' ' || 'million'  AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer
--baitap4
SELECT
EXTRACT(month FROM submit_date) AS mth,
product_id AS product,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(month FROM submit_date), product
ORDER BY EXTRACT(month FROM submit_date), product
--baitap5
SELECT sender_id,
COUNT(message_id) AS message_count
FROM messages
WHERE sent_date BETWEEN '08/01/2022' AND '08/31/2022'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2
--baitap6
SELECT tweet_id FROM Tweets
WHERE LENGTH(content) > 15
--baitap7
SELECT 
activity_date AS day,
COUNT(DISTINCT(user_id)) AS active_users 
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date
--baitap8
SELECT joining_date,
COUNT(id) AS hired_employees
FROM employees
WHERE EXTRACT(month FROM joining_date) BETWEEN '01' AND '07'
AND EXTRACT(year FROM joining_date) = 2022
GROUP BY joining_date
--baitap9
SELECT 
POSITION('a' IN first_name)
FROM worker
WHERE first_name = 'Amitah'
--baitap10
SELECT 
SUBSTRING(title,POSITION('2' IN title),4) AS year 
FROM winemag_p2
WHERE country = 'Macedonia'

/*Ở bài 10. Nếu em muốn thay tất cả những loại rượu không có năm trong tên bằng NULL thì phải làm như nào ạ ? */
