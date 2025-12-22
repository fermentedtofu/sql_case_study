-- How many days on average does it take for a customer to upgrade to an annual plan from the day they join Foodie-Fi?

WITH customer_joined_date AS (
	SELECT customer_id, MIN(start_date) AS joined_date
	FROM subscriptions
	GROUP BY customer_id
	ORDER BY customer_id
),
upgrade_date AS (
	SELECT customer_id, MIN(start_date) AS start_date
	FROM subscriptions s JOIN plans p USING (plan_id)
	WHERE plan_name = 'pro annual'
	GROUP BY customer_id
)

SELECT ROUND(AVG(ud.start_date - cjd.joined_date), 1) AS average_days_taken
FROM customer_joined_date cjd JOIN upgrade_date ud
ON cjd.customer_id = ud.customer_id;