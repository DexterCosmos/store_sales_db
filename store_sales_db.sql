-- Active: 1740258463137@@127.0.0.1@3306@store_sales_db
SELECT * FROM store;


-- 1. find total sale by year (2023) and category of goods, rank category_of_goods by low to high performance

WITH category_sales AS (
    SELECT year, category_of_goods, ROUND(SUM(sales)) AS total_sales
    FROM store
    GROUP BY year, category_of_goods
)
SELECT category_of_goods, total_sales,
       RANK() OVER (ORDER BY total_sales ASC) AS ranking
FROM category_sales
WHERE year = (SELECT MAX(year) FROM store)
ORDER BY ranking;


-- 2. Align states by highest revenue

SELECT state, ROUND(SUM(profit)) AS total_profit
FROM store
GROUP BY state
ORDER BY total_profit DESC;


-- 3. Find and compare most sold products by year (2022) & (2023)

SELECT year, sub_category, ROUND(SUM(quantity)) AS total_quantity
FROM store
WHERE year IN (2022, 2023)
GROUP BY year, sub_category
ORDER BY sub_category, year, total_quantity DESC;


-- 4. Compare total revenue by year (2019 and 2023) by subtracting the discount state wise

WITH revenue_cte AS (
    SELECT year, state, ROUND(SUM(profit - discount)) AS net_revenue
    FROM store
    WHERE year IN (2019, 2023)
    GROUP BY year, state
)
SELECT year, state, net_revenue, 
       DENSE_RANK() OVER (PARTITION BY state ORDER BY year) AS ranking
FROM revenue_cte
ORDER BY state, year, net_revenue DESC;


-- 5. Find total order count by state and segment

SELECT state,segment,
    COUNT(order_id) AS order_count
FROM store
GROUP BY state, segment
ORDER BY state,COUNT(order_id) DESC;


-- 6. What is the percentage contribution of each product's sales to its category?

WITH category_sales AS (
    SELECT
        category_of_goods,
        SUM(sales) AS total_category_sales
    FROM
        store
    GROUP BY
        category_of_goods
)
SELECT
    p.category_of_goods,
    p.product_name,
    ROUND(SUM(p.sales)) AS product_sales,
    (SUM(p.sales) / cs.total_category_sales) * 100 AS sales_contribution_percentage
FROM
    store p
    JOIN category_sales cs ON p.category_of_goods = cs.category_of_goods
GROUP BY
    p.category_of_goods, p.product_name, cs.total_category_sales
ORDER BY
    p.category_of_goods, sales_contribution_percentage DESC;


-- 7. What is the profit margin for each shipping mode?

SELECT
    ship_mode,
    ROUND(SUM(sales)) AS total_sales,
    ROUND(SUM(profit)) AS total_profit,
    (SUM(profit) / SUM(sales)) * 100 AS profit_margin_percentage
FROM
    store
GROUP BY
    ship_mode
ORDER BY
    profit_margin_percentage DESC;

-- 8. Analyze the impact of discounts on sales and profit by sub-category.

SELECT
    sub_category,
    AVG(discount) AS average_discount,
    ROUND(SUM(sales)) AS total_sales,
    ROUND(SUM(profit)) AS total_profit
FROM
    store
GROUP BY
    sub_category
HAVING AVG(discount) > 0
ORDER BY
    average_discount DESC;

-- 9. What is the monthly trend of sales and profit for each state?

SELECT
    state,
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    ROUND(SUM(sales)) AS total_sales,
    ROUND(SUM(profit)) AS total_profit
FROM
    store
GROUP BY
    state, EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY
    state, year, month;


-- 10. Identify the top 10 most profitable customers and their total number of orders.

SELECT
    customer_id,
    customer_name,
    last_name,
    COUNT(order_id) AS total_orders,
    SUM(profit) AS total_profit
FROM
    store
GROUP BY
    customer_id, customer_name, last_name
ORDER BY
    total_profit DESC
LIMIT 10;


-- 11. What is the year-over-year sales growth for each region?

SELECT
    region,
    year,
    ROUND(SUM(sales)) AS total_sales,
    LAG(SUM(sales)) OVER (PARTITION BY region ORDER BY year) AS previous_year_sales,
    ((SUM(sales) - LAG (SUM(sales)) OVER (PARTITION BY region ORDER BY year)) / LAG(SUM(sales)) OVER (PARTITION BY region ORDER BY year)) * 100 AS sales_growth_percentage
FROM
    store
GROUP BY
    region, year
ORDER BY
    region, year;


-- 12. How many repeat customers do we have, and how much do they contribute to total sales?

SELECT
    city_type,
    outlet_type,
    ROUND(SUM(sales)) AS total_sales
FROM
    store
GROUP BY
    city_type,
    outlet_type
ORDER BY
    city_type,
    outlet_type;
