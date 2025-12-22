-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

WITH cte AS (
	SELECT customer_id, plan_name, start_date,
		LAG(plan_name) OVER(PARTITION BY customer_id ORDER BY start_date) AS previous_plan
	FROM subscriptions JOIN plans USING(plan_id)
)

SELECT COUNT(DISTINCT customer_id)
FROM cte
WHERE plan_name = 'basic monthly'
AND previous_plan = 'pro monthly'
AND EXTRACT(YEAR FROM start_date) = 2020;