-- 5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients

    -- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
    
SET search_path TO pizza_runner;

WITH base AS (
  SELECT co.order_id, co.pizza_id, pn.pizza_name, co.extras, co.exclusions,
     ROW_NUMBER() OVER(ORDER BY order_id) AS rn
  FROM customer_orders co JOIN pizza_names pn
  ON co.pizza_id = pn.pizza_id
),
ext AS (
  SELECT *
  FROM (SELECT rn, order_id, pizza_id, pizza_name, UNNEST(STRING_TO_ARRAY(extras, ', '))::INT AS topping_id
  FROM base) e JOIN pizza_toppings t
  ON e.topping_id = t.topping_id
),
excl AS (
 SELECT *
  FROM (SELECT rn, order_id, pizza_id, pizza_name, UNNEST(STRING_TO_ARRAY(exclusions, ', '))::INT AS topping_id
  FROM base) e JOIN pizza_toppings t
  ON e.topping_id = t.topping_id 
),
ingredients AS (
 SELECT pizza_id, UNNEST(STRING_TO_ARRAY(toppings, ', '))::INT AS topping_id
 FROM pizza_recipes
),
pz AS (
 SELECT i.pizza_id, t.topping_name
     FROM ingredients i JOIN pizza_toppings t
     ON i.topping_id = t.topping_id
),
combined AS (
  SELECT c.rn, c.order_id, c.pizza_id, c.pizza_name, c.topping_name, COUNT(c.topping_name) AS count
FROM (
    SELECT b.rn, b.order_id, b.pizza_id, b.pizza_name, pz.topping_name
    FROM base b JOIN pz
    ON b.pizza_id = pz.pizza_id
    UNION ALL
    SELECT e.rn, e.order_id, e.pizza_id, e.pizza_name, e.topping_name
    FROM ext e
) c LEFT JOIN excl e ON c.rn = e.rn AND c.topping_name = e.topping_name
WHERE e.topping_name IS NULL
GROUP BY c.rn, c.order_id, c.pizza_id, c.pizza_name, c.topping_name
ORDER BY c.rn, c.order_id, c.pizza_id, c.pizza_name, c.topping_name
)
  

SELECT c.order_id, c.pizza_id,
c.pizza_name || ': ' || ARRAY_TO_STRING(ARRAY_AGG(
 CASE
         WHEN count = 2 THEN '2x' || c.topping_name
         ELSE c.topping_name
     END
), ', ') AS order_item
FROM combined c
GROUP BY c.rn, c.order_id, c.pizza_name, c.pizza_id;