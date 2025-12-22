-- 5. What was the difference between the longest and shortest delivery times for all orders?
SET search_path TO pizza_runner;

SELECT MAX(duration) - MIN(duration) AS delivery_time_diff
FROM runner_orders;