
-- 01_import.sql : création des 9 tables et import des fichiers CSV
-- Script à exécuter UNE SEULE FOIS sur une base olist vide




-- 1 ligne = 1 commande et la Clé primaire : order_id
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

COPY orders
FROM 'C:/Projet_olist/data/olist_orders_dataset.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

SELECT COUNT(*) FROM orders;              


-- 1 ligne = 1 client par commande avec  Clé primaire : customer_id
-- Code postal en texte pour conserver les zéros initiaux 
CREATE TABLE customers (
    customer_id               VARCHAR(32) PRIMARY KEY,
    customer_unique_id        VARCHAR(32),
    customer_zip_code_prefix  VARCHAR(5),
    customer_city             VARCHAR(100),
    customer_state            VARCHAR(2)
);

COPY customers
FROM 'C:/Projet_olist/data/olist_customers_dataset.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

SELECT COUNT(*) FROM customers;           


-- 1 ligne = 1 article d'une commande (plusieurs articles possibles par commande)
-- Clé primaire composée : (order_id, order_item_id)
CREATE TABLE order_items (
    order_id             VARCHAR(32),
    order_item_id        INTEGER,
    product_id           VARCHAR(32),
    seller_id            VARCHAR(32),
    shipping_limit_date  TIMESTAMP,
    price                NUMERIC(10,2),
    freight_value        NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

COPY order_items
FROM 'C:/Projet_olist/data/olist_order_items_dataset.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

SELECT COUNT(*) FROM order_items;       


-- 1 ligne = 1 paiement d'une commande (plusieurs paiements possibles par commande)
-- Clé primaire composée : (order_id, payment_sequential)
CREATE TABLE order_payments (
    order_id              VARCHAR(32),
    payment_sequential    INTEGER,
    payment_type          VARCHAR(32),
    payment_installments  INTEGER,
    payment_value         NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

COPY order_payments
FROM 'C:/Projet_olist/data/olist_order_payments_dataset.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

SELECT COUNT(*) FROM order_payments;      


-- 1 ligne = 1 avis client rattaché à une commande
-- Anomalie : un même review_id peut apparaître sur plusieurs commandes
-- Clé primaire composée : (review_id, order_id)
-- Import avec COPY : l'assistant DBeaver lisait mal les commentaires sur plusieurs lignes
CREATE TABLE order_reviews (
    review_id                VARCHAR(32),
    order_id                 VARCHAR(32),
    review_score             INTEGER,
    review_comment_title     VARCHAR(100),
    review_comment_message   TEXT,
    review_creation_date     TIMESTAMP,
    review_answer_timestamp  TIMESTAMP,
    PRIMARY KEY (review_id, order_id)
);

COPY order_reviews
FROM 'C:/Projet_olist/data/olist_order_reviews_dataset.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

SELECT COUNT(*) FROM order_reviews;      


-- 1 ligne = 1 produit | Clé primaire : product_id
-- Orthographe "lenght" conservée telle quelle (faute présente dans le fichier source)
CREATE TABLE products (
    product_id                  VARCHAR(32) PRIMARY KEY,
    product_category_name       VARCHAR(100),
    product_name_lenght         INTEGER,
    product_description_lenght  INTEGER,
    product_photos_qty          INTEGER,
    product_weight_g            INTEGER,
    product_length_cm           INTEGER,
    product_height_cm           INTEGER,
    product_width_cm            INTEGER
);

COPY products
FROM 'C:/Projet_olist/data/olist_products_dataset.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

SELECT COUNT(*) FROM products;            


-- 1 ligne = 1 vendeur avec Clé primaire : seller_id
CREATE TABLE sellers (
    seller_id               VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix  VARCHAR(5),
    seller_city             VARCHAR(100),
    seller_state            VARCHAR(2)
);

COPY sellers
FROM 'C:/Projet_olist/data/olist_sellers_dataset.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

SELECT COUNT(*) FROM sellers;             


-- 1 ligne = 1 catégorie (nom portugais en nom anglais)
-- Clé primaire : product_category_name (même type que dans products : clé de liaison)
CREATE TABLE category_translation (
    product_category_name          VARCHAR(100) PRIMARY KEY,
    product_category_name_english  VARCHAR(100)
);

COPY category_translation
FROM 'C:/Projet_olist/data/product_category_name_translation.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

SELECT COUNT(*) FROM category_translation;   


-- 1 ligne = 1 coordonnée GPS associée à un préfixe de code postal
-- Pas de clé primaire : 261 831 lignes strictement identiques dans le fichier source
CREATE TABLE geolocation (
    geolocation_zip_code_prefix  VARCHAR(5),
    geolocation_lat              DOUBLE PRECISION,
    geolocation_lng              DOUBLE PRECISION,
    geolocation_city             VARCHAR(100),
    geolocation_state            VARCHAR(2)
);

COPY geolocation
FROM 'C:/Projet_olist/data/olist_geolocation_dataset.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

SELECT COUNT(*) FROM geolocation;         