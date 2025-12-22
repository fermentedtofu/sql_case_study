-- 4. How many of each type of pizza was delivered?
SET search_path TO pizza_runner;

SELECT p.pizza_name, COUNT(*) AS total_delivered
FROM runner_orders ro JOIN customer_orders co
ON ro.order_id = co.order_id
JOIN pizza_names p
ON co.pizza_id = p.pizza_id
WHERE ro.cancellation IS NULL
GROUP BY p.pizza_name;
