# 📊 SQL Data Engineering: Tech Layoffs Cleaning & Analysis

---

## 📌 Project Overview

This repository contains a **two-phase SQL project** focused on the tech industry layoffs.

* **Data Cleaning** → Transforming a messy, raw dataset into a structured, analysis-ready format.
* **Exploratory Data Analysis (EDA)** → Querying the cleaned data to uncover trends, patterns, and insights regarding global layoffs.

---

## 🛠️ Tech Stack

| Category | Tools |
| --- | --- |
| **Database** | MySQL |
| **Interface** | MySQL Workbench |
| **Concepts** | ETL, Data Cleaning, EDA |

---

## 🧹 Phase 1: Data Cleaning (The Pipeline)

I implemented a **non-destructive workflow** by utilizing staging tables to ensure the original data remained untouched.

| Step | Action |
| --- | --- |
| 1️⃣ | **Duplicate Removal** – Used CTEs and `ROW_NUMBER()` to identify and prune identical records. |
| 2️⃣ | **Standardization** – Cleaned whitespace with `TRIM()`, unified industry names (e.g., "Crypto"), and fixed geographic inconsistencies. |
| 3️⃣ | **Type Conversion** – Converted date strings to proper `DATE` types using `STR_TO_DATE()` for time-series compatibility. |
| 4️⃣ | **Data Imputation** – Utilized self-joins to populate missing values based on matching company records. |

---

## 📊 Phase 2: Exploratory Data Analysis (The Insights)

With the data cleaned, I performed several queries to answer critical business questions:

| Focus Area | Description |
| --- | --- |
| 📈 **Scale of Impact** | Identified companies and industries with the highest total layoffs and percentage-based reductions. |
| 📅 **Temporal Trends** | Analyzed layoffs by year and month to identify peaks in the tech industry downturn. |
| 💰 **Financial Correlation** | Explored the relationship between `funds_raised_millions` and the scale of layoffs. |
| 🔁 **Rolling Aggregates** | Used window functions to calculate rolling totals of layoffs by month to visualize progression over time. |
| 🏆 **Company Progression** | Ranked companies by layoffs per year using `DENSE_RANK()` within CTEs. |

---

## 📈 Key SQL Techniques Used

* **Advanced Joins** – Self-joins for data recovery.
* **Window Functions** – `ROW_NUMBER()`, `SUM() OVER()`, `DENSE_RANK()`.
* **Aggregations** – `GROUP BY`, `HAVING`, `MAX()`, `SUM()`.
* **Date Functions** – `YEAR()`, `MONTH()`, `STR_TO_DATE()`.

---

## 📂 File Structure

```bash
├── 19. Data Cleaning (Real-World Workflow).sql   # Cleaning pipeline
├── 20. Exploratory Data Analysis (EDA).sql       # Exploratory queries & insights
└── layoffs.csv                                   # Raw dataset

```

---

## 💡 How to Use

1. **Import the raw dataset:** Load `layoffs.csv` into your MySQL Workbench environment.
2. **Run the cleaning script:** Execute `19. Data Cleaning (Real-World Workflow).sql` to generate the refined `layoffs_staging2` table.
3. **Run the analysis script:** Execute `20. Exploratory Data Analysis (EDA).sql` to explore the findings.
