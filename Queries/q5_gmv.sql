--Monthwise
CREATE VIEW q5_gmv_monthw AS
SELECT DATE_TRUNC('month', order_purchase_timestamp) as month_,
		SUM(price) FROM olist_order_items_dataset itm
JOIN olist_orders_dataset ord
	ON itm.order_id = ord.order_id
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY DATE_TRUNC('month', order_purchase_timestamp);


-- Month on Month

CREATE VIEW q5_gmv_mom AS 
SELECT DATE_TRUNC('month', order_purchase_timestamp) as month_,
		SUM(price) FROM olist_order_items_dataset itm
JOIN olist_orders_dataset ord
	ON itm.order_id = ord.order_id
GROUP BY DATE_TRUNC('month', order_purchase_timestamp), DATE_PART('month', order_purchase_timestamp),  DATE_TRUNC('year', order_purchase_timestamp) 
ORDER BY DATE_PART('month', order_purchase_timestamp), DATE_TRUNC('year', order_purchase_timestamp) 
