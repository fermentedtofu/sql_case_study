WITH cte AS (
	SELECT *, LEAD(plan_name) OVER(PARTITION BY customer_id ORDER BY start_date) AS next_plan
	FROM subscriptions JOIN plans USING (plan_id)
)

SELECT next_plan AS plan,
	COUNT(next_plan),
	ROUND(COUNT(next_plan) * 100.0 /(SELECT COUNT(*) FROM cte WHERE plan_name = 'trial'), 2) AS percentage
FROM cte
WHERE plan_name = 'trial'
GROUP BY next_plan;