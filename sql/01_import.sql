CREATE TABLE orders (
    order_id                       VARCHAR(32) PRIMARY KEY,
    customer_id                    VARCHAR(32),
    order_status                   VARCHAR(20),
    order_purchase_timestamp       TIMESTAMP,
    order_approved_at              TIMESTAMP,
    order_delivered_carrier_date   TIMESTAMP,
    order_delivered_customer_date  TIMESTAMP,
    order_estimated_delivery_date  TIMESTAMP
);

SELECT COUNT(*) FROM orders;
SELECT * FROM orders LIMIT 5;

CREATE TABLE customers ( 
	customer_id				        VARCHAR(32) PRIMARY KEY,
	customer_unique_id				VARCHAR(32),
	customer_zip_code_prefix		VARCHAR(5),
	customer_city					VARCHAR(100),
	customer_state					VARCHAR(2)
);

SELECT COUNT(*)  FROM customers;

SELECT COUNT(DISTINCT customer_unique_id) FROM customers;
	
CREATE TABLE order_items (
	order_id						VARCHAR(32),
	order_item_id					INTEGER,
	product_id						VARCHAR(32),
	seller_id						VARCHAR(50),
	shipping_limit_date				TIMESTAMP,
	price							NUMERIC(10,2),
	freight_value					NUMERIC(10,2),
	PRIMARY KEY (order_id, order_item_id)
);

SELECT COUNT(*) FROM order_items
