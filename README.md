# Insurance Claim Report

This project provides a comprehensive SQL-based analysis and reporting solution for insurance claim data. It is designed to deliver key business insights and visualizations for portfolio or BI presentations.

## Project Overview

- **Goal:** Analyze insurance claims data to extract actionable insights, summary statistics, and present them visually for business intelligence (BI) purposes.
- **Data Source:** [openml.org dataset 41214](https://www.openml.org/search?type=data&sort=runs&id=41214&status=active)
- **Technologies:** Microsoft SQL Server (T-SQL), SQL scripts

## Key Features

- Summary statistics and data cleaning for insurance claims
- Visualizations and report queries for:
  - Total claims
  - Total policies
  - Average exposure
  - Average Bonus/Malus scores
  - Claims by region
  - Claims per policy by area
  - Claims by fuel type
  - Claims by vehicle brand
  - Claims by driver age group
- Example stored procedures and views for flexible querying
- Indexing for performance optimization

## Repository Structure

- `SQLQuery1.sql` — Main SQL script for database setup, data cleaning, and analytics queries

## Setup & Usage

### Prerequisites

- Microsoft SQL Server (or compatible T-SQL environment)
- Access to the openml dataset ([download link](https://www.openml.org/search?type=data&sort=runs&id=41214&status=active))

### Steps

1. **Create the Database & Table**

   Run the initial setup statements in `SQLQuery1.sql` to create `InsuranceClaimsDB` and the `InsuranceClaims` table.

2. **Import Data**

   Import the dataset (CSV) into the `InsuranceClaims` table using SQL Server Management Studio (SSMS) or a bulk import utility.

3. **Run Cleaning and Analysis Scripts**

   Execute the rest of the script to:
   - Clean and standardize the data
   - Remove duplicates and handle missing values
   - Generate summary statistics and key aggregation queries

4. **Generating Visuals**

   Use the output of the summary queries to create visuals in your BI tool of choice (Power BI, Tableau, Excel, etc.). Sample output tables can be directly visualized or exported.

### Example Queries

- Total claims per region:
  ```sql
  SELECT Region, SUM(ClaimNb) AS TotalClaims
  FROM InsuranceClaims
  GROUP BY Region
  ORDER BY TotalClaims DESC;
  ```
- Average claims by vehicle brand:
  ```sql
  SELECT VehBrand, AVG(ClaimNb) AS AvgClaims
  FROM InsuranceClaims
  GROUP BY VehBrand
  ORDER BY AvgClaims DESC;
  ```
- Claims by driver age group, area, and fuel type are similarly available via included queries.

### Stored Procedures

- Use `sp_BrandClaimsByRegion` to get brand-wise claims for a specific region:
  ```sql
  EXEC sp_BrandClaimsByRegion 'Picardie';
  ```

## Expected Output & Sample Results

You can expect output tables such as:

- **Total Claims by Region**
  | Region    | TotalClaims |
  |-----------|-------------|
  | Picardie  | 1200        |
  | Normandie | 900         |
  | ...       | ...         |

- **Claims by Vehicle Brand**
  | VehBrand  | AvgClaims   |
  |-----------|-------------|
  | Renault   | 2.1         |
  | Peugeot   | 1.8         |
  | ...       | ...         |

- **Distribution of Fuel Types**
  | VehGas    | NumPolicies |
  |-----------|-------------|
  | Gasoline  | 3500        |
  | Diesel    | 1500        |

Use these tables to create visuals for your BI presentation.

## Portfolio Value

This project demonstrates:
- Advanced SQL for data analysis and transformation
- BI reporting skills
- Data cleaning and preparation
- Real-world business questions addressed using open data

---

**Author:** [tushardhawale123](https://github.com/tushardhawale123)  
**Data Source:** [openml.org dataset 41214](https://www.openml.org/search?type=data&sort=runs&id=41214&status=active)

Feel free to contact me for more information or collaboration opportunities!
