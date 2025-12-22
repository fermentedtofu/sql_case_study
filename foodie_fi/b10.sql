-- Can you further break down this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)?

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
),
days_taken AS (
	SELECT ud.start_date - cjd.joined_date AS days_taken
	FROM customer_joined_date cjd JOIN upgrade_date ud
	ON cjd.customer_id = ud.customer_id
),
intervals AS (
	SELECT 
		CASE
			WHEN days_taken <= 30 THEN 0
			ELSE CEIL(days_taken/30.0)*30-29
		END AS start_date,
		CEIL(days_taken/30.0)*30 AS end_date,
		days_taken
	FROM days_taken
),
max_days AS (
	SELECT MAX(days_taken)
	FROM days_taken
)

SELECT 
	CONCAT(start_date, '-', end_date, ' days') AS "30_day_interval",
	COUNT(days_taken)
	FROM intervals
	GROUP BY "30_day_interval", start_date
	ORDER BY start_date;