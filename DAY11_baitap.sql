/* bai tap tren ripid*/
--baitap1
SELECT country.continent, 
FLOOR(AVG(city.population))
FROM country
JOIN city
ON COUNTRY.Code =  CITY.CountryCode
GROUP BY country.continent
  
--baitap2
SELECT 
ROUND(CAST(COUNT(texts.email_id) AS DECIMAL)/CAST(COUNT(DISTINCT emails.email_id) AS DECIMAL),2) AS activation_rate
FROM emails
LEFT JOIN texts
ON emails.email_id = texts.email_id
AND texts.signup_action = 'Confirmed';

--baitap3
SELECT age_breakdown.age_bucket,
ROUND(SUM(CASE
  WHEN activities.activity_type = 'send' 
  THEN activities.time_spent ELSE 0 END)/
(SUM(CASE
  WHEN activities.activity_type = 'send' 
  THEN activities.time_spent ELSE 0 END) +
SUM(CASE
  WHEN activities.activity_type = 'open'
  THEN activities.time_spent ELSE 0 END)) * 100,2) AS send_perc,
  
ROUND(SUM(CASE
  WHEN activities.activity_type = 'open' 
  THEN activities.time_spent ELSE 0 END)/
(SUM(CASE
  WHEN activities.activity_type = 'send' 
  THEN activities.time_spent ELSE 0 END) +
SUM(CASE
  WHEN activities.activity_type = 'open'
  THEN activities.time_spent ELSE 0 END)) * 100,2) AS open_perc  
FROM activities
 JOIN age_breakdown
  ON activities.user_id = age_breakdown.user_id
WHERE activities.activity_type IN ('send','open')
GROUP BY age_breakdown.age_bucket

--baitap4
SELECT customer_contracts.customer_id 
FROM customer_contracts
JOIN products
ON customer_contracts.product_id = products.product_id
GROUP BY customer_contracts.customer_id
HAVING COUNT(DISTINCT products.product_category) = 3

--baitap5
SELECT e1.employee_id, e1.name,
COUNT(*) AS reports_count,
ROUND(AVG(e2.age),0) AS average_age
FROM employees AS e1
JOIN employees AS e2 
ON e1.employee_id = e2.reports_to
GROUP BY e1.employee_id,e1.name
ORDER BY e1.employee_id

--baitap6
SELECT a.product_name,
SUM(b.unit) AS unit
FROM products AS a 
JOIN orders AS b
ON a.product_id = b.product_id
WHERE EXTRACT(month FROM b.order_date) = 2 
AND EXTRACT(year FROM b.order_date) = 2020
GROUP BY a.product_id
HAVING SUM(b.unit) >=100

--baitap7
SELECT a.page_id
FROM pages AS a
LEFT JOIN page_likes AS b
ON a.page_id = b.page_id
WHERE b.liked_date IS NULL
ORDER BY a.page_id

/*bai tap mid-course*/
--baitap1
SELECT DISTINCT replacement_cost FROM film
ORDER BY replacement_cost 

--baitap2
SELECT 
CASE 
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'Low'
	WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'Medium'
	WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 'High'
END cost_range,
COUNT(film_id) AS soluong
FROM film
GROUP BY cost_range
ORDER BY soluong DESC
  
--baitap3
SELECT a.title, c.name , a.length
FROM film AS a
JOIN film_category AS b ON a.film_id = b.film_id
JOIN category AS c ON b.category_id = c.category_id
WHERE c.name = 'Drama'
OR c.name = 'Sports'
ORDER BY a.length DESC

--baitap4
SELECT c.name,
COUNT(a.title) AS soluong
FROM film AS a
LEFT JOIN film_category AS b ON a.film_id = b.film_id
LEFT JOIN category AS c ON b.category_id = c.category_id
GROUP BY c.name
ORDER BY soluong DESC

--baitap5
SELECT a.first_name || ' ' || a.last_name AS ho_ten,
COUNT(film_id) AS soluong
FROM actor AS a
JOIN film_actor AS b
ON a.actor_id = b.actor_id
GROUP BY ho_ten
ORDER BY soluong DESC

--baitap6
SELECT a.address, b.customer_id
FROM address AS a
LEFT JOIN customer AS b
ON a.address_id = b.address_id
WHERE b.customer_id IS NULL

--baitap7
SELECT a.city, 
SUM(e.amount) AS revenue
FROM city AS a 
JOIN country AS b ON a.country_id = b.country_id
JOIN public.address AS c ON a.city_id = c.city_id
JOIN customer AS d ON c.address_id = d.address_id
JOIN payment AS e ON d.customer_id = e.customer_id
GROUP BY a.city
ORDER BY revenue DESC
  
--baitap8
SELECT a.city || ',' || ' ' || b.country AS city_country,
SUM(e.amount) AS revenue
FROM city AS a 
JOIN country AS b ON a.country_id = b.country_id
JOIN public.address AS c ON a.city_id = c.city_id
JOIN customer AS d ON c.address_id = d.address_id
JOIN payment AS e ON d.customer_id = e.customer_id
GROUP BY city_country
ORDER BY revenue DESC



