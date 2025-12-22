-- What plan start_date values occur after the year 2020 for our dataset?
-- Show the breakdown by count of events for each plan_name

SELECT plan_name, COUNT(*)
FROM plans JOIN subscriptions USING (plan_id)
WHERE EXTRACT(YEAR FROM start_date) > 2020
GROUP BY  plan_name;