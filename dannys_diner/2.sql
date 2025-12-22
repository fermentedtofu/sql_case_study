-- 2. How many days has each customer visited the restaurant?
SET search_path TO dannys_diner;

SELECT customer_id, COUNT(DISTINCT order_date) AS visited_days
FROM sales
GROUP BY customer_id
ORDER BY customer_id;