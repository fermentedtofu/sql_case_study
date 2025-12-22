-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
SET search_path TO pizza_runner;

WITH ext AS (
  SELECT c.topping_id, t.topping_name, COUNT(*) AS times_added
  FROM (SELECT UNNEST(STRING_TO_ARRAY(extras, ', '))::integer AS topping_id
  FROM customer_orders) c JOIN pizza_toppings t
  ON c.topping_id = t.topping_id
  GROUP BY c.topping_id, t.topping_name
),
excl AS (
  SELECT c.topping_id, t.topping_name, COUNT(*) AS times_excluded
  FROM (SELECT UNNEST(STRING_TO_ARRAY(exclusions, ', '))::integer AS topping_id
  FROM customer_orders) c JOIN pizza_toppings t
  ON c.topping_id = t.topping_id
  GROUP BY c.topping_id, t.topping_name
)

SELECT topping_id, topping_name, COALESCE(times_added, 0) AS times_added, COALESCE(times_excluded, 0) AS times_excluded
FROM ext FULL JOIN excl USING(topping_id, topping_name);