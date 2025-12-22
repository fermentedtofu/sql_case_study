-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SET search_path TO dannys_diner;

SELECT 
	s.customer_id,
    SUM(
    	CASE
      		WHEN s.order_date BETWEEN mb.join_date AND mb.join_date + 6 THEN m.price * 2 * 10
      		WHEN s.product_id = 1 THEN m.price * 2 * 10
      		ELSE m.price * 1 * 10
      	END
    ) AS total_points
FROM sales s JOIN members mb
ON s.customer_id = mb.customer_id
JOIN menu m
ON s.product_id = m.product_id
WHERE EXTRACT(MONTH FROM s.order_date) = 1
GROUP BY s.customer_id
ORDER BY s.customer_id;