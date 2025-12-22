-- 4. What was the average distance travelled for each customer?
SET search_path TO pizza_runner;

WITH runner_distance AS (
  SELECT DISTINCT ro.order_id, co.customer_id, ro.distance
  FROM customer_orders co JOIN runner_orders ro
  ON co.order_id = ro.order_id
  WHERE ro.cancellation IS NULL
)

SELECT customer_id, ROUND(AVG(distance), 2) AS avg_distance
FROM runner_distance
GROUP BY customer_id
ORDER BY customer_id;