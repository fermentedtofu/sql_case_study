-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SET search_path TO pizza_runner;

WITH runner_time AS (
  SELECT DISTINCT ro.runner_id, EXTRACT(EPOCH FROM ro.pickup_time - co.order_time) AS average_time 
	FROM customer_orders co JOIN runner_orders ro
	ON co.order_id = ro.order_id
	WHERE ro.cancellation IS NULL
	ORDER BY ro.runner_id
)

SELECT runner_id, ROUND((AVG(average_time)/60)::numeric, 2) AS average_min
FROM runner_time
GROUP BY runner_id
ORDER BY runner_id;