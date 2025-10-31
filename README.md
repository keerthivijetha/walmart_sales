# Walmart Data Analysis
## Overview

This project is an end-to-end data analysis solution designed to extract meaningful business insights from **Walmart’s sales dataset**.
Using Python for data cleaning and analysis, and SQL for advanced querying, this project explores sales trends, customer behavior, and key business metrics that help understand store performance and profitability.

---
## Objectives
- Analyze sales data to uncover patterns and trends

- Perform data cleaning, transformation, and visualization

- Use SQL queries for deeper business insights

- Answer key business questions such as:

 1) Which branch performs the best overall?
  
 2) What is the busiest day and time for each branch?
  
 3) Which product lines generate the highest revenue?
  
 4) Which payment method is most popular?
---
## Skills Demonstrated
- Data Cleaning and Preprocessing using Python
- SQL Querying and Aggregations
- Exploratory Data Analysis
- Business Probelm Solving
---
## Tech Stack
- Language used : Python,SQL
- Libraries used: `pandas`, `numpy`, `sqlalchemy`, `mysql-connector-python`
- Database: MySQL
- Tools used: VS Code
- Data Source: Kaggle Datasets (Walmart Sales Dataset)
---
## Workflow
**1) Data Collection:** Imported Walmart sales dataset in .csv format

**2) Data Cleaning using Pandas:**
  - Removed duplicates and null values
  - Standardized data types
  - Converted date and time columns to proper formats
     
**3) Data Loading into MySQL :**
  - Created database
  - Loaded the cleaned data file into MySQL
  - Libraries used for loading are **mysql connector** and **sqlalchemy**
     
**4) SQL Analysis:**
  - Wrote SQL queries to answer some business questions
  - Used functions like `GROUP BY`,`RANK()`,`CASE` AND `JOINS`
  - Used Common Table Expressions and Sub queries
     
**5) Feature Engineering:**
  - Calculate the `Total Amount` for each transaction by multiplying `unit_price` with `quantity` and adding this as a new column.
  - Easy for further calculations.
  
  ---     
## Complex Queries and Business Problem Solving
  - Revenue trends across branches and categories.
```sql
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
```
   - Identifying best-selling product categories.
```sql
      SELECT payment_method,
             SUM(quantity) no_of_items_sold
      FROM walmart
      GROUP BY payment_method
      ;
```
   - Sales performance by time, city, and payment method.
  ```sql
     SELECT city,
            category,
            ROUND(AVG(rating),3) avg_rating,
            MIN(rating) min_rating,
            MAX(rating) max_rating
     FROM walmart
     GROUP BY 1,2
     ;
```
  - Analyzing peak sales periods and customer buying patterns.
```sql
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
```
  - Profit margin analysis by branch and category.
  ```sql
       SELECT 
             category,
             ROUND(SUM(total * profit_margin),3) AS total_profit
       FROM walmart
       GROUP BY category
       ORDER BY total_profit DESC
       ;
  ```
**5) Feature Engineering:**
  - Calculate the `Total Amount` for each transaction by multiplying `unit_price` with `quantity` and adding this as a new column.
  - Easy for further calculations.

---
## Project Structure

```plaintext
|-- data/                     # Raw data and transformed data
|-- sql_queries/              # SQL scripts for analysis and queries
|-- notebooks/                # Jupyter notebooks for Python analysis
|-- README.md                 # Project documentation
|-- main.py                   # Main script for loading, cleaning, and processing data
```
---

## Results and Insights

- **Branch 45** experienced the largest decrease in revenue compared to the previous year.
- Most of the transactions occur in **Afternoon** shift.
- **Ewallet** and **Credit card** were most commonly used payment_methods
- **Fashion Accessories** and **Home & Lifestyle** were top-performing product lines.

## Future Enhancements

Possible extensions to this project:
- Integration with a dashboard tool (e.g., Power BI or Tableau) for interactive visualization.
- Additional data sources to enhance analysis depth.
- Automation of the data pipeline for real-time data ingestion and analysis.

---

## Acknowledgments

- **Data Source**: Kaggle’s Walmart Sales Dataset
- **Inspiration**: Online resources and tutorials on data analytics using Python and SQL.

---
