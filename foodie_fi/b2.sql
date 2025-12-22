-- What is the monthly distribution of trial plan start_date values for our dataset
-- use the start of the month as the group by value

SET search_path TO foodie_fi;

SELECT EXTRACT(MONTH FROM start_date) AS month, COUNT(start_date)
FROM plans JOIN subscriptions USING (plan_id)
WHERE plan_name = 'trial'
GROUP BY month
ORDER BY month;