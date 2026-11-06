-- =====================================================
-- Pizza Sales Analysis (SQL)
-- Tables: orders, order_details, pizzas, pizza_types
-- Written for MySQL 8+ (window functions need version 8)
--
-- IMPORT NOTE: in orders.csv, rename the columns
--   date -> order_date, time -> order_time
-- before importing, to avoid clashing with SQL keywords.
-- =====================================================

-- Table structure
CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    name          VARCHAR(100),
    category      VARCHAR(30),
    ingredients   TEXT
);

CREATE TABLE pizzas (
    pizza_id      VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50),
    size          VARCHAR(5),
    price         DECIMAL(6,2)
);

CREATE TABLE orders (
    order_id   INT PRIMARY KEY,
    order_date DATE,
    order_time TIME
);

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id         INT,
    pizza_id         VARCHAR(50),
    quantity         INT
);

-- =====================================================
-- BASIC
-- =====================================================

-- Q1. Total number of orders placed
SELECT COUNT(order_id) AS total_orders
FROM orders;

-- Q2. Total revenue generated from pizza sales
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id;

-- Q3. Highest-priced pizza
SELECT pt.name, p.size, p.price
FROM pizzas p
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Q4. Most common pizza size ordered
SELECT p.size,
       COUNT(od.order_details_id) AS order_lines,
       SUM(od.quantity)           AS pizzas_ordered
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY order_lines DESC;

-- Q5. Top 5 most ordered pizza types with quantities
SELECT pt.name, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p       ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;

-- =====================================================
-- INTERMEDIATE
-- =====================================================

-- Q6. Total quantity of each pizza category ordered
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p       ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- Q7. Distribution of orders by hour of the day
SELECT HOUR(order_time) AS order_hour,
       COUNT(order_id)  AS total_orders
FROM orders
GROUP BY HOUR(order_time)
ORDER BY order_hour;

-- Q8. Category-wise distribution of pizzas (number of pizza types per category)
SELECT category, COUNT(name) AS pizza_types
FROM pizza_types
GROUP BY category;

-- Q9. Average number of pizzas ordered per day
SELECT ROUND(AVG(daily_quantity), 0) AS avg_pizzas_per_day
FROM (
    SELECT o.order_date, SUM(od.quantity) AS daily_quantity
    FROM orders o
    JOIN order_details od ON od.order_id = o.order_id
    GROUP BY o.order_date
) AS daily_totals;

-- Q10. Top 3 pizza types by revenue
SELECT pt.name,
       ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details od
JOIN pizzas p       ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

-- =====================================================
-- ADVANCED
-- =====================================================

-- Q11. Percentage contribution of each pizza type to total revenue
SELECT pt.name,
       ROUND(SUM(od.quantity * p.price), 2) AS revenue,
       ROUND(SUM(od.quantity * p.price) * 100.0 /
             (SELECT SUM(od2.quantity * p2.price)
              FROM order_details od2
              JOIN pizzas p2 ON p2.pizza_id = od2.pizza_id), 2) AS pct_of_total_revenue
FROM order_details od
JOIN pizzas p       ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY pct_of_total_revenue DESC;

-- Q12. Cumulative revenue over time
SELECT order_date,
       ROUND(SUM(daily_revenue) OVER (ORDER BY order_date), 2) AS cumulative_revenue
FROM (
    SELECT o.order_date,
           SUM(od.quantity * p.price) AS daily_revenue
    FROM order_details od
    JOIN orders o ON o.order_id = od.order_id
    JOIN pizzas p ON p.pizza_id = od.pizza_id
    GROUP BY o.order_date
) AS daily_sales;

-- Q13. Top 3 pizza types by revenue within each pizza category
SELECT category, name, revenue, rank_in_category
FROM (
    SELECT pt.category,
           pt.name,
           ROUND(SUM(od.quantity * p.price), 2) AS revenue,
           RANK() OVER (PARTITION BY pt.category
                        ORDER BY SUM(od.quantity * p.price) DESC) AS rank_in_category
    FROM order_details od
    JOIN pizzas p       ON p.pizza_id = od.pizza_id
    JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
    GROUP BY pt.category, pt.name
) AS ranked
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;
