-- 1. How many runners signed up for the service for each 1 week period? (i.e. week_starting_2021-01-01)
SET search_path TO pizza_runner;

SELECT '2021-01-01'::date + '7 days'::interval * ((registration_date - '2021-01-01'::date)/7) AS week, COUNT(runner_id) AS sign_ups
FROM runners
GROUP BY week
ORDER BY week;