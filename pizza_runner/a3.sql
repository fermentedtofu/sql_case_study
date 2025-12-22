-- 3. How many successful orders were delivered by each runner?
SET search_path TO pizza_runner;

SELECT r.runner_id,
	SUM(
      CASE
      	WHEN ro.order_id IS NOT NULL AND ro.cancellation IS NULL THEN 1
      	ELSE 0
      END
    ) AS total_successful_orders
FROM runners r LEFT JOIN runner_orders ro
ON r.runner_id = ro.runner_id
GROUP BY r.runner_id
ORDER BY r.runner_id;