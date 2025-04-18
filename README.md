# Insurance Claim Report

A Business Intelligence (BI) project for analyzing and visualizing insurance claim data using SQL and open-source datasets. This repository is designed for those interested in data analysis, reporting, and presentation of actionable business insights.

---

## 📊 Project Overview

- **Goal:** Extract, analyze, and visualize key insights from insurance claim data for business reporting and decision-making.
- **Data Source:** [openml.org dataset 41214](https://www.openml.org/search?type=data&sort=runs&id=41214&status=active)
- **Technologies:** Microsoft SQL Server (T-SQL), BI tools (Power BI/Excel), open data.

---

## ✨ Key Features

- **Data Cleaning & Preparation:** Scripts for handling duplicates, missing values, and data standardization.
- **Summary & Analytics:** Pre-built queries for:
  - Total claims and total policies
  - Average exposure and Bonus/Malus
  - Claims breakdown by region, area, vehicle brand, fuel type, and driver age group
- **BI-ready Outputs:** The SQL results are ready for direct use in Power BI, Excel, or other visualization tools.
- **Custom Visual Theme:** Includes a custom wallpaper/theme for report visuals.
- **Exported Reports:** Sample exported PDF output is attached for portfolio/demo use.

---

## 📂 Repository Structure

- `schema.sql` — Database and table creation scripts
- `etl.sql` — Data cleaning and transformation scripts
- `analysis.sql` — Core analytical queries and summary statistics
- `views_procedures.sql` — Views and stored procedures for reusable insights
- `report_wallpaper.png` — Custom wallpaper/theme for the BI report
- `InsuranceClaimReport.pdf` — Exported sample report (PDF)
- `README.md` — Project documentation

---

## 🚀 Getting Started

### Prerequisites

- Microsoft SQL Server (or compatible T-SQL environment)
- Access to [openml dataset 41214](https://www.openml.org/search?type=data&sort=runs&id=41214&status=active)
- (Optional) Power BI or Excel for creating visuals

### Setup Steps

1. **Set Up the Database**
   - Run `schema.sql` in your SQL Server to create the necessary database and tables.

2. **Import Data**
   - Download the CSV from OpenML.
   - Import the data into the `InsuranceClaims` table using SQL Server Management Studio (SSMS) or a bulk import tool.

3. **Clean & Prepare Data**
   - Execute `etl.sql` to remove duplicates, handle NULLs, and standardize fields.

4. **Run Analyses**
   - Use the queries in `analysis.sql` for generating insights and summary statistics.

5. **Reusable Components**
   - Optional: Run `views_procedures.sql` to create views and stored procedures.

6. **Visualize**
   - Use your BI tool of choice to visualize the results.
   - Apply the included `report_wallpaper.png` for a professional look.
   - Reference the sample `InsuranceClaimReport.pdf` for expected output.

---

## 🔎 Example Queries

- **Total Claims per Region:**
  ```sql
  SELECT Region, SUM(ClaimNb) AS TotalClaims
  FROM InsuranceClaims
  GROUP BY Region
  ORDER BY TotalClaims DESC;
  ```
- **Average Claims by Vehicle Brand:**
  ```sql
  SELECT VehBrand, AVG(ClaimNb) AS AvgClaims
  FROM InsuranceClaims
  GROUP BY VehBrand
  ORDER BY AvgClaims DESC;
  ```

For more, see the `analysis.sql` file.

---

## 🖼️ Visuals & Output

- ![Report Visual Theme](report_wallpaper.png)
- [Download Sample PDF Report](./InsuranceClaimReport.pdf)

Typical output tables:
| Region    | TotalClaims |
|-----------|-------------|
| Picardie  | 1200        |
| Normandie | 900         |

*See the attached PDF for a full BI report example.*

---

## 🏆 Portfolio Value

- Demonstrates advanced SQL and analytics skills
- Shows BI report design and custom theming
- Uses open, real-world data for business scenarios
- Exportable, professional BI deliverables

---

## 📬 Contact

**Author:** [tushardhawale123](https://github.com/tushardhawale123)  
**Data Source:** [openml.org dataset 41214](https://www.openml.org/search?type=data&sort=runs&id=41214&status=active)

Feel free to reach out for collaboration or questions!

---

## 📄 License

This project is for educational and demonstration purposes. Please credit the author and OpenML if sharing or reusing components.
