/*
==================================================================================================================================================================
                                                   PROJECT: OLIST E-COMMERCE DATA ANALYSIS
==================================================================================================================================================================
-- Objective:
-- Analyze sales performance, delivery efficiency, and customer behavior.

-- Key Focus Areas:
-- 1. Revenue trends
-- 2. Delivery performance
-- 3. Customer insights
-- 4. Seller performance
-- ============================================
*/
CREATE DATABASE Olist;
USE Olist;
-- -------------------------------------------------------- TABLE CREATION ---------------------------------------------------------------------------------
CREATE TABLE orders(
	order_id                      VARCHAR(50),
    customer_id                   VARCHAR(50),
    order_status                  VARCHAR(20),
    order_purchase_timestamp      DATETIME,
    order_approved_at             DATETIME,
    order_delivered_carrier_date  DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
); 

CREATE TABLE customers (
    customer_id              VARCHAR(50),
    customer_unique_id       VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city            VARCHAR(50),
    customer_state           VARCHAR(10)
);

CREATE TABLE order_items (
    order_id             VARCHAR(50),
    order_item_id        INT,
    product_id           VARCHAR(50),
    seller_id            VARCHAR(50),
    shipping_limit_date  DATETIME,
    price                DECIMAL(10,2),
    freight_value        DECIMAL(10,2)
); 

CREATE TABLE payments (
    order_id              VARCHAR(50),
    payment_sequential    INT,
    payment_type          VARCHAR(20),
    payment_installments  INT,
    payment_value         DECIMAL(10,2)
);

CREATE TABLE reviews (
    review_id              VARCHAR(50),
    order_id               VARCHAR(50),
    review_score           INT,
    review_comment_title   VARCHAR(100),
    review_comment_message TEXT,
    review_creation_date   DATETIME,
    review_answer_timestamp DATETIME
); 

CREATE TABLE products (
    product_id                   VARCHAR(50),
    product_category_name        VARCHAR(100),
    product_name_lenght          FLOAT,
    product_description_lenght   FLOAT,
    product_photos_qty           FLOAT,
    product_weight_g             FLOAT,
    product_length_cm            FLOAT,
    product_height_cm            FLOAT,
    product_width_cm             FLOAT
); 

CREATE TABLE sellers (
    seller_id              VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city            VARCHAR(50),
    seller_state           VARCHAR(10)
);

CREATE TABLE category_translation (
    product_category_name         VARCHAR(100),
    product_category_name_english VARCHAR(100)
);


-- ======= DATA load for category_translation and customer was done through Table Data Import Wizard ===================================


SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1; 

-- ----------------------------- SELLER TABLE DATA LOAD -------------------------------------- 

LOAD DATA LOCAL INFILE 'D:/DATA ANALYSIS PREP/PROJECT-2/OLIST Datasets/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(seller_id, seller_zip_code_prefix, seller_city, seller_state);

-- ---------------------------- PRODUCTS TABLE DATA LOAD ------------------------------------------

LOAD DATA LOCAL INFILE 'D:/DATA ANALYSIS PREP/PROJECT-2/OLIST Datasets/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_category_name, product_name_lenght, 
 product_description_lenght, product_photos_qty, 
 product_weight_g, product_length_cm, 
 product_height_cm, product_width_cm);

-- ----------------------------- PAYMENTS TABLE DATA LOAD -----------------------------------------

LOAD DATA LOCAL INFILE 'D:/DATA ANALYSIS PREP/PROJECT-2/OLIST Datasets/olist_order_payments_dataset.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, payment_sequential, payment_type, 
 payment_installments, payment_value);

-- ----------------------------- ORDER_ITEMS TABLE DATA LOAD ----------------------------------------

LOAD DATA LOCAL INFILE 'D:/DATA ANALYSIS PREP/PROJECT-2/OLIST Datasets/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_item_id, product_id, seller_id,
 @sl, price, freight_value)
SET shipping_limit_date = STR_TO_DATE(@sl, '%d-%m-%Y %H:%i');

-- --------------------------- REVIEWS TABLE DATA LOAD ---------------------------------------------

