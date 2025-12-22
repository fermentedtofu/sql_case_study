-- 3. What was the first item from the menu purchased by each customer?
SET search_path TO dannys_diner;

-- subquery method
SELECT a.customer_id, p.product_name
FROM
	(SELECT s.customer_id, MIN(s.product_id) AS first_product_id
	FROM sales s 
	JOIN 
    	(SELECT customer_id, MIN(order_date) AS earliest_date	
		FROM sales
		GROUP BY customer_id) t
	ON s.customer_id = t.customer_id
	AND s.order_date = t.earliest_date
	GROUP BY s.customer_id) a
JOIN menu p
ON a.first_product_id = p.product_id;

-- window function method
WITH ranked_sales AS (
  SELECT 
      s.customer_id,
      s.order_date,
      m.product_name,
      ROW_NUMBER() OVER(
        PARTITION BY s.customer_id
        ORDER BY s.order_date, s.product_id
      ) AS rn
  FROM sales s JOIN menu m
  ON s.product_id = m.product_id
)

SELECT customer_id, product_name
FROM ranked_sales
WHERE rn = 1;
