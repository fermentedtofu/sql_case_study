-- How many customers have upgraded to an annual plan in 2020?

SELECT COUNT(DISTINCT customer_id)
FROM subscriptions JOIN plans USING (plan_id)
WHERE plan_name = 'pro annual'
AND EXTRACT(YEAR FROM start_date) = '2020';