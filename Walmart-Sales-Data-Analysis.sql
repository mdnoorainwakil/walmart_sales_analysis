SELECT * 
FROM walmart
LIMIT 10;

SELECT unit_price, quantity
FROM walmart
LIMIT 10;

SELECT 
    SUM(
        CAST(REPLACE(unit_price, '$', '') AS DECIMAL(10,2)) * quantity
    ) AS total_revenue
FROM walmart;

UPDATE walmart
SET unit_price = REPLACE(unit_price, '$', '');

SET SQL_SAFE_UPDATES = 0;


#1. Total Revenue
SELECT SUM(unit_price * quantity) AS total_revenue
FROM walmart;

#2. Total Transactions
SELECT COUNT(*) AS total_transactions
FROM walmart;

#3. Unique Cities
SELECT COUNT(DISTINCT City) AS unique_cities
FROM walmart;

#4. Top 10 High-Value Transactions
SELECT *
FROM walmart
ORDER BY total_sales DESC
LIMIT 10;

#5. Category-wise Revenue
SELECT category,
       SUM(unit_price * quantity) AS total_revenue
FROM walmart
GROUP BY category
ORDER BY total_revenue DESC;

# 6. City-wise Revenue
SELECT City,
       SUM(total_sales) AS total_revenue
FROM walmart
GROUP BY City
ORDER BY total_revenue DESC;

#7. Average Transaction Value
SELECT AVG(unit_price * quantity) AS average_transaction_value
FROM walmart;

#8. Category-wise Average Rating
SELECT category,
       AVG(rating) AS average_rating
FROM walmart
GROUP BY category
ORDER BY average_rating DESC;

#9. Branch-wise Revenue
SELECT Branch,
       SUM(unit_price * quantity) AS total_revenue
FROM walmart
GROUP BY Branch
ORDER BY total_revenue DESC;

#10. Categories with Revenue Greater Than 20,000
SELECT category,
       SUM(total_sales) AS total_revenue
FROM walmart
GROUP BY category
HAVING SUM(total_sales) > 20000
ORDER BY total_revenue DESC;

#11. City-wise Transaction Count
SELECT City,
       COUNT(*) AS total_transactions
FROM walmart
GROUP BY City
ORDER BY total_transactions DESC;

#12. Transactions Above Average Sales
SELECT *
FROM walmart
WHERE total_sales > (
    SELECT AVG(total_sales)
    FROM walmart
);

#13. Best Performing Category
SELECT category,
       SUM(total_sales) AS total_revenue
FROM walmart
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 1;

#14. Highest Revenue City
SELECT City,
       SUM(total_sales) AS total_revenue
FROM walmart
GROUP BY City
ORDER BY total_revenue DESC
LIMIT 1;

#15. Rank Categories by Revenue
SELECT category,
       SUM(total_sales) AS total_revenue,
       RANK() OVER (
           ORDER BY SUM(total_sales) DESC
       ) AS revenue_rank
FROM walmart
GROUP BY category;

#16. Rank Branches by Revenue
SELECT Branch,
       SUM(total_sales) AS total_revenue,
       DENSE_RANK() OVER (
           ORDER BY SUM(total_sales) DESC
       ) AS branch_rank
FROM walmart
GROUP BY Branch;

#17. Running Total of Sales
SELECT invoice_id,
       date,
       total_sales,
       SUM(total_sales) OVER (
           ORDER BY date
       ) AS running_total
FROM walmart;

#18. Daily Sales Analysis
SELECT date,
       SUM(total_sales) AS daily_revenue
FROM walmart
GROUP BY date
ORDER BY date;

#19. Monthly Sales Analysis
SELECT MONTH(date) AS month,
       SUM(total_sales) AS total_revenue
FROM walmart
GROUP BY MONTH(date)
ORDER BY month;

#20. Best Sales Day
SELECT date,
       SUM(total_sales) AS total_revenue
FROM walmart
GROUP BY date
ORDER BY total_revenue DESC
LIMIT 1;

#21. CTE – Best Performing Category
WITH category_sales AS (
    SELECT category,
           SUM(total_sales) AS total_revenue
    FROM walmart
    GROUP BY category
)
SELECT *
FROM category_sales
ORDER BY total_revenue DESC
LIMIT 1;

#22. CTE – Cities Above Average Revenue
WITH city_sales AS (
    SELECT City,
           SUM(total_sales) AS total_revenue
    FROM walmart
    GROUP BY City
)
SELECT *
FROM city_sales
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM city_sales
)
ORDER BY total_revenue DESC;


ALTER TABLE walmart
ADD COLUMN profit DECIMAL(12,2);

UPDATE walmart
SET profit = total_sales * profit_margin;

#23. Create a Sales Summary View
CREATE VIEW sales_summary AS
SELECT category,
       SUM(total_sales) AS total_revenue,
       SUM(profit) AS total_profit
FROM walmart
GROUP BY category;

SELECT *
FROM sales_summary;