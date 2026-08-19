/* =========================================================
   Vendor Scorecard Analysis - SQL Queries
   Author: Abhishek N
   Description: SQL queries used to analyze vendor purchase 
   order data - calculating spend, order volume, and on-time 
   delivery performance per vendor.
   ========================================================= */


-- 1. Create the purchase_orders table
CREATE TABLE purchase_orders (
    po_id INT PRIMARY KEY,
    vendor_name VARCHAR(100),
    category VARCHAR(50),
    po_amount FLOAT,
    delivery_status VARCHAR(20),
    order_date DATE
);


-- 2. Create the vendor_details reference table
CREATE TABLE vendor_details (
    vendor_name VARCHAR(100) PRIMARY KEY,
    country VARCHAR(50),
    category VARCHAR(50)
);


-- 3. Basic filtering - vendors with delivery below 80% (example on raw data)
SELECT * FROM purchase_orders WHERE delivery_status = 'Late';


-- 4. Vendor Scorecard: total spend and order count per vendor
SELECT 
    vendor_name, 
    SUM(po_amount) AS total_spend, 
    COUNT(*) AS total_orders
FROM purchase_orders 
GROUP BY vendor_name;


-- 5. Filter vendors with total spend above a threshold
SELECT 
    vendor_name, 
    SUM(po_amount) AS total_spend
FROM purchase_orders 
GROUP BY vendor_name
HAVING SUM(po_amount) > 60000;


-- 6. On-time delivery percentage per vendor (core scorecard metric)
SELECT 
    vendor_name,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN delivery_status = 'On Time' THEN 1 ELSE 0 END) AS on_time_orders,
    ROUND(
        (SUM(CASE WHEN delivery_status = 'On Time' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 1
    ) AS on_time_pct
FROM purchase_orders
GROUP BY vendor_name;


-- 7. JOIN purchase_orders with vendor_details for full context
SELECT 
    p.vendor_name, 
    p.po_amount, 
    p.delivery_status, 
    v.country, 
    v.category
FROM purchase_orders p
JOIN vendor_details v ON p.vendor_name = v.vendor_name;


-- 8. Total spend per country (JOIN + GROUP BY)
SELECT 
    v.country, 
    SUM(p.po_amount) AS total_spend
FROM purchase_orders p
JOIN vendor_details v ON p.vendor_name = v.vendor_name
GROUP BY v.country;


-- 9. Subquery: orders priced above the overall average
SELECT vendor_name, po_amount
FROM purchase_orders
WHERE po_amount > (SELECT AVG(po_amount) FROM purchase_orders);


-- 10. Same result using a CTE (Common Table Expression)
WITH avg_po AS (
    SELECT AVG(po_amount) AS avg_amount FROM purchase_orders
)
SELECT vendor_name, po_amount
FROM purchase_orders, avg_po
WHERE po_amount > avg_amount;


-- 11. Window function: rank orders by amount across all vendors
SELECT 
    vendor_name, 
    po_amount,
    RANK() OVER (ORDER BY po_amount DESC) AS amount_rank
FROM purchase_orders;


-- 12. Window function with PARTITION: rank orders within each category
SELECT 
    vendor_name, 
    category, 
    po_amount,
    RANK() OVER (PARTITION BY category ORDER BY po_amount DESC) AS category_rank
FROM purchase_orders;
