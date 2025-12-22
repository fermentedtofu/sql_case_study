-- 7. What is the successful delivery percentage for each runner?
SET search_path TO pizza_runner;

SELECT runner_id, ROUND((COUNT(*) - COUNT(cancellation))/COUNT(*)::numeric * 100, 2) AS success_percentage
FROM runner_orders
GROUP BY runner_id
ORDER BY runner_id;