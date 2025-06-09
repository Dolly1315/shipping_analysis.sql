-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS ecommerce_data;
USE ecommerce_data;

-- Step 2: Create the table
CREATE TABLE IF NOT EXISTS shipping_data (
    ID INT,
    Warehouse_block VARCHAR(10),
    Mode_of_Shipment VARCHAR(20),
    Customer_care_calls INT,
    Customer_rating FLOAT,
    Cost_of_the_Product INT,
    Prior_purchases INT,
    Product_importance VARCHAR(20),
    Gender VARCHAR(10),
    Discount_offered INT,
    Weight_in_gms INT,
    Reached_on_Time_Y_N INT
);

-- Step 3: Load CSV data (ensure the file is in correct path for LOAD DATA)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Ecommerce Shipping Data.csv'
INTO TABLE shipping_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Step 4: Analysis Queries

-- 1. Total shipments by warehouse
SELECT Warehouse_block, COUNT(*) AS total_shipments
FROM shipping_data
GROUP BY Warehouse_block;

-- 2. Total late deliveries
SELECT COUNT(*) AS late_shipments
FROM shipping_data
WHERE Reached_on_Time_Y_N = 0;

-- 3. Count by Gender
SELECT Gender, COUNT(*) AS total_customers
FROM shipping_data
GROUP BY Gender;

-- 4. Average customer rating by mode of shipment
SELECT Mode_of_Shipment, AVG(Customer_rating) AS avg_rating
FROM shipping_data
GROUP BY Mode_of_Shipment;

-- 5. Product importance distribution
SELECT Product_importance, COUNT(*) AS importance_count
FROM shipping_data
GROUP BY Product_importance;

-- 6. Subquery: higher than average customer rating
SELECT * FROM shipping_data
WHERE Customer_rating > (
    SELECT AVG(Customer_rating) FROM shipping_data
);

-- 7. Create a dashboard-friendly view
CREATE VIEW shipment_summary AS
SELECT 
    Warehouse_block,
    Mode_of_Shipment,
    Product_importance,
    AVG(Cost_of_the_Product) AS avg_cost,
    AVG(Customer_rating) AS avg_rating,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN Reached_on_Time_Y_N = 0 THEN 1 ELSE 0 END) AS late_deliveries
FROM shipping_data
GROUP BY Warehouse_block, Mode_of_Shipment, Product_importance;