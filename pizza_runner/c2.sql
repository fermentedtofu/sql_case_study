-- 2. What was the most commonly added extra?
SET search_path TO pizza_runner;

WITH extras AS (
  SELECT order_id, UNNEST(STRING_TO_ARRAY(extras, ', '))::INT AS topping_id
  FROM customer_orders
  WHERE extras IS NOT NULL
)

SELECT t.topping_name, COUNT(*)
FROM extras e JOIN pizza_toppings t
ON e.topping_id = t.topping_id
GROUP BY t.topping_name
ORDER BY COUNT(*) DESC
LIMIT 1;