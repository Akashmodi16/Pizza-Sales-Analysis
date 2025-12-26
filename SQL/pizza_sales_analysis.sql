CREATE DATABASE Pizza;
use Pizza;

CREATE TABLE pizza_sales (
    order_details_id INT NOT NULL,
    order_id         INT NOT NULL,
    pizza_id         VARCHAR(50) NOT NULL,
    quantity         INT NOT NULL,
    order_date       DATE NOT NULL,
    order_time       TIME NOT NULL,
    unit_price       DECIMAL(10,2) NOT NULL,
    total_price      DECIMAL(10,2) NOT NULL,
    pizza_size       VARCHAR(5) NOT NULL,
    pizza_category   VARCHAR(20) NOT NULL,
    pizza_ingredients TEXT NOT NULL,
    pizza_name       VARCHAR(100) NOT NULL,
    PRIMARY KEY (order_details_id)
);

SELECT *
FROM pizza_sales;

-- Total Revenue 
SELECT 
ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales;

-- Total Orders
SELECT 
COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales;

-- Total pizza sold
SELECT 
SUM(quantity) AS total_pizzas_sold
FROM pizza_sales;

-- Average order values
SELECT 
ROUND(
SUM(total_price) / COUNT(DISTINCT order_id), 2
) AS avg_order_value
FROM pizza_sales;

-- Average pizzas per order
SELECT 
ROUND(
SUM(quantity) * 1.0 / COUNT(DISTINCT order_id), 2
) AS avg_pizzas_per_order
FROM pizza_sales;

-- Time based insights
-- Orders by hours 
SELECT 
    DATE_FORMAT(order_time, '%Y-%m-%d %H:00:00') AS order_time_slot,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY order_time_slot
ORDER BY order_time_slot DESC;

-- Orders by day of week
SELECT 
    DAYNAME(order_date) AS day_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DAYNAME(order_date)
ORDER BY total_orders DESC;

-- Monthly Revenue Trend
SELECT 
    MONTHNAME(order_date) AS month_name,
    MONTH(order_date) AS month_no,
    ROUND(SUM(total_price), 2) AS revenue
FROM pizza_sales
GROUP BY 
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY month_no;

-- 


-- PRODUCT PERFORMANCE ANALYSIS 

-- Top five pizza by revenue 
SELECT
    pizza_name,
    ROUND(SUM(total_price), 2) AS revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue DESC
LIMIT 5;

-- Top five pizzas by total orders
SELECT
    pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC
LIMIT 5;

-- Top five pizzas by quantity sold
SELECT
    pizza_name,
    SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity DESC
LIMIT 5;

-- Bottom Performers

-- Bottom 5 Pizzas by Revenue
SELECT
    pizza_name,
    ROUND(SUM(total_price), 2) AS revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue ASC
LIMIT 5;

-- Bottom 5 by Orders
SELECT
    pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders ASC
LIMIT 5;

-- Bottom 5 by Quantity Sold
SELECT
    pizza_name,
    SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity ASC
LIMIT 5;

-- CATEGORY & SIZE DEEP DIVE

-- Revenue by Category
SELECT
    pizza_category,
    ROUND(SUM(total_price), 2) AS revenue
FROM pizza_sales
GROUP BY pizza_category
ORDER BY revenue DESC;

-- Orders by Category
SELECT
    pizza_category,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_orders DESC;

-- Revenue by Pizza Size
SELECT
    pizza_size,
    ROUND(SUM(total_price), 2) AS revenue
FROM pizza_sales
GROUP BY pizza_size
ORDER BY revenue DESC;

-- Busiest Day × Hour (Peak Load Matrix)
SELECT 
    DAYNAME(order_date) AS day_name,
    HOUR(order_time) AS order_hour,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY 
    DAYNAME(order_date),
    HOUR(order_time)
ORDER BY total_orders DESC;

-- Average Revenue per Pizza
SELECT
    pizza_name,
    ROUND(SUM(total_price) / SUM(quantity), 2) AS avg_price_per_pizza
FROM pizza_sales
GROUP BY pizza_name
ORDER BY avg_price_per_pizza DESC;

-- Category Contribution % (Executive View)
SELECT
    pizza_category,
    ROUND(SUM(total_price), 2) AS revenue,
    ROUND(
        SUM(total_price) * 100.0 / 
        (SELECT SUM(total_price) FROM pizza_sales),
        2
    ) AS revenue_percentage
FROM pizza_sales
GROUP BY pizza_category
ORDER BY revenue DESC;

-- Seating Utilization (Assumption-Based Insight)
SELECT
    order_date,
    COUNT(DISTINCT order_id) * 2 AS estimated_guests,
    60 AS total_seats,
    ROUND((COUNT(DISTINCT order_id) * 2 / 60) * 100, 2) AS seat_utilization_pct
FROM pizza_sales
GROUP BY order_date
ORDER BY order_date;

























