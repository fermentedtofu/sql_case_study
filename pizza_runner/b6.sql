-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SET search_path TO pizza_runner;

SELECT order_id, runner_id, ROUND(distance/duration, 2) AS "speed (km/min)"
FROM runner_orders
WHERE cancellation IS NULL
ORDER BY runner_id;
