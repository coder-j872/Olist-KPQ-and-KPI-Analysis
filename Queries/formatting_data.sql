
ALTERING DATATYPE
ALTER TABLE olist_orders_dataset ALTER COLUMN order_approved_at TYPE timestamp USING NULLIF(order_approved_at, '')::timestamp;
ALTER TABLE olist_orders_dataset ALTER COLUMN order_delivered_carrier_date TYPE timestamp USING NULLIF(order_delivered_carrier_date, '')::timestamp;
ALTER TABLE olist_orders_dataset ALTER COLUMN order_purchase_timestamp TYPE timestamp USING NULLIF(order_purchase_timestamp, '')::timestamp;
ALTER TABLE olist_orders_dataset ALTER COLUMN order_delivered_customer_date TYPE timestamp USING NULLIF(order_delivered_customer_date, '')::timestamp;
ALTER TABLE olist_orders_dataset ALTER COLUMN order_estimated_delivery_date TYPE timestamp USING NULLIF(order_estimated_delivery_date, '')::timestamp;



