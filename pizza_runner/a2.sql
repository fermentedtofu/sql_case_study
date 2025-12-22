-- 2. How many unique customer orders were made?
SET search_path TO pizza_runner;

SELECT COUNT(DISTINCT order_id) AS total_unique_orders
FROM customer_orders;