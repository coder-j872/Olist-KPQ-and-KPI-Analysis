--Overall cancellation rate 
CREATE VIEW q4_overall_canc_rate AS
SELECT (SELECT CAST (COUNT(order_status) AS DECIMAL(10,4)) FROM olist_orders_dataset
	WHERE order_status = 'canceled') / 
(SELECT CAST (COUNT(order_status) AS DECIMAL(10,4)) FROM olist_orders_dataset) * 100;




-- Sellers with highest cancelation rate
CREATE VIEW q4_seller_cr AS
SELECT seller_id, total_o, total_c,  (CAST((total_c / total_o) AS DECIMAL(10,3)) * 100) AS cancel_rate FROM (
	SELECT seller_id, CAST(COUNT(DISTINCT CASE WHEN order_status = 'canceled' THEN ord.order_id END) AS DECIMAL(10,3)) AS total_c,  
	CAST(COUNT(DISTINCT ord.order_id) AS DECIMAL(10,3)) AS total_o FROM olist_orders_dataset ord
	JOIN olist_order_items_dataset itm
		ON ord.order_id = itm.order_id
	GROUP BY seller_id
	ORDER BY total_c DESC)
	ORDER BY cancel_rate DESC, total_o DESC;

-- sellers with highest cancellation -- runnig total(cummulative) of cancelation and orders

CREATE VIEW q4_cumm_seller_and_canceln AS
SELECT seller_id, 
	total_o, 
	total_c, 
	(CAST((total_c / total_o) AS DECIMAL(10,3)) * 100) AS cancel_rate,
	SUM(total_c) OVER(ORDER BY row_id) AS cumm_sum_can,
	SUM(total_o) OVER(ORDER BY row_id) AS cumm_ord,
	CAST(CAST(row_id AS DECIMAL(10,2)) / 3095 * 100 AS DECIMAL(10,2)) AS perc_of_sellers,
	CAST(SUM(total_c) OVER(ORDER BY row_id) / 461 * 100 AS DECIMAL(10,2)) AS perc_of_cancel
	FROM(
			SELECT seller_id, total_c, total_o, ROW_NUMBER() OVER(ORDER BY total_c DESC, total_o) AS row_id
			FROM (
					(SELECT seller_id, 
					CAST(COUNT(DISTINCT CASE WHEN order_status = 'canceled' THEN ord.order_id END) AS DECIMAL(10,3)) AS total_c,  
					CAST(COUNT(DISTINCT ord.order_id) AS DECIMAL(10,3)) AS total_o
					FROM olist_orders_dataset ord
					JOIN olist_order_items_dataset itm
						ON ord.order_id = itm.order_id
					GROUP BY seller_id
					ORDER BY total_c DESC)))
		--	WHERE total_C > 0 -- use this if want only sellers with atleast 1 canceled order
	ORDER BY total_c DESC, cancel_rate DESC;



-- sellers with highest cancellation -- runnig total(cummulative) of cancelation and orders
SELECT seller_id, 
	total_o, 
	total_c, 
	(CAST((total_c / total_o) AS DECIMAL(10,3)) * 100) AS cancel_rate,
	SUM(total_c) OVER(ORDER BY row_id) AS cumm_sum_can,
	SUM(total_o) OVER(ORDER BY row_id) AS cumm_ord
	FROM(
			SELECT seller_id, total_c, total_o, ROW_NUMBER() OVER(ORDER BY total_c DESC, total_o) AS row_id
			FROM (
					(SELECT seller_id, 
					CAST(COUNT(DISTINCT CASE WHEN order_status = 'canceled' THEN ord.order_id END) AS DECIMAL(10,3)) AS total_c,  
					CAST(COUNT(DISTINCT ord.order_id) AS DECIMAL(10,3)) AS total_o
					FROM olist_orders_dataset ord
					JOIN olist_order_items_dataset itm
						ON ord.order_id = itm.order_id
					GROUP BY seller_id
					ORDER BY total_c DESC)))
		--	WHERE total_C > 0 -- use this if want only sellers with atleast 1 canceled order
	ORDER BY total_c DESC, cancel_rate DESC