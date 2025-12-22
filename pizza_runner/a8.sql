-- 8. How many pizzas were delivered that had both exclusions and extras?
SET search_path TO pizza_runner;

SELECT COUNT(co.pizza_id) AS total_delivered_changed_pizzas
FROM customer_orders co JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
AND co.exclusions IS NOT NULL 
AND co.extras IS NOT NULL;