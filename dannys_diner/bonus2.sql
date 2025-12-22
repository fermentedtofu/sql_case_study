-- Bonus question 2
SET search_path TO dannys_diner;

SELECT
	*,
	CASE
		WHEN member = 'N' THEN NULL
		ELSE DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY CASE WHEN member = 'Y' THEN order_date END)
	END AS ranking
FROM everything;