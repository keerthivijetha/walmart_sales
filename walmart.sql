create database sales_db;
use sales_db;
select*
from walmart;
UPDATE walmart
SET unit_price = REPLACE(unit_price, '$', '')
;
SELECT COUNT(*) FROM WALMART;

ALTER TABLE walmart
DROP COLUMN total;

ALTER TABLE walmart
ADD COLUMN total DECIMAL(10,2) ;
UPDATE walmart
SET total = unit_price * quantity;



SELECT  payment_method,COUNT(*)
FROM walmart
GROUP BY payment_method
;

SELECT  branch,COUNT(*)
FROM walmart
GROUP BY branch
;

SELECT COUNT(DISTINCT branch)
FROM walmart
;

SELECT MAX(quantity)
FROM walmart
;

-- find different payment method and number of transactions,number of quantities sold
SELECT payment_method,COUNT(payment_method) as number_of_transactions , SUM(quantity) as quantities_sold
FROM walmart
GROUP BY payment_method
;

-- Which category received the highest average rating in each branch?
SELECT *
FROM (
	SELECT branch,category , ROUND(AVG(rating), 3) average_rating, 
	RANK()OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) as `rank`
	FROM walmart
	GROUP BY 1,2  -- HERE 1,2 ARE COLUMN NAMES
	ORDER BY 1,3 DESC
) avg_rating_table
WHERE `rank` = 1
;

-- What is the busiest day of the week for each branch based on transaction volume?
SELECT *
FROM (
	SELECT branch,
	DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_of_week,
	COUNT(*) AS transaction_count,
	RANK()OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS `rank`
	FROM walmart
	GROUP BY 1,2
	ORDER BY 1,3 DESC
) transaction_table
WHERE `rank` = 1
;

 -- How many items were sold through each payment method?
 SELECT payment_method,
 SUM(quantity) no_of_items_sold
 FROM walmart
 GROUP BY payment_method
 ;
 
 -- What are the average, minimum, and maximum ratings for each category in each city?
SELECT city,
category,
ROUND(AVG(rating),3) avg_rating,
MIN(rating) min_rating,
MAX(rating) max_rating
FROM walmart
GROUP BY 1,2
;

-- What is the total profit for each category, ranked from highest to lowest?
SELECT 
    category,
    ROUND(SUM(total * profit_margin),3) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC
;

-- What is the most frequently used payment method in each branch?
WITH freq_used_trans_cte AS
(
	SELECT branch,payment_method,COUNT(*) AS total_trans,
	RANK()OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS `rank`
	FROM walmart
	GROUP BY 1,2
    
)
SELECT *
FROM freq_used_trans_cte
WHERE `rank` = 1
ORDER BY 1,3 DESC
;

-- How many transactions occur in each shift (Morning, Afternoon, Evening)
UPDATE walmart
SET `time` = STR_TO_DATE(time, '%H:%i:%s');

SELECT branch,
	CASE
		WHEN HOUR(`time`) BETWEEN 6 AND 11 THEN 'Morning'
		WHEN HOUR(`time`) BETWEEN 12 AND 17 THEN 'Afternoon'
		WHEN HOUR(`time`) BETWEEN 18 AND 23 THEN 'Evening'
		ELSE 'Night'
	END as shift,
  COUNT(*) as total_transactions
FROM walmart
GROUP BY 1,2
ORDER BY 1,3 DESC
;


-- Which branches experienced the largest decrease in revenue compared to the previous year? current year 2023,current year 2022
WITH revenue_2022 AS
(
   SELECT branch,
	SUM(total) AS revenue
	FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
	GROUP BY 1
    ORDER BY 1
) ,
revenue_2023 AS
(
   SELECT branch,
	SUM(total) AS revenue
	FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
	GROUP BY 1
    ORDER BY 1
)
SELECT ls.branch,ls.revenue as last_year_revenue,cr.revenue as current_year_revenue,
ROUND(ABS(((cr.revenue - ls.revenue )/ls.revenue)*100),2) AS revenue_percentage 
FROM revenue_2023 as cr
JOIN revenue_2022 as ls
ON cr.branch = ls.branch
WHERE ls.revenue>cr.revenue
ORDER BY 4 DESC
LIMIT 5
;

-- Frequently used transaction method
WITH freq_used_trans_cte AS
(
	SELECT branch,payment_method,COUNT(*) AS total_trans,
	RANK()OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS `rank`
	FROM walmart
	GROUP BY 1,2
    
)
SELECT payment_method,COUNT(*)
FROM freq_used_trans_cte
GROUP BY 1
;




