
--Overall
CREATE VIEW q2_order_cycle_view AS 
SELECT 
	AVG(order_approved_at - order_purchase_timestamp) AS f_approved, 
	AVG(order_delivered_carrier_date - order_approved_at) AS f_shipping, 
	AVG(order_delivered_customer_date - order_delivered_carrier_date) AS f_delivery,
	AVG(order_delivered_customer_date - order_purchase_timestamp) AS f_total
FROM (SELECT * FROM olist_orders_dataset
	WHERE (order_delivered_customer_date IS NOT NULL) 
	AND (order_approved_at IS NOT NULL) 
	AND (order_purchase_timestamp IS NOT NULL)
	AND (order_delivered_carrier_date IS NOT NULL));


--Monthly

CREATE VIEW q2_monthly_ocv AS
SELECT date_trunc('month', order_purchase_timestamp)  AS order_month,	
	COUNT(order_purchase_timestamp) order_count, 
	
	AVG(order_approved_at - order_purchase_timestamp) AS f_approved, 
	AVG(order_delivered_carrier_date - order_approved_at) AS f_shipping, 
	AVG(order_delivered_customer_date - order_delivered_carrier_date) AS f_delivery,
	AVG(order_delivered_customer_date - order_purchase_timestamp) AS f_total 
	
	FROM (SELECT * FROM olist_orders_dataset
	WHERE (order_delivered_customer_date IS NOT NULL) 
	AND (order_approved_at IS NOT NULL) 
	AND (order_purchase_timestamp IS NOT NULL)
	AND (order_delivered_carrier_date IS NOT NULL))
	
GROUP BY date_trunc('month', order_purchase_timestamp)
HAVING COUNT(order_purchase_timestamp) > 400
ORDER BY date_trunc('month', order_purchase_timestamp);


--Yearly

CREATE VIEW q2_yearly_ocv AS
SELECT date_trunc('year', order_purchase_timestamp) order_year, 
	COUNT(order_purchase_timestamp) as order_count, 
	AVG(order_approved_at - order_purchase_timestamp) AS f_approved, 
	AVG(order_delivered_carrier_date - order_approved_at) AS f_shipping, 
	AVG(order_delivered_customer_date - order_delivered_carrier_date) AS f_delivery,
	AVG(order_delivered_customer_date - order_purchase_timestamp) AS f_total 
	
	FROM (SELECT * FROM olist_orders_dataset
	WHERE (order_delivered_customer_date IS NOT NULL) 
	AND (order_approved_at IS NOT NULL) 
	AND (order_purchase_timestamp IS NOT NULL)
	AND (order_delivered_carrier_date IS NOT NULL))


GROUP BY date_trunc('year', order_purchase_timestamp)
ORDER BY date_trunc('year', order_purchase_timestamp);