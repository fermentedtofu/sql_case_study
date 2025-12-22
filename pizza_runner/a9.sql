-- 9. What was the total volume of pizzas ordered for each hour of the day?
SET search_path TO pizza_runner;

WITH every_hour AS (
  SELECT EXTRACT(HOUR FROM generate_series) AS hour
  FROM generate_series(
    '2025-12-09 00:00'::timestamp,
    '2025-12-09 23:00'::timestamp,
    '1 hour'::interval
  )
)

SELECT eh.hour, COUNT(co.order_id) AS pizza_ordered
FROM every_hour eh LEFT JOIN customer_orders co
ON eh.hour = EXTRACT(HOUR FROM order_time)
GROUP BY eh.hour
ORDER BY eh.hour;