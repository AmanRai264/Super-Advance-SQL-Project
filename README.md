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



