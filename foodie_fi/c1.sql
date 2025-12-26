WITH RECURSIVE payments AS (
    SELECT
        customer_id,
        plan_id,
        plan_name,
        start_date AS payment_date,
        price AS payment_amount,
        LEAD(start_date) OVER(PARTITION BY customer_id ORDER BY start_date) AS next_date
    FROM subscriptions JOIN plans USING (plan_id)
    WHERE plan_name != 'trial'
    AND start_date <= '2020-12-31'
    UNION ALL
    SELECT
        customer_id,
        plan_id,
        plan_name,
        (payment_date + INTERVAL '1 month')::DATE AS payment_date,
        payment_amount,
        next_date
    FROM payments
    WHERE plan_name IN ('pro monthly', 'basic monthly')
    AND (payment_date + INTERVAL '1 month') < COALESCE(next_date, '2021-01-01')
)

SELECT
    customer_id,
    plan_id,
    plan_name,
    CASE
        WHEN 
            LAG(plan_name) OVER(PARTITION BY customer_id ORDER BY payment_date) = 'pro monthly' AND
            plan_name = 'pro annual' AND 
            payment_date < (LAG(payment_date) OVER(PARTITION BY customer_id ORDER BY payment_date) + INTERVAL '1 month')::DATE
        THEN (LAG(payment_date) OVER(PARTITION BY customer_id ORDER BY payment_date) + INTERVAL '1 month')::DATE
        ELSE payment_date
   END AS payment_date,
    CASE
        WHEN 
            LAG(plan_name) OVER(PARTITION BY customer_id ORDER BY payment_date) IN ('basic monthly') AND
            plan_name IN ('pro monthly', 'pro annual') AND 
            payment_date < (LAG(payment_date) OVER(PARTITION BY customer_id ORDER BY payment_date) + INTERVAL '1 month')::DATE
        THEN payment_amount - 9.90
        ELSE payment_amount
    END AS payment_amount,
    ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY payment_date) AS payment_order
FROM payments
WHERE plan_name != 'churn';