LOAD DATA LOCAL INFILE 'D:/DATA ANALYSIS PREP/PROJECT-2/OLIST Datasets/olist_order_reviews_dataset.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id, order_id, review_score, review_comment_title,
 review_comment_message, @rc, @ra)
SET review_creation_date    = STR_TO_DATE(@rc, '%d-%m-%Y %H:%i'),
    review_answer_timestamp = STR_TO_DATE(@ra, '%d-%m-%Y %H:%i');

-- ------------------------- ORDERS TABLE DATA LOAD --------------------------------------------------

LOAD DATA LOCAL INFILE 'D:/DATA ANALYSIS PREP/PROJECT-2/OLIST Datasets/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status,
 @op, @oa, @odc, @odd, @oed)
SET
order_purchase_timestamp      = STR_TO_DATE(NULLIF(@op,''),  '%d-%m-%Y %H:%i'),
order_approved_at             = STR_TO_DATE(NULLIF(@oa,''),  '%d-%m-%Y %H:%i'),
order_delivered_carrier_date  = STR_TO_DATE(NULLIF(@odc,''), '%d-%m-%Y %H:%i'),
order_delivered_customer_date = STR_TO_DATE(NULLIF(@odd,''), '%d-%m-%Y %H:%i'),
order_estimated_delivery_date = STR_TO_DATE(NULLIF(@oed,''), '%d-%m-%Y %H:%i');


-- --------------------------------------- SANITY CHECK --------------------------------------------------

SELECT 'orders' AS table_name , COUNT(*) AS row_count FROM orders
UNION ALL 
SELECT 'category_translation' , COUNT(*) AS row_count FROM category_translation
UNION ALL 
SELECT 'customers' ,            COUNT(*) AS row_count FROM customers
UNION ALL 
SELECT 'order_items' ,          COUNT(*) AS row_count FROM order_items
UNION ALL 
SELECT 'payments' ,             COUNT(*) AS row_count FROM payments
UNION ALL 
SELECT 'products' ,              COUNT(*) AS row_count FROM products
UNION ALL 
SELECT 'reviews' ,              COUNT(*) AS row_count FROM reviews
UNION ALL 
SELECT 'sellers' ,              COUNT(*) AS row_count FROM sellers;
-- --------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------- ANALYSIS -------------------------------------------------------------------------

-- ------------------------------------------ TOTAL REVENUE per MONTH ------------------------------------------------------

SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS Months,
SUM(payment_value) AS Total_Revenue
FROM orders AS OD 
JOIN payments AS PY
ON OD.order_id = PY.order_id
WHERE order_status = 'delivered'
GROUP BY Months
ORDER BY Months; 

/*
===== Insight:
 Revenue increased significantly from late 2016 to mid-2018, crossing R$1M per month, indicating strong platform growth.
 A sharp spike in November 2017 aligns with Black Friday, highlighting the impact of seasonal demand.
 The decline in August 2018 is due to incomplete data rather than an actual drop in performance.

===== Business Impact:
 Seasonal events like Black Friday should be strategically leveraged with inventory planning and marketing campaigns.
*/

-- ------------------------------ TOP-10 CATEGORIES BY REVENUE ---------------------------------------------------------------------

SELECT CT.product_category_name_english AS Category_Name,
SUM(payment_value) AS Total_Revenue
FROM orders AS OD
JOIN order_items AS OT
	ON OD.order_id = OT.order_id
JOIN products as PD
	ON OT.product_id = PD.product_id
JOIN payments as PY
	ON OT.order_id = PY.order_id
JOIN category_translation AS CT
	ON PD.product_category_name = CT.product_category_name
WHERE order_status = 'delivered'
GROUP BY Category_Name
ORDER BY Total_Revenue DESC
LIMIT 10;

/*
===== Insight:
 Bed, Bath & Table is the top-performing category in both revenue and order volume, followed by Health & Beauty.
 Computers & Accessories generates higher revenue relative to its order volume, indicating high average order value (AOV).
 Sports & Leisure has high order volume but lower revenue contribution, indicating low-value, high-frequency purchases.

===== Business Impact:
 High AOV categories should focus on upselling strategies, while high-volume categories should focus on retention and repeat purchases.
*/

