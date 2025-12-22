-- 4. Using your newly generated table - can you join all of the information together to form a table which has 
-- the following information for successful deliveries?

--     customer_id
--     order_id
--     runner_id
--     rating
--     order_time
--     pickup_time
--     Time between order and pickup
--     Delivery duration
--     Average speed
--     Total number of pizzas

SET search_path TO pizza_runner;

WITH unique_orders AS (
    SELECT order_id, customer_id, runner_id, order_time, pickup_time, distance, duration, COUNT(pizza_id) AS total_pizzas
    FROM customer_orders co JOIN runner_orders USING (order_id)
    WHERE cancellation IS NULL
    GROUP BY order_id, customer_id, runner_id, order_time, pickup_time, distance, duration
)

SELECT
    uo.customer_id,
    uo.order_id,
    uo.runner_id,
    rr.rating,
    uo.order_time,
    uo.pickup_time,
    uo.pickup_time - uo.order_time AS "Time between order and pickup",
    uo.duration,
    ROUND(uo.distance / (uo.duration / 60), 2) AS "Average speed (km/h)",
    uo.total_pizzas AS "Total number of pizzas"
FROM unique_orders uo JOIN runner_ratings rr
ON uo.order_id = rr.order_id;
