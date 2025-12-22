-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices 
-- with no cost for extras and each runner is paid $0.30 per kilometre traveled 
-- how much money does Pizza Runner have left over after these deliveries?

SET search_path TO pizza_runner;

WITH cte AS (
    SELECT 
        co.order_id,
        ro.distance,
        ROUND(0.3 * ro.distance, 2) AS runner_payout,
        ROUND(SUM(
            CASE
                WHEN pn.pizza_name = 'Meatlovers' THEN 12
                WHEN pn.pizza_name = 'Vegetarian' THEN 10
            END
        ), 2) AS pizza_price
    FROM customer_orders co JOIN runner_orders ro
    ON co.order_id = ro.order_id
    JOIN pizza_names pn
    ON co.pizza_id = pn.pizza_id
    WHERE cancellation IS NULL
    GROUP BY co.order_id, ro.distance
)

SELECT '$' || (SUM(pizza_price) - SUM(runner_payout)) AS profit
FROM cte;