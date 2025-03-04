<div align="center">
<img src="images/banner.png" alt="Store Sales Image" width="600" height="300">
<h1 align="center">Store Sales Database</h1>
</div>

## Summary

The Store Sales Database project is designed to efficiently manage and analyze sales and grwoth of the store. This comprehensive database aids in tracking sales performance, generating detailed reports, and facilitating data-driven business decisions. Key features include data import, data export, real-time analytics, and customizable reporting options. The dataset comprises 100,000 rows of consumer data, including fields such as `customer ID, customer name, last name, and date of birth`. It also encompasses sales `year, outlet type, city type, category of goods, region, and country`. Additional details comprise segment `sales date, order ID, order date, ship date, ship mode, state, postal code, product ID, subcategory, product name, quantity, discount, profit, sales month, and sales day`. The tools utilized to complete this project include SQL for database management, Python for data processing and analysis, and Power BI for data visualization and reporting.

## Workflow

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
- **Extracting and Adding sales_month from sales_date column**
    ```python
    file_path = 'store_sales_data_cleaned.csv'
    df = pd.read_csv(file_path)

    df['sales_date'] = pd.to_datetime(df['sales_date'])

    df['sales_month'] = df['sales_date'].dt.strftime('%b')

    df.to_csv(file_path, index=False)

    print("Updated CSV file with 'sales_month' column as three-letter abbreviation.")
    ```

- **Extracting and Adding sales_days from sales_date column**
    ```python
    file_path = 'store_sales_data_cleaned.csv'
    df = pd.read_csv(file_path)

    df['sales_date'] = pd.to_datetime(df['sales_date'])

    df['sales_month'] = df['sales_date'].dt.strftime('%b')

    df.to_csv(file_path, index=False)

    print("Updated CSV file with 'sales_month' column as three-letter abbreviation.")
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

    host = localhost // port = 3306 // user = root // password = 'your password'
    
    ```python
    engine_sql = create_engine('mysql+pymysql://root:Cosmos.90@localhost:3306/store_sales_db')

    try:engine_sql
        print ('connected')
    except:
        print ('not connected')
    ```

    ```python
    df.to_sql(name='store', con=engine_sql, if_exists='replace', index=False)
    ```

### SQL

- **Business Requirements**

Please refer to the document titled ``Business Requirement.txt`` for detailed business requirements. For the proposed solutions, kindly consult the ``store_sales_db.sql`` file.

```SQL
 • Example

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
- Python (pandas, numpy, pymysql, sqlalchemy)
- Jupyter Notebook
- SQL
- Power BI


---

<p align="center">
  <i>This project was solely exicuted by // Nomaan Ansari //</i>
</p>