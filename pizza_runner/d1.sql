-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes
-- How much money has Pizza Runner made so far if there are no delivery fees?

SET search_path TO pizza_runner;

WITH successful_deliveries AS (
    SELECT co.pizza_id, pizza_name
    FROM customer_orders co JOIN runner_orders ro
    ON co.order_id = ro.order_id
    JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
    WHERE cancellation IS NULL
)

SELECT '$' || SUM(
    CASE
        WHEN pizza_name = 'Meatlovers' THEN 12
        WHEN pizza_name = 'Vegetarian' THEN 10
    END
) AS revenue
FROM successful_deliveries;