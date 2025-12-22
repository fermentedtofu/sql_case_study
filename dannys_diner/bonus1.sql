-- Bonus question 1
SET search_path TO dannys_diner;

CREATE VIEW everything AS	
    SELECT 
		s.customer_id,
		s.order_date,
		m.product_name,
		m.price,
		CASE
			WHEN mb.join_date IS NULL THEN 'N'
            WHEN s.order_date < mb.join_date THEN 'N'
			ELSE 'Y'
		END AS member
	FROM sales s JOIN menu m
	ON s.product_id = m.product_id
	LEFT JOIN members mb
	ON s.customer_id = mb.customer_id
    ORDER BY s.customer_id, s.order_date;
    
SELECT * FROM everything;

