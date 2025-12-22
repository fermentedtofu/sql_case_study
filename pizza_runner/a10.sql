-- 10. What was the volume of orders for each day of the week?
SET search_path TO pizza_runner;

WITH every_day AS (
  SELECT generate_series AS day
  FROM generate_series(
    '2025-12-07 00:00'::timestamp,
    '2025-12-13 00:00'::timestamp,
    '1 day'::interval
  )
)

SELECT TO_CHAR(ed.day, 'Day') AS day_of_week, COUNT(DISTINCT co.order_id) AS total_unique_orders
FROM every_day ed LEFT JOIN customer_orders co
ON EXTRACT(DOW FROM ed.day) = EXTRACT(DOW FROM co.order_time)
GROUP BY ed.day
ORDER BY ed.day;