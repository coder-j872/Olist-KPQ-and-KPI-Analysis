--AOV

CREATE VIEW q6_aov AS 
SELECT 
	DATE_TRUNC('month', ord.order_purchase_timestamp),
	SUM(payment_value) AS GMV, 
	COUNT(DISTINCT pyt.order_id) AS total_orders, 
	SUM(payment_value) / COUNT(DISTINCT pyt.order_id) AS AOV 
FROM olist_order_payments_dataset pyt
JOIN olist_orders_dataset ord
	ON pyt.order_id = ord.order_id
GROUP BY DATE_TRUNC('month', ord.order_purchase_timestamp)
HAVING COUNT(DISTINCT pyt.order_id) > 100

