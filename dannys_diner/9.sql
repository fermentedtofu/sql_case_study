-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SET search_path TO dannys_diner;

-- Union Approach
WITH points_record AS (
	SELECT s.customer_id, s.product_id, m.product_name, m.price * 10 AS points
      FROM sales s JOIN menu m
      ON s.product_id = m.product_id
      WHERE s.product_id != 1
      UNION ALL
      SELECT s.customer_id, s.product_id, m.product_name, m.price * 20 AS points
      FROM sales s JOIN menu m
      ON s.product_id = m.product_id
      WHERE s.product_id = 1
)

SELECT customer_id, SUM(points)
FROM points_record
GROUP BY customer_id
ORDER BY customer_id;

-- Case statement approach
SELECT 
	s.customer_id,
    SUM(
    	CASE
      		WHEN s.product_id = 1 THEN m.price * 20
      		ELSE m.price * 10
      	END
    ) AS total_points
FROM sales s JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;