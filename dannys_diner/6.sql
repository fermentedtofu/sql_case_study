-- 6. Which item was purchased first by the customer after they became a member?
SET search_path TO dannys_diner;

WITH ranked_orders AS (
  SELECT
      s.customer_id,
      s.product_id,
      RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS order_rank
  FROM sales s JOIN members m
  ON s.customer_id = m.customer_id
  WHERE s.order_date >= m.join_date
)

SELECT r.customer_id, m.product_name
FROM ranked_orders r JOIN menu m
ON r.product_id = m.product_id
WHERE r.order_rank = 1;
