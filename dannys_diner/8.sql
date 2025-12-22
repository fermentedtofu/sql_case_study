-- 8. What is the total items and amount spent for each member before they became a member?
SET search_path TO dannys_diner;

SELECT customer_id, COUNT(product_id) AS total_items, SUM(price) AS amount_spent
FROM
  (SELECT s.customer_id, s.product_id, m.price
  FROM sales s JOIN menu m
  ON s.product_id = m.product_id
  JOIN members n
  ON s.customer_id = n.customer_id
  WHERE s.order_date < n.join_date) pre_membership_sales
GROUP BY customer_id;
