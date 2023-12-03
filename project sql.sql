##1 Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
use project;
SELECT 
    olist_orders_dataset.order_id, 
    olist_orders_dataset.order_purchase_timestamp, 
    olist_order_payments_dataset.payment_value, 
    CASE 
        WHEN DAYOFWEEK(olist_orders_dataset.order_purchase_timestamp) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type 
FROM 
    olist_orders_dataset
JOIN 
    olist_order_payments_dataset  ON olist_orders_dataset.order_id = olist_order_payments_dataset.order_id;
    
   SELECT COUNT(*) AS total_orders
FROM olist_orders_dataset;

-- Calculate the count of orders for weekdays and its percentage of the total
SELECT
    COUNT(*) AS order_count_weekday,
    (COUNT(*) / (SELECT COUNT(*) FROM olist_orders_dataset)) * 100 AS percentage_weekday
FROM
    olist_orders_dataset
WHERE
    DAYOFWEEK(order_purchase_timestamp) BETWEEN 2 AND 6;

-- Calculate the count of orders for weekends and its percentage of the total
SELECT
    COUNT(*) AS order_count_weekend,
    (COUNT(*) / (SELECT COUNT(*) FROM olist_orders_dataset)) * 100 AS percentage_weekend
FROM
    olist_orders_dataset
WHERE
    DAYOFWEEK(order_purchase_timestamp) IN (1, 7); 
    
## 2 Number of Orders with review score 5 and payment type as credit card.

SELECT COUNT(*) AS order_count
 FROM olist_order_payments_dataset AS payments
JOIN olist_order_review_dataset1 AS reviews
    ON payments.order_id = reviews.order_id
WHERE reviews.review_score = 5
AND payments.payment_type = 'credit_card';

##3 Average number of days taken for order_delivered_customer_date for pet_shop

SELECT
    AVG(DATEDIFF(od.order_delivered_customer_date, od.order_purchase_timestamp)) AS avg_delivery_days
FROM
    olist_order_items_dataset AS ocd
JOIN
    olist_orders_dataset AS od
    ON ocd.order_id = od.order_id
JOIN
    olist_products_dataset AS opd
    ON ocd.product_id = opd.product_id
WHERE
    opd.product_category_name = 'pet_shop'
    AND od.order_delivered_customer_date IS NOT NULL;

##4 Average price and payment values from customers of sao paulo city

SELECT
    AVG(order_item.price) AS avg_price,
    AVG(order_payment.payment_value) AS avg_payment
FROM
    olist_order_items_dataset AS order_item
JOIN
    olist_order_payments_dataset AS order_payment
    ON order_item.order_id = order_payment.order_id
JOIN
    olist_sellers_dataset AS sellers
    ON order_item.seller_id = sellers.seller_id
JOIN
    olist_geolocation_dataset AS geolocation
    ON sellers.seller_zip_code_prefix = geolocation.geolocation_zip_code_prefix
WHERE
    geolocation.geolocation_city = 'Sao Paulo';
    
##5 Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

SELECT 
     r.review_score, 
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_shipping_days
FROM 
    olist_order_payments_dataset AS p
JOIN 
    olist_order_review_dataset1 AS r
    ON p.order_id = r.order_id
JOIN
    olist_orders_dataset AS o
    ON p.order_id = o.order_id
WHERE 
    o.order_delivered_customer_date IS NOT NULL 
    AND o.order_purchase_timestamp IS NOT NULL
GROUP BY
    r.review_score;
    



    
    
    
    
    
    
    
    
