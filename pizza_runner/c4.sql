-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
    -- Meat Lovers
    -- Meat Lovers - Exclude Beef
    -- Meat Lovers - Extra Bacon
    -- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
SET search_path TO pizza_runner;

WITH base AS (
  SELECT *, ROW_NUMBER() OVER(ORDER BY order_id) AS rn
  FROM customer_orders
),
excl AS (
  SELECT e.rn, 'Exclude ' || ARRAY_TO_STRING(ARRAY_AGG(t.topping_name), ', ') AS excl_string
  FROM (SELECT rn, UNNEST(STRING_TO_ARRAY(exclusions, ', '))::INT AS topping_id
  FROM base) e JOIN pizza_toppings t
  ON e.topping_id = t.topping_id
  GROUP BY e.rn
),
ext AS (
  SELECT e.rn, 'Extra ' || ARRAY_TO_STRING(ARRAY_AGG(t.topping_name), ', ') AS ext_string
  FROM (SELECT rn, UNNEST(STRING_TO_ARRAY(extras, ', '))::INT AS topping_id
  FROM base) e JOIN pizza_toppings t
  ON e.topping_id = t.topping_id
  GROUP BY e.rn	
)

SELECT b.order_id, CONCAT_WS(' - ', p.pizza_name, e.excl_string, x.ext_string)
FROM base b LEFT JOIN excl e
ON b.rn = e.rn LEFT JOIN ext x
ON b.rn = x.rn JOIN pizza_names p
ON b.pizza_id = p.pizza_id
ORDER BY b.order_id;