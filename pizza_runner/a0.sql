-- Data Preparation
SET search_path TO pizza_runner;

UPDATE runner_orders
SET pickup_time = CASE
	WHEN pickup_time = 'null' THEN NULL
    ELSE pickup_time
END,
cancellation = CASE
	WHEN cancellation IN ('null', '') THEN NULL
    ELSE cancellation
END
WHERE pickup_time = 'null'
OR cancellation IN ('null', '');

UPDATE runner_orders
SET distance = CASE
	WHEN distance = 'null' THEN NULL
    ELSE substring(distance, '\d+(?:\.\d+)?')
END,
duration = CASE
	WHEN duration = 'null' THEN NULL
    ELSE substring(duration, '\d+(?:\.\d+)?')
END;

ALTER TABLE runner_orders
	ALTER COLUMN pickup_time TYPE TIMESTAMP
    USING pickup_time::timestamp,
    ALTER COLUMN distance TYPE NUMERIC
    USING distance::numeric,
    ALTER COLUMN duration TYPE NUMERIC
    USING duration::numeric;

UPDATE customer_orders
SET exclusions = NULL
WHERE exclusions = ''
OR exclusions = 'null';

UPDATE customer_orders
SET extras = NULL
WHERE extras = ''
OR extras = 'null';