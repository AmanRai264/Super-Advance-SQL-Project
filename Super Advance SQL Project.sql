-- Q.1) Find the top 5 most purchased products along with their total sales amount.

SELECT 
    p.product_name, 
    SUM(f.quantity) AS total_quantity_sold, 
    SUM(f.quantity * p.price) AS total_sales_amount
FROM fact_table f
JOIN product_table p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales_amount DESC
LIMIT 5;

--Q.2) Identify customers who have made transactions using more than one device type.

SELECT 
    f.customer_id, 
    c.customer_name,
    COUNT(DISTINCT d.device_type) AS device_count
FROM fact_table f
JOIN customer_table c ON f.customer_id = c.customer_id
JOIN device_table d ON f.device_id = d.device_id
GROUP BY f.customer_id, c.customer_name
HAVING COUNT(DISTINCT d.device_type) > 1
ORDER BY device_count DESC;

--Q.3) Determine the monthly revenue trend over the last 12 months and identify any seasonal patterns.

SELECT 
    DATE_TRUNC('month', d.date) AS month,
    SUM(f.quantity * p.price) AS total_revenue
FROM fact_table f
JOIN product_table p ON f.product_id = p.product_id
JOIN date_table d ON f.date_id = d.date_id

GROUP BY month
ORDER BY month;

-- Q.4) Find the top 5 customers who have spent the most money in the last 6 months.

SELECT 
    c.customer_name AS customer, 
    SUM(q.quantity * p.price) AS total_spent
FROM fact_table q
JOIN date_table d ON d.date_id = q.date_id
JOIN product_table p ON p.product_id = q.product_id
JOIN customer_table c ON c.customer_id = q.customer_id
WHERE d.date >= (
    SELECT MAX(date) FROM date_table
) - INTERVAL '6 months'
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;


-- Q.5) Identify products that were purchased by at least 3 different customers.

SELECT 
    p.product_name, 
    COUNT(DISTINCT f.customer_id) AS countcus
FROM fact_table f
JOIN product_table p ON p.product_id = f.product_id
JOIN customer_table c ON f.customer_id = c.customer_id
GROUP BY p.product_name
HAVING COUNT(DISTINCT f.customer_id) >= 3;

--Q.6) Determine the average order value (total revenue / total orders) for each month in the last year.

WITH last_year_orders AS (
    SELECT 
        d.year, d.month, 
        SUM(f.quantity * p.price) AS total_revenue,
        COUNT(DISTINCT f.session_id) AS total_orders
    FROM fact_table f
    JOIN product_table p ON f.product_id = p.product_id
    JOIN date_table d ON f.date_id = d.date_id
    WHERE d.year = EXTRACT(YEAR FROM CURRENT_DATE) - 1
    GROUP BY d.year, d.month
)
SELECT 
    year, 
    month, 
    total_revenue, 
    total_orders, 
    ROUND(total_revenue::NUMERIC / NULLIF(total_orders, 0), 2) AS avg_order_value
FROM last_year_orders
ORDER BY year DESC, month DESC;



--Find the Repeat Customers (Returning Customers) in the Last 6 Months


SELECT 
    f.customer_id, 
    COUNT(f.session_id) AS total_orders
FROM fact_table f
JOIN date_table d ON d.date_id = f.date_id
WHERE d.date >= (SELECT MAX(date) FROM date_table) - INTERVAL '6 months'
GROUP BY f.customer_id
HAVING COUNT(f.session_id) >= 2
ORDER BY total_orders DESC;



--Find Customers Who Have Purchased from More than One Category

select count(p.category) as cat, f.customer_id as cus
from  fact_table f
join product_table p
on f.product_id = p.product_id

group by cus
having count(p.category) > 2
order by cat desc

--Find the most commonly used device type for purchasing products in each product category. 
--Display the category, device type, and the total number of purchases made using that device.


with q as (select distinct p.category as cat, device_type, count(d.device_id) as counti
from  fact_table f
join product_table p
on f.product_id = p.product_id
join device_table d
on d.device_id = f.device_id
group by 1, 2
order by 3 desc)

select  distinct s.cat,d.device_type, max(s.counti) as totle_number, 
rank() over( partition by d.device_type  order by s.counti desc )
from q s
join device_table d
on d.device_type = s.device_type
group by 1, 2 


--right answer 
WITH q AS (
    SELECT 
        p.category AS cat, 
        d.device_type, 
        COUNT(*) AS counti
    FROM fact_table f
    JOIN product_table p ON f.product_id = p.product_id
    JOIN device_table d ON d.device_id = f.device_id
    GROUP BY p.category, d.device_type
)
SELECT 
    cat, 
    device_type, 
    counti AS total_number, 
    RANK() OVER (PARTITION BY cat ORDER BY counti DESC) AS rank_order
FROM q;
	 
--Find customers who made their first purchase in 2023 and then never made a purchase again.
--Return customer_id, customer_name, and first_purchase_date.

select  count(session_id), f.customer_id
from fact_table f
JOIN date_table d ON d.date_id = f.date_id
JOIN customer_table c ON c.customer_id = f.customer_id
group by  1
having  count(session_id) = 1


--Identify the top 3 most expensive products and find how many times each of them was purchased.
--Display product_name, category, price, and total_quantity_sold.
select count(f.product_id) as counti, p.price, p.product_name, p.category from fact_table f
JOIN product_table p ON f.product_id = p.product_id
group by 2, 3 ,4
order by price desc
limit 3 


--Identify the top 3 cities where customers have made the highest number of repeat purchases (more than one purchase). 
--Display city and repeat_purchase_count.

with cst as (select  f.customer_id, c.city, count(f.session_id) as count from fact_table f
join customer_table c
on c.customer_id =f.customer_id
group by 1, 2
having count(session_id) >=2
order by count)

select city, count(count) from cst
group by 1
order by count desc
limit 3

--this is right 
WITH cst AS (
    SELECT f.customer_id, c.city, COUNT(f.session_id) AS purchase_count
    FROM fact_table f
    JOIN customer_table c ON c.customer_id = f.customer_id
    GROUP BY f.customer_id, c.city
    HAVING COUNT(f.session_id) >= 2
)
SELECT city, SUM(purchase_count) AS repeat_purchase_count
FROM cst
GROUP BY city
ORDER BY repeat_purchase_count DESC
LIMIT 3;


--Find the best-selling product (highest quantity sold) for each month in 2023. 
--Display month_name, product_name, and total_quantity_sold
	      
with ser as (select 	p.product_name, sum(quantity) as total_quantity_sold, date_trunc('month',  d.date)  as months
from fact_table f
join date_table d
on d.date_id = f.date_id
join product_table p
on p.product_id = f.product_id
group by months, p.product_name
order by months desc) 

select  product_name,months, sum(total_quantity_sold)  total_quantity_sod from ser
group by 1,2
order by months, total_quantity_sod desc

WITH ser AS (
    SELECT 
        p.product_name, 
        SUM(f.quantity) AS total_quantity_sold, 
        DATE_TRUNC('month', date) AS months
    FROM fact_table f
    JOIN date_table d ON d.date_id = f.date_id
    JOIN product_table p ON p.product_id = f.product_id
    GROUP BY months, p.product_name
)
SELECT DISTINCT ON (months) 
    months, 
    product_name, 
    total_quantity_sold
FROM ser
ORDER BY months, total_quantity_sold DESC;


select * from date_table
