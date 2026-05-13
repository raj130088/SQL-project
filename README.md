SQL Data Engineering: Tech Layoffs Cleaning & Analysis

📌 Project Overview
This repository contains a two-phase SQL project focused on the tech industry layoffs.

Data Cleaning: Transforming a messy, raw dataset into a structured, analysis-ready format.

Exploratory Data Analysis (EDA): Querying the cleaned data to uncover trends, patterns, and insights regarding global layoffs.

🛠️ Tech Stack
Database: MySQL

Interface: MySQL Workbench

Concepts: ETL, Data Cleaning, Exploratory Data Analysis

🧹 Phase 1: Data Cleaning (The Pipeline)
I implemented a non-destructive workflow by utilizing staging tables to ensure the original data remained untouched.

Duplicate Removal: Used CTEs and ROW_NUMBER() to identify and prune identical records.

Standardization: Cleaned whitespace with TRIM(), unified industry names (e.g., "Crypto"), and fixed geographic inconsistencies.

Type Conversion: Converted date strings to proper DATE types using STR_TO_DATE() for time-series compatibility.

Data Imputation: Utilized Self-Joins to populate missing values based on matching company records.

📊 Phase 2: Exploratory Data Analysis (The Insights)
With the data cleaned, I performed several queries to answer critical business questions:

Scale of Impact: Identified the companies and industries with the highest total layoffs and percentage-based reductions.

Temporal Trends: Analyzed layoffs by year and month to identify peaks in the tech industry downturn.

Financial Correlation: Explored the relationship between funds_raised_millions and the scale of layoffs.

Rolling Aggregates: Used Window Functions to calculate rolling totals of layoffs by month to visualize the progression of the trend over time.

Company Progression: Ranked companies by layoffs per year using DENSE_RANK() within CTEs.

📈 Key SQL Techniques Used
Advanced Joins: Self-joins for data recovery.

Window Functions: ROW_NUMBER(), SUM() OVER(), and DENSE_RANK().

Aggregations: GROUP BY, HAVING, MAX(), SUM().

Date Functions: YEAR(), MONTH(), STR_TO_DATE().

📂 File Structure
19. Data Cleaning (Real-World Workflow).sql: Script for the cleaning pipeline.

20. Exploratory Data Analysis (EDA).sql: Script for the exploratory queries and insights.

layoffs.csv: The raw dataset.

💡 How to Use
Import layoffs.csv into MySQL Workbench.

Execute 19. Data Cleaning (Real-World Workflow).sql to generate the layoffs_staging2 table.

Run 20. Exploratory Data Analysis (EDA).sql to explore the findings.
