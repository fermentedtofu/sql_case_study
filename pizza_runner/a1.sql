-- 1. How many pizzas were ordered?
SET search_path = pizza_runner;

SELECT COUNT(*) AS total_pizzas_ordered
FROM customer_orders;