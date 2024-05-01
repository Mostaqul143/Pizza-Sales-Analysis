-- Q1) Retrieve the total number of orders placed.


SELECT 
    COUNT(order_id) AS Total_Orders
FROM
    orders
    
    
-- Q2) Calculate the total revenue generated from pizza sales.

SELECT 
	ROUND(SUM(pizzas.price * orders_details.quantity),
            2) AS Total_Sales
FROM
    pizzas
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
    

-- Q3) Identify the highest-priced pizza.

SELECT 
    pizza_types.name, SUM(pizzas.price) AS Total
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.name
ORDER BY Total DESC
LIMIT 1;


-- Q4) Identify the most common pizza size ordered.

SELECT 
    pizzas.size, SUM(orders_details.quantity) AS Total
FROM
    pizzas
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY Total DESC


-- Q5) List the top 5 most ordered pizza types along with their quantities.


SELECT 
    pizza_types.name,
    SUM(orders_details.quantity) AS Total_Quantity
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizza_types.name
ORDER BY Total_Quantity DESC
LIMIT 5


-- Q6) Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pizza_types.category,
    SUM(orders_details.quantity) AS Total_Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY Total_Quantity DESC


-- Q7) Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS Hours, COUNT(order_id) AS Orders
FROM
    orders
GROUP BY Hours
ORDER BY orders DESC


-- Q8) Join relevant tables to find the category-wise distribution of pizzas.


SELECT 
    pizza_types.category,
    COUNT(orders_details.order_id) AS Orders
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY Orders DESC


-- Q9) Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(Quantity), 0) AS Avg_Pizza_Ordered_Per_Day
FROM
    (SELECT 
        orders.order_date, SUM(orders_details.quantity) AS Quantity
    FROM
        orders
    JOIN orders_details ON orders.order_id = orders_details.order_id
    GROUP BY orders.order_date) AS data
    
    
    
--   Q10) Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name,
    SUM(pizzas.price * orders_details.quantity) AS Revenue
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Revenue DESC
LIMIT 3



-- Q11) Calculate the percentage contribution of each pizza type to total revenue.


SELECT 
    pizza_types.category,
    ROUND(SUM(pizzas.price * orders_details.quantity),
            2) AS Revenue,
    ROUND(((ROUND(SUM(pizzas.price * orders_details.quantity),
                    2)) / (SELECT 
                    ROUND(SUM(pizzas.price * orders_details.quantity),
                                2) AS Total_Sales
                FROM
                    pizzas
                        JOIN
                    orders_details ON pizzas.pizza_id = orders_details.pizza_id) * 100),
            2) AS Percentage_Revenue
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizza_types.category
ORDER BY Percentage_Revenue DESC 


-- Q12) Analyze the cumulative revenue generated over time.

SELECT
    order_date,
    Revenue,
    ROUND(SUM(Revenue) OVER (ORDER BY order_date), 2) AS Cum_Revenue
FROM
    (SELECT
        orders.order_date,
        ROUND(SUM(pizzas.price * orders_details.quantity), 2) AS Revenue
    FROM
        pizzas
    JOIN
        orders_details ON pizzas.pizza_id = orders_details.pizza_id
    JOIN
        orders ON orders_details.order_id = orders.order_id
    GROUP BY
        orders.order_date) AS sales;
        
        
-- Q13) Determine the top 3 most ordered pizza types based on revenue for each pizza category.


SELECT name, Revenue
FROM (
    SELECT 
        category,name,Revenue,
        RANK() OVER (PARTITION BY category ORDER BY Revenue DESC) AS RN
    FROM (
        SELECT
            pizza_types.category,pizza_types.name,
            SUM(pizzas.price * orders_details.quantity) AS Revenue
        FROM
            pizzas
        JOIN
            orders_details ON pizzas.pizza_id = orders_details.pizza_id
        JOIN
            pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        GROUP BY
            pizza_types.name,pizza_types.category
    ) AS a
) AS b
WHERE RN <= 3;

