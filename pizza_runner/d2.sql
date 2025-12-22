-- 2. What if there was an additional $1 charge for any pizza extras?
--     Add cheese is $1 extra

SET search_path TO pizza_runner;

WITH successful_deliveries AS (
    SELECT co.order_id, co.pizza_id, pizza_name,
    CASE
        WHEN extras IS NULL THEN 0
        ELSE length(regexp_replace(extras, '[^,]', '', 'g')) + 1
    END AS no_of_extra_toppings
    FROM customer_orders co JOIN runner_orders ro
    ON co.order_id = ro.order_id
    JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
    WHERE cancellation IS NULL
)

SELECT '$' || SUM(
    CASE
        WHEN pizza_name = 'Meatlovers' THEN 12
        WHEN pizza_name = 'Vegetarian' THEN 10
    END + 1 * no_of_extra_toppings
) AS revenue
FROM successful_deliveries;