-- 3. What was the most commonly excluded ingredient?
SET search_path TO pizza_runner;

WITH exclusions AS (
  SELECT order_id, UNNEST(STRING_TO_ARRAY(exclusions, ', '))::INT AS topping_id
  FROM customer_orders
  WHERE exclusions IS NOT NULL
)

SELECT t.topping_name, COUNT(*)
FROM exclusions e JOIN pizza_toppings t
ON e.topping_id = t.topping_id
GROUP BY t.topping_name
ORDER BY COUNT(*) DESC
LIMIT 1;