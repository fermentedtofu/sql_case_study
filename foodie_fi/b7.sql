-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

WITH latest_start_date AS (
	SELECT customer_id, MAX(start_date) AS start_date
	FROM subscriptions JOIN plans USING (plan_id)
	WHERE start_date <= '2020-12-31'
	GROUP BY customer_id
	ORDER BY customer_id
)

SELECT p.plan_name,
	COUNT(s.customer_id),
	ROUND(COUNT(s.customer_id)*100.0/(SELECT COUNT(*) FROM latest_start_date), 1) AS percentage
FROM subscriptions s JOIN latest_start_date lsd
ON s.customer_id = lsd.customer_id
AND s.start_date = lsd.start_date
JOIN plans p ON s.plan_id = p.plan_id
GROUP BY p.plan_name;

