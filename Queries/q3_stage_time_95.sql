CREATE VIEW q3_p95_ocv AS
SELECT 	 
	
	AVG(order_approved_at - order_purchase_timestamp) AS f_approved, 
	AVG(order_delivered_carrier_date - order_approved_at) AS f_shipping, 
	AVG(order_delivered_customer_date - order_delivered_carrier_date) AS f_delivery,
	AVG(order_delivered_customer_date - order_purchase_timestamp) AS f_total 

	FROM (SELECT * FROM olist_orders_dataset
		WHERE (order_delivered_customer_date IS NOT NULL) 
			AND (order_approved_at IS NOT NULL) 
			AND (order_purchase_timestamp IS NOT NULL)
			AND (order_delivered_carrier_date IS NOT NULL)
			AND (order_delivered_customer_date - order_purchase_timestamp) > (SELECT PERCENTILE_CONT(.95) WITHIN GROUP (
				ORDER BY (order_delivered_customer_date - order_purchase_timestamp)) FROM olist_orders_dataset) 
		ORDER BY (order_delivered_customer_date - order_purchase_timestamp) DESC
	
)


