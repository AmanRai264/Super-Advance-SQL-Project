# README - SQL Queries for E-commerce Analysis

## Overview
This document contains a collection of SQL queries designed to analyze various aspects of an e-commerce business. These queries are written in PostgreSQL and provide insights into customer behavior, product sales, revenue trends, and device usage patterns.

## Queries and Their Purpose

1. **Top 5 Most Purchased Products**
   - Finds the top 5 most purchased products along with their total sales amount.
   - Uses `SUM(quantity * price)` to calculate total revenue.

2. **Customers Using Multiple Device Types**
   - Identifies customers who have made transactions using more than one device type.
   - Utilizes `COUNT(DISTINCT device_type)` and `HAVING COUNT(DISTINCT d.device_type) > 1`.

3. **Monthly Revenue Trend (Last 12 Months)**
   - Analyzes the revenue trend on a monthly basis.
   - Uses `DATE_TRUNC('month', date)` to group revenue data by month.

4. **Top 5 Highest-Spending Customers (Last 6 Months)**
   - Determines the top 5 customers who spent the most in the last 6 months.
   - Uses `SUM(quantity * price)` for total spending and filters dates using `INTERVAL '6 months'`.

5. **Products Purchased by At Least 3 Customers**
   - Identifies products that were purchased by at least 3 different customers.
   - Uses `COUNT(DISTINCT customer_id) >= 3` in `HAVING` clause.

6. **Average Order Value (AOV) for Each Month (Last Year)**
   - Computes AOV as `total revenue / total orders`.
   - Uses a `WITH` statement to aggregate revenue and order count.

7. **Repeat Customers in the Last 6 Months**
   - Finds customers who placed at least 2 orders in the last 6 months.
   - Uses `HAVING COUNT(session_id) >= 2`.

8. **Customers Who Purchased from More Than One Category**
   - Identifies customers who bought from more than two different product categories.
   - Uses `COUNT(DISTINCT category) > 2` in `HAVING` clause.

9. **Most Common Device Type Used Per Product Category**
   - Determines the most commonly used device type per product category.
   - Uses `RANK() OVER (PARTITION BY category ORDER BY COUNT(*) DESC)`.

10. **Customers with a Single Purchase in 2023**
    - Finds customers who made their first purchase in 2023 and never purchased again.
    - Uses `HAVING COUNT(session_id) = 1`.

11. **Top 3 Most Expensive Products and Their Purchase Count**
    - Identifies the top 3 most expensive products and how often they were purchased.
    - Orders by `price DESC` and limits results to 3.

12. **Best-Selling Product for Each Month in 2023**
    - Identifies the highest-selling product (by quantity) for each month.
    - Uses `DISTINCT ON (month)` to return one product per month ordered by quantity sold.

## Technologies Used
- **Database:** PostgreSQL
- **Concepts:** Aggregations, Joins, Subqueries, Common Table Expressions (CTEs), Window Functions, Filtering, Grouping

## How to Use These Queries
1. Ensure you have a properly structured database with `fact_table`, `product_table`, `customer_table`, `device_table`, and `date_table`.
2. Modify table and column names if needed to match your schema.
3. Run each query in a PostgreSQL-compatible environment.
4. Adjust `INTERVAL`, `LIMIT`, or filters as per your analysis needs.

## Conclusion
These queries provide valuable insights into an e-commerce platform’s performance, customer behavior, and sales trends. They can be extended further for more advanced analytics.

## Athour
Aman Rai

