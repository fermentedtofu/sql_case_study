-- What is the customer count and percentage of customers 
-- who have churned rounded to 1 decimal place?
WITH total_customers AS (
	SELECT COUNT(DISTINCT customer_id) AS total
	FROM subscriptions
)

SELECT churn_customers, ROUND(churn_customers*100.0/total, 1) AS percentage_of_customers
FROM (SELECT COUNT(DISTINCT customer_id) AS churn_customers
FROM plans JOIN subscriptions USING (plan_id)
WHERE plan_name = 'churn')
CROSS JOIN total_customers;