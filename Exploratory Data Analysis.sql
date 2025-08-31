/* ============================================================
   AdventureWorks EDA & Business Reporting (SQL Server)
   Author : Jitendra Kumar Manasingh
   Purpose: Perform EDA and generate key business insights 
            from AdventureWorks using SQL Server.
   ============================================================ */

---------------------------------------------------------------
-- 🗄 DATABASE EXPLORATION
---------------------------------------------------------------

-- Q: What tables exist in the database?
SELECT * 
FROM INFORMATION_SCHEMA.TABLES;

-- Q: What columns are available in the 'dim_customers' table?
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';


---------------------------------------------------------------
-- 📐 DIMENSIONS EXPLORATION
---------------------------------------------------------------

-- Q: From which countries do our customers come?
SELECT DISTINCT country  
FROM gold.dim_customers;

-- Q: What categories, subcategories, and product names exist?
SELECT DISTINCT 
       category, 
       subcategory, 
       product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;


---------------------------------------------------------------
-- 📅 DATE EXPLORATION
---------------------------------------------------------------

-- Q: What is the first and last order date?
--    How many years, months, and days of data are available?
SELECT 
    MIN(order_date) AS FirstOrderDate,
    MAX(order_date) AS LastOrderDate,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date))   AS OrderRangeYears,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date))  AS OrderRangeMonths,
    DATEDIFF(DAY, MIN(order_date), MAX(order_date))    AS OrderRangeDays
FROM gold.fact_sales;

-- Q: Who is the youngest and oldest customer?
SELECT
    MIN(birthdate) AS OldestBirthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS Oldest_Age,
    MAX(birthdate) AS YoungestBirthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS Youngest_Age
FROM gold.dim_customers;


---------------------------------------------------------------
-- 📏 MEASURE EXPLORATION (Big Numbers / KPIs)
---------------------------------------------------------------

-- Q: What is the total sales amount?
SELECT SUM(sales_amount) AS Total_Sales 
FROM gold.fact_sales;

-- Q: How many items were sold in total?
SELECT SUM(quantity) AS Total_Items_Sold 
FROM gold.fact_sales;

-- Q: What is the average selling price?
SELECT AVG(price) AS Avg_Selling_Price 
FROM gold.fact_sales;

-- Q: How many unique orders were placed?
SELECT COUNT(DISTINCT order_number) AS Total_Orders 
FROM gold.fact_sales;

-- Q: How many unique products exist?
SELECT COUNT(DISTINCT product_id) AS Total_Products  
FROM gold.dim_products;

-- Q: How many customers are there?
SELECT COUNT(DISTINCT customer_id) AS Total_Customers 
FROM gold.dim_customers;

-- Q: How many customers have placed at least one order?
SELECT COUNT(DISTINCT customer_key) AS Customers_Placed_Orders 
FROM gold.fact_sales;


---------------------------------------------------------------
-- 📊 CONSOLIDATED BUSINESS REPORT
---------------------------------------------------------------

-- Q: Generate a single report of all key KPIs (big numbers)
SELECT 'Total Sales'             AS Measure_Name, SUM(sales_amount)         AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity Sold'     AS Measure_Name, SUM(quantity)             AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Average Selling Price'   AS Measure_Name, AVG(price)                AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders'            AS Measure_Name, COUNT(DISTINCT order_number) AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Total Products'          AS Measure_Name, COUNT(DISTINCT product_id)   AS Measure_Value FROM gold.dim_products
UNION ALL
SELECT 'Total Customers'         AS Measure_Name, COUNT(DISTINCT customer_id)  AS Measure_Value FROM gold.dim_customers
UNION ALL
SELECT 'Customers Placed Orders' AS Measure_Name, COUNT(DISTINCT customer_key) AS Measure_Value FROM gold.fact_sales;


---------------------------------------------------------------
-- 🔎 MAGNITUDE ANALYSIS
---------------------------------------------------------------

-- Q: How many customers are there by country?
SELECT
    country,
    COUNT(customer_key) AS Total_Customers
FROM gold.dim_customers
GROUP BY country
ORDER BY Total_Customers DESC;

-- Q: How many customers are there by gender?
SELECT
    gender,
    COUNT(customer_key) AS Total_Customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY Total_Customers DESC;

-- Q: How many products are there in each category?
SELECT
    category,
    COUNT(product_key) AS Total_Products
FROM gold.dim_products
GROUP BY category
ORDER BY Total_Products DESC;

-- Q: What is the average cost per category?
SELECT
    category,
    AVG(cost) AS Average_Cost
FROM gold.dim_products
GROUP BY category
ORDER BY Average_Cost DESC;

-- Q: What is the total revenue generated by each category?
SELECT
    prd.category,
    SUM(fs.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS prd
       ON fs.product_key = prd.product_key
GROUP BY prd.category
ORDER BY Total_Revenue DESC;

-- Q: What is the total revenue generated by each customer?
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(fs.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS c
       ON fs.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY Total_Revenue DESC;

-- Q: What is the distribution of sold items across countries?
SELECT
    c.country,
    SUM(fs.quantity) AS Total_Sold_Items
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS c
       ON fs.customer_key = c.customer_key
GROUP BY c.country
ORDER BY Total_Sold_Items DESC;


---------------------------------------------------------------
-- 🏆 RANKING (Top-N / Bottom-N Analysis)
---------------------------------------------------------------

-- Q: Which 5 products generated the highest revenue?
SELECT TOP 5
    prd.product_name,
    SUM(fs.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS prd
       ON fs.product_key = prd.product_key
GROUP BY prd.product_name
ORDER BY Total_Revenue DESC;

-- Q: Which 5 products performed worst in terms of revenue?
SELECT TOP 5
    prd.product_name,
    SUM(fs.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS prd
       ON fs.product_key = prd.product_key
GROUP BY prd.product_name
ORDER BY Total_Revenue ASC;

-- Q: Rank products by revenue using ROW_NUMBER() (Top 5)
SELECT *
FROM (
    SELECT
        prd.product_name,
        SUM(fs.sales_amount) AS Total_Revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(fs.sales_amount) DESC) AS Rank_Products
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_products AS prd
           ON fs.product_key = prd.product_key
    GROUP BY prd.product_name
) t
WHERE Rank_Products <= 5;

-- Q: Who are the top 10 customers by revenue?
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(fs.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS c
       ON fs.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY Total_Revenue DESC;

-- Q: Which 3 customers placed the fewest orders?
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS Total_Orders
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS c
       ON fs.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY Total_Orders ASC;
