-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SET search_path TO pizza_runner;

WITH all_combinations AS (
  SELECT DISTINCT co.customer_id, p.pizza_id, p.pizza_name
  FROM customer_orders co CROSS JOIN pizza_names p
)

SELECT ac.customer_id,
	ac.pizza_name,
    COUNT(co.order_id) AS total_ordered
FROM all_combinations ac LEFT JOIN customer_orders co
ON ac.customer_id = co.customer_id
AND ac.pizza_id = co.pizza_id
GROUP BY ac.customer_id, ac.pizza_name
ORDER BY ac.customer_id, ac.pizza_name;