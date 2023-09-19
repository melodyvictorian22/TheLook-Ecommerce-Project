-- Monthly Sales
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

-- customer by country
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

-- customer by gender
SELECT 
  o.gender,
  SUM(oi.sale_price*o.num_of_item) revenue,
  SUM(o.num_of_item) quantity
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
LEFT JOIN `bigquery-public-data.thelook_ecommerce.orders` o
ON oi.order_id = o.order_id
WHERE oi.status NOT IN ('Cancelled','Returned')
GROUP BY 1
ORDER BY 2;

--customer by age group
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

-- bset brands
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

-- Products Sales

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

-- Brands Cancel & Return

SELECT 
  p.brand,
  SUM(CASE WHEN oi.status = 'Cancelled' THEN 1 ELSE null END) AS Cancelled,
  SUM(CASE WHEN oi.status = 'Returned' THEN 1 ELSE null END) AS Returned
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` p
ON oi.product_id = p.id
GROUP BY 1
ORDER BY 2 DESC;


-- Products Cancel & Return

SELECT 
p.category,
SUM(CASE WHEN oi.status = 'Cancelled' THEN 1 ELSE null END) AS Cancelled,
SUM(CASE WHEN oi.status = 'Returned' THEN 1 ELSE null END) AS Returned
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` p
ON oi.product_id = p.id
GROUP BY 1
ORDER BY 2 DESC;

-- Source web traffic

SELECT
  u.traffic_source, 
  COUNT(DISTINCT oi.user_id) total_customer
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
LEFT JOIN `bigquery-public-data.thelook_ecommerce.users` u
ON oi.user_id = u.id
WHERE oi.status NOT IN ('Cancelled','Returned')
GROUP BY 1
ORDER BY 2 DESC;