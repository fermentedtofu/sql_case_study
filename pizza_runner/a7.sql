-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SET search_path TO pizza_runner;

SELECT co.customer_id,
	SUM(
		CASE
       		WHEN co.exclusions IS NULL AND co.extras IS NULL THEN 1
          	ELSE 0
    	END
    ) AS unchanged_count,
    SUM(
      	CASE
      		WHEN co.exclusions IS NOT NULL OR co.extras IS NOT NULL THEN 1
      		ELSE 0
    	END
    ) AS changed_count 
FROM customer_orders co JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.customer_id
ORDER BY co.customer_id;