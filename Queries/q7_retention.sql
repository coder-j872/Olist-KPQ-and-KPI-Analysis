--If want to extend -  i can also do like track the orders and if the second order is of more cost than 1st 
--one in most cases then i can reccomend company to focus on how to make customer repurchase, for extention on my project


--Repeat purchasing rate
CREATE VIEW q7_repeat_purch_rate AS 
SELECT (
		SELECT CAST(COUNT(repeat_customers) AS DECIMAL(10,2)) AS total_order FROM (
			SELECT COUNT(customer_id) AS repeat_customers FROM olist_customers_dataset
				GROUP BY customer_unique_id
				HAVING COUNT(customer_id) > 1)) / (SELECT CAST(COUNT(DISTINCT customer_unique_id)AS DECIMAL(10,2)) AS customers FROM olist_customers_dataset) * 10;


-- Customers with repeat purchase
CREATE VIEW q7_value_demog AS 
WITH pyt AS (
	SELECT order_id, SUM(payment_value) AS payment_value FROM olist_order_payments_dataset
		GROUP BY order_id
	),
all_cuss AS
	(SELECT * FROM 
		(SELECT 
			cuss.customer_unique_id, 
			order_purchase_timestamp, 
			COUNT(ord.order_id) OVER (PARTITION BY cuss.customer_unique_id) AS total_orders,
			order_id AS ordid,
			RANK() OVER(PARTITION BY customer_unique_id ORDER BY order_purchase_timestamp ASC) AS rank_		
			FROM olist_customers_dataset cuss
			JOIN olist_orders_dataset ord
				ON cuss.customer_id = ord.customer_id
		) AS src
		JOIN pyt
			ON src.ordid = pyt.order_id
		WHERE rank_ = 1
		ORDER BY customer_unique_id DESC
	), 
bands AS 
	(SELECT 
		PERCENTILE_CONT(0.33) WITHIN GROUP(ORDER BY payment_value) AS low_band, 
		PERCENTILE_CONT(0.67) WITHIN GROUP(ORDER BY payment_value) AS high_band
		FROM all_cuss 
	),
all_demo AS(
	SELECT customer_unique_id, total_orders,
		CASE 
			WHEN payment_value < low_band THEN 'low' 
			WHEN payment_value < high_band THEN 'medium'
			ELSE 'high' 
		END AS demo 
		FROM all_cuss, bands
	)
SELECT 
	demo, COUNT(customer_unique_id) AS total_customer, COUNT(CASE WHEN total_orders > 1 THEN customer_unique_id END) AS multi_order_customer
	FROM all_demo
	GROUP BY demo
	ORDER BY COUNT(CASE WHEN total_orders > 1 THEN customer_unique_id END)