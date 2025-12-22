-- 3. Is there any relationship between the number of pizzas and how long the order took to prepare?
SET search_path TO pizza_runner;

SELECT ro.order_id, COUNT(co.pizza_id) AS pizza_count, (MAX(ro.pickup_time) - MIN(co.order_time)) AS time_taken
FROM customer_orders co JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY ro.order_id
ORDER BY ro.order_id;