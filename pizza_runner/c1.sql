-- 1. What are the standard ingredients for each pizza?
SET search_path TO pizza_runner;

WITH topping_array AS (
  SELECT pizza_id, UNNEST(STRING_TO_ARRAY(toppings, ', '))::INT AS topping_id
  FROM pizza_recipes
)

SELECT ta.pizza_id, ARRAY_TO_STRING(ARRAY_AGG(pt.topping_name), ', ') AS pizza_toppings
FROM topping_array ta JOIN pizza_toppings pt
ON ta.topping_id = pt.topping_id
GROUP BY ta.pizza_id
ORDER BY ta.pizza_id;