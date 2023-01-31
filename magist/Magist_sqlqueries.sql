##  What categories of tech products does Magist have  ##
SELECT 
    product_category_name_english AS 'Tech product category',
    COUNT(products.product_id) AS products,
    sum(products.product_id) as sum_of_products
FROM
    product_category_name_translation
        LEFT JOIN
    products ON products.product_category_name = product_category_name_translation.product_category_name
        INNER JOIN
    order_items ON products.product_id = order_items.product_id
WHERE
    product_category_name_english IN ('Computers' , 'computers_accessories',
        'Electronics',
        'Tablets_printing_images',
        'watches_gifts')
GROUP BY product_category_name_english;


##What’s the average price of the products being sold?##
SELECT round(avg (price)) as avg_products,
    product_category_name_english AS 'Tech product category',
    COUNT(products.product_id) AS products
FROM
    product_category_name_translation
        LEFT JOIN
    products ON products.product_category_name = product_category_name_translation.product_category_name
        INNER JOIN
    order_items ON products.product_id = order_items.product_id
WHERE
    product_category_name_english IN ('Computers' , 'Computers_accessories',
        'Electronics',
        'Tablets_printing_images',
        'watches_gifts')
GROUP BY product_category_name_english;


##Are expensive tech products popular?##
select max( product_category_name_english) as expensive,
    COUNT(products.product_id) AS products
FROM
    product_category_name_translation
        LEFT JOIN
    products ON products.product_category_name = product_category_name_translation.product_category_name
        INNER JOIN
    order_items ON products.product_id = order_items.product_id
WHERE
    product_category_name_english IN ('Computers' , 'computers_accessories',
        'Electronics',
        'Tablets_printing_images',
        'watches_gifts');
        
        
      SELECT 
    COUNT(order_items.product_id),
    COUNT(price),
    price_range,
    CASE
        WHEN price >= 1000 THEN 'very expensive'
        WHEN price >= 540 THEN 'expensive'
        WHEN price >= 200 THEN 'medium'
        WHEN price >= 50 THEN 'cheap'
        ELSE 'very cheap'
    END AS price_range
FROM
    order_items
        INNER JOIN
    products ON order_items.product_id = products.product_id
        INNER JOIN
    product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
WHERE
    product_category_name_english IN ('computers' , 'computers_accessories',
        'electronics',
        'tablets_printing_image',
        'watches_gifts')
GROUP BY price_range
ORDER BY COUNT(price) ASC;

        
        





##relation of sellers##
##1. how many months of date are in included in magist database
SELECT 
    MIN(order_purchase_timestamp) AS earliest_date,
    MAX(order_purchase_timestamp) AS present_date,
    TIMESTAMPDIFF(MONTH,
        '2016-09-04',
        '2018-10-17')
FROM
    orders;
       
       
	##2. how many sellers? how many tech sellers? % of overall sellers are tech sellers?##
    SELECT 
    COUNT(DISTINCT (seller_id)) AS number_of_sellers
FROM
    sellers;

SELECT 
    COUNT(DISTINCT (seller_id)) AS number_of_tech_sellers
FROM
    order_items
        INNER JOIN
    products ON order_items.product_id = products.product_id
        INNER JOIN
    product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
WHERE
    product_category_name_english IN ('computers' , 'computers_accessories',
        'electronics',
        'tablets_printing_image',
        'watches_gifts');

SELECT 
    (443 * 100 / COUNT(DISTINCT (seller_id))) AS Tech_sellers_percentage
FROM
    order_items;
    
    
    ##3. tot. amount of sellers?? tot. amount of tech sellers??##
SELECT 
    SUM(price) AS total_earning_of_sellars
FROM
    order_items;

SELECT 
    SUM(price) AS earnings_of_tech_sellars
FROM
    order_items
        INNER JOIN
    products ON order_items.product_id = products.product_id
        INNER JOIN
    product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
WHERE
    product_category_name_english IN ('computers' , 'computers_accessories',
        'electronics',
        'tablets_printing_image',
        'watches_gifts');

SELECT 
    (2507698.274344206 * 100 / SUM(price)) AS percentage_of_tech_sellers_earnings
FROM
    order_items;






##4. avg monthly income of all sellers and tech sellers??##
SELECT 
    COUNT(DISTINCT (seller_id)) AS 'Amount of all sellers'
FROM
    order_items;
##amount of all sales for sellers:
SELECT 
    SUM(price) AS total_earning_of_sellars
FROM
    order_items;
##total amount of months:
SELECT 
    MIN(order_purchase_timestamp) AS earliest_date,
    MAX(order_purchase_timestamp) AS present_date,
    TIMESTAMPDIFF(MONTH,
        '2016-09-04',
        '2018-10-17')
FROM
    orders;


##In realtion to delivery time##
##1. avg time of order placed and product delivered##
SELECT 
    AVG(TIMESTAMPDIFF(DAY,
        order_purchase_timestamp,
        order_delivered_customer_date))
FROM
    orders;
    
    
    ##2. how many orders are delivered on time vs orders delivered with delay??##
    SELECT 
    COUNT(*), orders.order_status AS status
FROM
    orders
        INNER JOIN
    order_items ON orders.order_id = order_items.order_id
GROUP BY status;
    
    ##Aagata##
SELECT 
    COUNT(order_id) AS deliveries,
    CASE
        WHEN
            TIMESTAMPDIFF(DAY,
                order_estimated_delivery_date,
                order_delivered_customer_date) < 0
        THEN
            'early delivery'
        WHEN
            TIMESTAMPDIFF(DAY,
                order_estimated_delivery_date,
                order_delivered_customer_date) = 0
        THEN
            'on-time delivery'
        ELSE 'late delivery'
    END AS 'waiting_time'
FROM
    orders
GROUP BY waiting_time
ORDER BY deliveries ASC;

##Tania##
SELECT 
    COUNT(DISTINCT order_id) AS delivered_with_delay
FROM
    orders
WHERE
    (TIMESTAMPDIFF(DAY,
        order_delivered_customer_date,
        order_estimated_delivery_date)) < 0;

SELECT 
    COUNT(DISTINCT order_id) AS delivered_on_time
FROM
    orders;
    
    ##3.pattern for delayed orders eg. big products being delayed more often?##
    SELECT 
    COUNT(*), orders.order_status AS status
FROM
    products
        LEFT JOIN
    order_items ON products.product_id = order_items.product_id
        INNER JOIN
    orders ON order_items.order_id = orders.order_id
GROUP BY status;
    
    






