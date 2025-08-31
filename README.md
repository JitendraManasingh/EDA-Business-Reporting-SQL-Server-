# 📊 AdventureWorks EDA & Business Reporting (SQL Server)

This project contains **Exploratory Data Analysis (EDA)** and **business reporting queries** on the popular **AdventureWorks** sample database using SQL Server.  
The goal is to explore database structure, dimensions, measures, and generate insights into sales, customers, and products.

---

## 🔹 Project Author
**Jitendra Kumar Manasingh**  

---

## 📂 Project Structure

The SQL script is divided into the following sections:

### 1. 🗄 Database Exploration
- Explore all objects and schemas in the database.  
- Retrieve metadata about tables and columns.  

### 2. 📐 Dimensions Exploration
- Understand customers by **country**.  
- Explore product **categories, subcategories, and product names**.  

### 3. 📅 Date Exploration
- Identify the **earliest and latest order dates**.  
- Calculate the **sales range** (years, months, days).  
- Find the **youngest and oldest customers**.  

### 4. 📏 Measure Exploration (Big Numbers)
- Total sales amount.  
- Total items sold.  
- Average selling price.  
- Total number of orders, products, and customers.  
- Number of customers who placed orders.  

### 5. 📊 Consolidated Business Report
- Single query combining all key KPIs (big numbers).  
- Output includes: Total Sales, Total Quantity Sold, Average Price, Orders, Products, Customers.  

### 6. 🔎 Magnitude Analysis
- Customers by country & gender.  
- Products by category.  
- Average cost per category.  
- Revenue by category.  
- Revenue per customer.  
- Sold items distribution by country.  

### 7. 🏆 Ranking & Top-N Analysis
- Top 5 products by revenue.  
- Bottom 5 products (worst performers).  
- Top 10 customers by revenue.  
- Customers with fewest orders.  
- Ranking products using **SQL Window Functions (ROW_NUMBER)**.  

---

## 🚀 How to Use
1. Restore or connect to the **AdventureWorks** database in SQL Server.  
2. Run the provided SQL script (`adventureworks_eda.sql`).  
3. Each section can be run independently to answer specific business questions.  

---

## 📈 Example Business Questions Answered
- What are the top 5 products by revenue?  
- Which categories generate the most revenue?  
- Who are the top 10 customers driving sales?  
- How many total customers, orders, and products exist?  
- What’s the average selling price across all sales?  
- Which customers placed the fewest orders?  

---

## 🛠 Technologies Used
- **SQL Server (T-SQL)**  
- **AdventureWorks Database (OLTP)**  

---

## 📌 Future Enhancements
- Visualize results using **Power BI** or **Tableau** dashboards.  
- Add stored procedures for reusable reports.  
- Create ETL workflows to load data into a **data warehouse model**.  

---

## 📜 License
This project is open-source and available for learning and practice.
