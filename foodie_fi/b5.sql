-- How many customers have churned straight after their initial free trial
-- what percentage is this rounded to the nearest whole number?

-- WITH all_customers AS
-- (
-- 	SELECT *
-- 	FROM subscriptions JOIN plans USING (plan_id)
-- ),
-- trial_customers AS (
-- 	SELECT *, True AS trial
-- 	FROM all_customers
-- 	WHERE plan_name = 'trial'
-- ),
-- final AS (
-- 	SELECT a.customer_id, a.plan_id, a.start_date, a.plan_name, a.price, t.trial
-- 	FROM all_customers a LEFT JOIN trial_customers t
-- 	ON a.customer_id = t.customer_id
-- 	ORDER BY a.customer_id, a.start_date
-- ),
-- ranked_subscriptions AS (
-- 	SELECT customer_id,
-- 		plan_name,
-- 		start_date,
-- 		trial,
-- 		RANK() OVER(PARTITION BY customer_id ORDER BY plan_id) AS rn
-- 	FROM final
-- ),
-- total_customers AS (
-- 	SELECT COUNT(DISTINCT customer_id) AS total
-- 	FROM all_customers
-- )

-- SELECT COUNT(*) AS churns_after_trial, ROUND(COUNT(*) * 100.0 / (SELECT total FROM total_customers)) AS percentage
-- FROM ranked_subscriptions
-- WHERE rn = 2 AND plan_name = 'churn' AND trial IS NOT NULL;

WITH cte AS (
	SELECT *, LEAD(plan_name, 1) OVER(PARTITION BY customer_id ORDER BY plan_id) AS next_plan
	FROM subscriptions JOIN plans USING (plan_id)
)

SELECT COUNT(*) AS churn_count, ROUND(COUNT(*)*100.0/(SELECT COUNT(DISTINCT customer_id) FROM cte WHERE plan_name = 'trial')) AS percentage
FROM cte
WHERE plan_name = 'trial' AND next_plan = 'churn';
