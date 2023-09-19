# TheLook Ecommerce
This is a project exploration data with Google BigQuery SQL and make a dashboard with Looker Studio using
dataset TheLook Ecommerce that I took from public dataset Google Bigquery. This project is from RevoU Mini Course Data Analytics.

Table of interests :
- `bigquery-public-data.thelook_ecommerce.orders`
- `bigquery-public-data.thelook_ecommerce.order_items`
- `bigquery-public-data.thelook_ecommerce.users`
- `bigquery-public-data.thelook_ecommerce.products`

### Analysis :
1.  Monthly Sales
    ```
    SELECT 
    DATE_TRUNC(DATE(oi.created_at),MONTH) AS order_date,
      SUM(oi.sale_price*o.num_of_item) AS revenue,
      COUNT(DISTINCT oi.order_id) AS order_count,
      COUNT(DISTINCT oi.user_id) AS customers_purchased
    FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    LEFT JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o 
    ON oi.order_id = o.order_id
    WHERE oi.status NOT IN ('Cancelled','Returned')
    GROUP BY 1
    ORDER BY 1 DESC;
    ```
    Result : Revenues, total orders and total customers are increased by time. Total orders are more than total customers, which means customers buy more than 1 products.

2.  Customers by Country
    ```
    WITH
    cust AS (
      SELECT 
        DISTINCT oi.user_id,
        SUM(CASE WHEN u.gender = 'M' THEN 1 ELSE null END) AS male,
        SUM(CASE WHEN u.gender = 'F' THEN 1 ELSE null END) AS female,
        u.country AS country
      FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
      INNER JOIN `bigquery-public-data.thelook_ecommerce.users` AS u  
      ON oi.user_id = u.id
      WHERE oi.status NOT IN ('Cancelled','Returned')
      GROUP BY 1, 4
    )
    
    SELECT
      c.country,
      COUNT(DISTINCT c.user_id) AS customers_count,
      COUNT(c.female) AS female,
      COUNT(c.male) AS male
    FROM cust AS c
    GROUP BY 1
    ORDER BY 2 DESC;
    ```
    Result : The majority of customers is from China, United States and Brazil.

3.  Customers by Age Group
    ```
    SELECT
    CASE 
      WHEN u.age <15 THEN 'Kids'
      WHEN u.age BETWEEN 15 AND 24 THEN 'Teenager'
      WHEN u.age BETWEEN 25 AND 50 THEN 'Adult'
      WHEN u.age >50 THEN 'Eldery' END AS age_group,
        COUNT(DISTINCT oi.user_id) total_customer
    FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
    LEFT JOIN `bigquery-public-data.thelook_ecommerce.users` u
    ON oi.user_id = u.id
    WHERE oi.status NOT IN ('Cancelled','Returned')
    GROUP BY 1
    ORDER BY 2 DESC;
    ```
    Result : Least customers are from Teenager and Kids group.

4.  Best Brands
    ```
    SELECT 
    p.brand,
    SUM(oi.sale_price*o.num_of_item) AS revenue,
    SUM(o.num_of_item) AS quantity
    FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
      LEFT JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o ON oi.order_id = o.order_id
      LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
    WHERE oi.status NOT IN ('Cancelled','Returned')
    GROUP BY 1
    ORDER BY 3 DESC;
    ```
    Result : Top brands from total purchase is Allegra K, and top brands from total revenue is Calvin Clein.

5.  Best Products
    ```
    SELECT 
    p.category,
    SUM(oi.sale_price*o.num_of_item) AS revenue,
    SUM(o.num_of_item) AS quantity
    FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    LEFT JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON oi.order_id = o.order_id
    LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
    ON oi.product_id = p.id
    WHERE oi.status NOT IN ('Cancelled','Returned')
    GROUP BY 1
    ORDER BY 3 DESC;
    ```
    Result : Top products are Intimates and Jeans.

6. Products Returned and Canceled.
   ```
   SELECT 
    p.category,
    SUM(CASE WHEN oi.status = 'Cancelled' THEN 1 ELSE null END) AS Cancelled,
    SUM(CASE WHEN oi.status = 'Returned' THEN 1 ELSE null END) AS Returned
   FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
   LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` p
    ON oi.product_id = p.id
   GROUP BY 1
   ORDER BY 2 DESC;
   ```
   Result : Intimates is the most returned and canceled items.

7. Source Web Traffic
   ```
   SELECT
    u.traffic_source, 
    COUNT(DISTINCT oi.user_id) total_customer
   FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
    LEFT JOIN `bigquery-public-data.thelook_ecommerce.users` u
    ON oi.user_id = u.id
   WHERE oi.status NOT IN ('Cancelled','Returned')
   GROUP BY 1
   ORDER BY 2 DESC;
   ```
   Result : Mostly customers find by search engine.

### Recommendation :
- Make a good deal for regular customers to increase sales.
- Provide discount for new customers to engage more customers and retention.
- Provide products for age group teenager and kids.

Dashboard : https://lookerstudio.google.com/reporting/32dbf4c5-18c4-44a4-9d28-4f21a98004b3
