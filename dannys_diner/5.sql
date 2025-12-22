-- 5. Which item was the most popular for each customer?
SET search_path TO dannys_diner;

WITH ranked_sales AS (
  SELECT
      customer_id,
      product_id,
      RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(product_id) DESC) AS sales_rank
  FROM sales
  GROUP BY customer_id, product_id
)

SELECT r.customer_id, m.product_name
FROM ranked_sales r JOIN menu m
ON r.product_id = m.product_id
WHERE r.sales_rank = 1
ORDER BY r.customer_id;