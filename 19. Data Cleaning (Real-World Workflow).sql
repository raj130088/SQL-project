-- ============================================
-- FILE: Data Cleaning (Real-World Workflow)
-- ============================================

-- ============================================
-- DATA CLEANING STEPS (The Process)
-- ============================================
/*
1. Remove Duplicates - Identical rows that shouldn't exist
2. Standardize the Data - Fix formats, spelling, inconsistencies
3. Handle Null/Blank Values - Fill or remove missing data
4. Remove Unnecessary Columns - Drop columns that aren't useful
*/

-- ============================================
-- STEP 0: Examine the raw data
-- ============================================
SELECT *
FROM layoffs;

-- ============================================
-- STEP 1: Create a staging table (work on copy!)
-- ============================================
-- This creates an empty table with the same structure
CREATE TABLE layoffs_staging
LIKE layoffs;

-- Copy all data into staging table
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- ============================================
-- STEP 2: Remove Duplicates
-- ============================================

-- First, identify duplicates using ROW_NUMBER()
-- Every column in PARTITION BY = looking for completely identical rows
WITH duplicate_cte AS
(
    SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, total_laid_off, 
        percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;  -- row_num = 2,3,4... means duplicate

-- IMPORTANT: Can't DELETE from a CTE directly. Need a new table.

-- Create staging2 table with row_num column
CREATE TABLE `layoffs_staging2` (
    `company` text,
    `location` text,
    `industry` text,
    `total_laid_off` int DEFAULT NULL,
    `percentage_laid_off` text,
    `date` text,
    `stage` text,
    `country` text,
    `funds_raised_millions` int DEFAULT NULL,
    `row_num` int
);

-- Insert data with row numbers
INSERT INTO layoffs_staging2
SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, total_laid_off, 
        percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
FROM layoffs_staging;

-- Now DELETE the duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- Verify duplicates are gone
SELECT *
FROM layoffs_staging2;


-- ============================================
-- STEP 3: Standardize the Data
-- ============================================

-- 3a: Remove extra spaces from company names
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- 3b: Standardize industry names (Crypto has variations)
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;  -- ORDER BY 1 = sort by the first column in SELECT

-- Fix all crypto variations to just 'Crypto'
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- 3c: Check location (looks good, no issues)
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1; 

-- 3d: Fix country names (remove trailing periods)
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- 3e: Convert date string to proper DATE type
-- First view the conversion
SELECT `date`,
    STR_TO_DATE(`date`, '%m/%d/%Y') AS converted_date
FROM layoffs_staging2;

-- Apply the conversion
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Modify column type from TEXT to DATE
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- ============================================
-- STEP 4: Handle NULL and Blank Values
-- ============================================

-- Find rows with missing industry
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- Step 4a: Convert blank strings to NULL (easier to work with)
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Step 4b: Populate missing industry using same company data
-- Self-join to copy industry from another row of the same company
SELECT t1.industry, t2.industry
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
    ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Update the NULLs with populated values
UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
    ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Step 4c: Remove rows where both laid_off columns are NULL (useless data)
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- ============================================
-- STEP 5: Remove Unnecessary Columns
-- ============================================
-- Drop the row_num column (we only needed it for duplicate removal)
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- ============================================
-- FINAL: Clean data ready for analysis!
-- ============================================
SELECT *
FROM layoffs_staging2;
