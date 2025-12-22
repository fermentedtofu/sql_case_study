-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SET search_path TO dannys_diner;

SELECT m.product_name, COUNT(s.product_id) AS total_sales
FROM sales s JOIN menu m
ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_sales DESC
LIMIT 1;