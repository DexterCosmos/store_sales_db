<h1 align="center">Store Sales Database</h1>

## Summary

The Store Sales Database project is designed to efficiently manage and analyze sales and grwoth of the store. This comprehensive database aids in tracking sales performance, generating detailed reports, and facilitating data-driven business decisions. Key features include data import, data export, real-time analytics, and customizable reporting options. The dataset comprises 100,000 rows of consumer data, including fields such as customer id, customer name, last name, date of birth, year, outlet type, city type, category of goods, region, country, segment, sales date, order id, order date, ship date, ship mode, state, postal code, product id, sub-category, product name, quantity, discount, and profit. The tools utilized to complete this project include SQL for database management, Python for data processing and analysis, and Power BI for data visualization and reporting.

## Process

### Python

- **Importing Required Libraries**
    ```python
    import pandas as pd
    import numpy as np
    import pymysql
    from sqlalchemy import create_engine
    
    df = pd.read_csv('store_sales_data.csv')
    ```

- **Retrieving Database Information**
    ```python
    df.info()
    df.head()
    ```

- **Analyzing Missing and Null Values**
    ```python
    df.isnull().sum()
    ```

- **Standardizing Data**
    ```python
    df.columns = df.columns.str.lower()
    df.columns = df.columns.str.replace(' ', '_')
    df.columns = df.columns.str.replace('-', '_')     
    
    print(df.columns)
    
    df.info()
    ```

- **Analyzing Duplicate Values**
    ```python
    df.duplicated().sum()
    ```

- **Exporting the Data as CSV**
    ```python
    df.to_csv('store_sales_data_cleaned.csv', index=False)
    ```

- **Establishing connection with SQL**
    ```python
    engine_sql = create_engine('mysql+pymysql://root:Cosmos.90@localhost:3306/store_sales_db')

    try:engine_sql
        print ('connected')
    except:
        print ('not connected')
    ```

### SQL

- **Business Requirements**

Refer Business requirement.txt for requirement and for solutions (store_sales_db.sql)

```SQL
 - 1st query

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
```

## Tools Utlized

- Excel
- Python (Pandas, Numpy, pymysql, sqlalchemy)
- Jupyter Notebook
- SQL
- Power BI


---

<p align="center">
  <i>This project was solely made by // Nomaan Ansari // </i>
</p>