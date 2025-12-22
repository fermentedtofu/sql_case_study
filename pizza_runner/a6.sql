-- 6. What was the maximum number of pizzas delivered in a single order?
SET search_path TO pizza_runner;

SELECT COUNT(co.pizza_id) AS max_delivered
FROM customer_orders co JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.order_id
ORDER BY max_delivered DESC
LIMIT 1;