-- -------------------------------- SETTING TIMEOUT and CREATING INDEX FOR FASTER DATA READ ---------------------
SET SESSION wait_timeout = 300;
SET SESSION interactive_timeout = 300;
SET SESSION net_read_timeout = 300;

ALTER TABLE order_items ADD INDEX idx_order_id(order_id);
ALTER TABLE order_items ADD INDEX idx_product_id(product_id);
ALTER TABLE payments ADD INDEX idx_order_id(order_id);
ALTER TABLE products ADD INDEX idx_product_id(product_id);
ALTER TABLE products ADD INDEX idx_category(product_category_name);
ALTER TABLE category_translation ADD INDEX idx_category(product_category_name);
-- -------------------------------------------------------------------------------------------------------------------

-- ------------------------------- LATE DELIVERY PERCENTAGE ----------------------------------------

SELECT 
ROUND(SUM(
	CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
    ELSE 0
    END) *100 / COUNT(*) , 2) AS late_del_pct
FROM orders
WHERE order_status = 'delivered';

/*
===== Insight:
 Approximately 8% of orders are delivered late, with an average delay of over 10 days beyond the estimated delivery date.
 Late deliveries have a strong negative impact on customer satisfaction, with significantly lower review scores compared to on-time deliveries.

===== Business Impact:
 Improving delivery accuracy or setting more realistic delivery expectations can significantly enhance customer satisfaction and reduce negative reviews.
*/

-- ---------------------------------- AVERAGE REVIEW SCORE BY DELIVERY STATUS ----------------------------

SELECT
	CASE 
		WHEN DATE(order_delivered_customer_date) < DATE(order_estimated_delivery_date) THEN 'Early'
        WHEN DATE(order_delivered_customer_date) = DATE(order_estimated_delivery_date) THEN 'On-Time'
        ELSE 'Late'	
	END AS Delivery_Status,
    ROUND(AVG(review_score),2) AS Avg_Score
FROM orders AS OD
JOIN reviews AS RV
	ON OD.order_id = RV.order_id
WHERE order_status = 'delivered'
GROUP BY Delivery_Status;

/*

*/

-- --------------------------------- TOP-10 STATES BY REVENUE -------------------------------------------------

SELECT customer_state,
	ROUND(SUM(payment_value),2) AS Total_Revenue
FROM orders AS OD
JOIN payments AS PY 
	ON OD.order_id = PY.order_id
JOIN customers AS CS
	ON OD.customer_id = CS.customer_id
WHERE order_status = 'delivered'
GROUP BY customer_state
ORDER BY Total_Revenue DESC
LIMIT 10;

/*
===== Insight:
 São Paulo dominates in both customer base and revenue contribution, followed by Rio de Janeiro and Minas Gerais.
 Northern states experience significantly longer delivery times, often more than double the national average.

===== Business Impact:
 Logistics improvements in underperforming regions can unlock new growth opportunities and improve delivery performance.
*/

-- ------------------------------- RANKING SELLERS BY REVENUE -------------------------------------

SELECT 
	seller_id,
    ROUND(SUM(payment_value),2) AS Total_Revenue,
    RANK() OVER (ORDER BY SUM(payment_value) DESC) AS Revenue_Rank
FROM orders AS OD
JOIN order_items AS OT
	ON OD.order_id = OT.order_id
JOIN payments AS PY
	ON OD.order_id = PY.order_id
WHERE order_status = 'delivered'
GROUP BY seller_id
LIMIT 10;

-- -------------------------------------- MONTH-OVER-MONTH REVENUE GROWTH (CTE) -------------------------------------------

WITH monthly_revenue AS(
	SELECT
		DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS Months,
        ROUND(SUM(payment_value),2) AS Revenue
	FROM orders AS OD
    JOIN payments AS PY
		ON OD.order_id = PY.order_id
	WHERE order_status = 'delivered'
    GROUP BY Months
)

SELECT 
	Months,
	Revenue,
	LAG(Revenue) OVER (ORDER BY Months) AS Prev_Month_Revenue,
	ROUND((Revenue - LAG(Revenue) OVER (ORDER BY Months)) * 100 / LAG(Revenue) OVER (ORDER BY Months),2) AS Growth_PCT
