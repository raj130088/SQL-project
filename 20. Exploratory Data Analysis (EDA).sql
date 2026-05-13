-- ============================================
-- FILE: Exploratory Data Analysis (EDA)
-- ============================================

-- ============================================
-- WHAT IS EDA?
-- ============================================
/*
Exploratory Data Analysis = Understanding your data before formal analysis
Goals:
- Find patterns and anomalies
- Identify outliers
- Discover relationships
- Generate hypotheses
*/

-- ============================================
-- STEP 1: Examine the cleaned data
-- ============================================
SELECT *
FROM layoffs_staging2;


-- ============================================
-- STEP 2: Find Extremes (Max/Min values)
-- ============================================

-- Biggest single layoff event and highest % laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Companies that laid off 100% of staff (percentage_laid_off = 1)
-- Sort by who lost the most people
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Companies ordered by funding raised (deep pockets)
SELECT *
FROM layoffs_staging2
ORDER BY funds_raised_millions DESC;


-- ============================================
-- STEP 3: Aggregated Analysis (GROUP BY)
-- ============================================

-- Which companies raised the most money? (total across all layoff events)
SELECT company, SUM(funds_raised_millions) AS total_funds
FROM layoffs_staging2
GROUP BY company
ORDER BY total_funds DESC;

-- Which companies had the most layoffs overall?
SELECT company, SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid DESC;

-- Date range of the dataset
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Which industries were hit hardest?
SELECT industry, SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid DESC;

-- Which countries had the most layoffs?
SELECT country, SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid DESC;

-- Layoffs by date (which days had the most?)
SELECT `date`, SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY `date`
ORDER BY `date`;

-- Layoffs by year (trend over time)
SELECT YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY year DESC;

-- Layoffs by company stage (Startup? Public? Private?)
SELECT stage, SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid DESC;


-- ============================================
-- STEP 4: Rolling Total (Time Series Analysis)
-- ============================================

-- First, get monthly totals
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY `month` ASC;

-- Add a rolling total (running sum) using window function
WITH Rolling_Total AS
(
    SELECT 
        SUBSTRING(`date`, 1, 7) AS `month`, 
        SUM(total_laid_off) AS total_laid
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `month`
    ORDER BY `month` ASC
)
SELECT 
    `month`, 
    total_laid,
    SUM(total_laid) OVER(ORDER BY `month`) AS rolling_laid_off
FROM Rolling_Total;
-- This shows cumulative layoffs over time


-- ============================================
-- STEP 5: Company Layoffs by Year
-- ============================================

-- Which companies laid off the most each year?
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;

-- Same but sorted by highest layoffs first
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY total_laid DESC;


-- ============================================
-- STEP 6: Ranking Companies by Year (Top 5 per year)
-- ============================================

-- CTE to get yearly totals per company
WITH Company_Year (company, years, total_laid_off) AS
(
    SELECT 
        company, 
        YEAR(`date`), 
        SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
)
SELECT *
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- Add rankings within each year using DENSE_RANK
WITH Company_Year (company, years, total_laid_off) AS
(
    SELECT 
        company, 
        YEAR(`date`), 
        SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
),
company_rankings AS
(
    SELECT *, 
        DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS company_rank
    FROM Company_Year
    WHERE years IS NOT NULL
        AND total_laid_off IS NOT NULL
)
SELECT * 
FROM company_rankings
WHERE company_rank <= 5;  -- Top 5 companies per year
