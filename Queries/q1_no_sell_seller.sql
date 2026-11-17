--No sell from seller in last 90 days

CREATE VIEW q1_no_sell AS
SELECT * FROM (
SELECT seller_id, MAX(order_purchase_timestamp) AS last_purchase FROM olist_order_items_dataset itm
JOIN olist_orders_dataset ord
	ON ord.order_id = itm.order_id 
GROUP BY seller_id
) as src
WHERE last_purchase < (SELECT MAX(order_purchase_timestamp) - interval ' 90 days' FROM olist_orders_dataset)
ORDER BY last_purchase DESC