FROM monthly_revenue
ORDER BY Months;

/*
===== Insight:
- Revenue shows high volatility in early months due to low base values, resulting in extreme growth percentages.
- From mid-2017 onwards, growth stabilizes, indicating business maturity and more predictable revenue patterns.
- November 2017 shows a significant spike (~53% growth), driven by seasonal demand (Black Friday).
- Post-November, a correction is observed in December, followed by moderate and stable growth in 2018.

===== Why this approach:
- A CTE was used to first aggregate monthly revenue for clarity.
- LAG() enables comparison with the previous month without complex self-joins.

===== Business Impact:
- Helps identify growth trends, seasonal spikes, and periods of slowdown.
- Useful for forecasting, budgeting, and planning marketing campaigns around high-growth months.
*/
-- --------------------- ABOVE AVERAGE SPENDING BY CUSTOMERS (Sub-Query) -------------------------------------------

SELECT 
	customer_id,
    ROUND(SUM(payment_value),2) AS Total_Spent
FROM orders AS OD
JOIN payments AS PY
	ON OD.order_id = PY.order_id
WHERE order_status = 'delivered'
GROUP BY customer_id

HAVING Total_Spent > (
	SELECT AVG(Customer_Total)
    FROM (
		SELECT SUM(payment_value) AS Customer_Total
		FROM orders AS OD2
		JOIN payments AS PY2
			ON OD2.order_id = PY2.order_id
		WHERE order_status = 'delivered'
		GROUP BY customer_id
    ) AS Customer_Totals
)
ORDER BY Total_Spent DESC
LIMIT 10;

/*
===== Insight:
- A small group of customers contributes disproportionately high revenue, indicating the presence of high-value customers.
- The top customers spend significantly more than the average, highlighting a skewed spending distribution.

===== Why this approach:
- A subquery was used to dynamically calculate the average customer spending.
- HAVING clause filters only those customers whose total spend exceeds the average.

===== Business Impact:
- Identifying high-value customers enables targeted retention strategies such as loyalty programs, exclusive offers, and personalized marketing.
*/

-- ------------------------------- RUNNING TOTAL OF MONTHLY REVENUE --------------------------------

WITH monthly AS(
	SELECT
		DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS Months,
        ROUND(SUM(payment_value),2) AS Revenue
	FROM orders AS OD
    JOIN payments AS PY
		ON OD.order_id = PY.order_id
	WHERE order_status = 'delivered'
    GROUP BY Months
)

SELECT 
	Months,
    Revenue,
    ROUND(SUM(Revenue) OVER (ORDER BY Months),2) AS Running_Total
FROM monthly
GROUP BY Months;

/*
===== Insight:
- The running total shows a consistent upward trend, confirming sustained business growth over time.
- Growth accelerates significantly during high-revenue periods such as late 2017, after which it continues to rise steadily.

===== Why this approach:
- Window function SUM() OVER() was used to calculate cumulative revenue without losing monthly granularity.

===== Business Impact:
- Provides a clear view of long-term revenue accumulation and overall business trajectory.
- Useful for stakeholders to track progress against revenue targets.
*/


/*
=================================================================================================================================================================
                                                                   RECOMMENDATION
=================================================================================================================================================================

== 1. Leverage seasonal demand:
	  - Prepare in advance for high-demand periods like November (Black Friday) through inventory and logistics planning.

== 2. Improve delivery performance:
	  - Reduce late deliveries by optimizing logistics and setting more realistic delivery expectations.

== 3. Focus on High-Value Customers:
	  - A small segment of customers contributes a large portion of revenue.
	  - Implement loyalty programs, personalized offers, and retention strategies to maximize lifetime

== 4. Plan for Revenue Volatility
	  - Month-over-month growth shows volatility, especially in early stages and during seasonal events.
	  - Use historical growth trends to improve forecasting and stabilize revenue through consistent mark

== 5. Track Long-Term Growth
	  - Running total confirms steady long-term growth.
	  - Set cumulative revenue targets and monitor performance against long-term business goals.

*/