
SELECT * FROM (
SELECT product_id, MAX(order_purchase_timestamp) AS last_purchase FROM olist_order_items_dataset itm
JOIN olist_orders_dataset ord
	ON ord.order_id = itm.order_id 
GROUP BY product_id
) as src
WHERE last_purchase > (SELECT MAX(order_purchase_timestamp) - interval ' 3 month' FROM olist_orders_dataset)
ORDER BY last_purchase DESC
