-- Data Cleaning --

SELECT*
FROM layoffs;

-- Things to do --
-- 1. Remove duplicates --
-- 2. Standardize the Data --
-- 3. Null values or blank values --
-- 4. Remove any columns --


-- 1. Remove duplicates --
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging; 

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry,total_laid_off, percentage_laid_off,`date`) AS row_num
FROM layoffs_staging; 

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry,total_laid_off, percentage_laid_off,`date`,stage, country,funds_raised_millions) AS row_num
FROM layoffs_staging 
)
SELECT *
FROM duplicate_cte
WHERE row_num >1;


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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2; 

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry,total_laid_off, percentage_laid_off,`date`,stage, country,funds_raised_millions) AS row_num
FROM layoffs_staging;

SET SQL_SAFE_UPDATES = 0; -- FOR DELETING and updating-- 

DELETE
FROM layoffs_staging2
WHERE row_num =2; 

-- SET SQL_SAFE_UPDATES = 1; --

SELECT *
FROM layoffs_staging2
WHERE row_num >1; 

SELECT *
FROM layoffs_staging2;


-- 2. Standardize the Data --
UPDATE layoffs_staging2
SET company = TRIM(company); -- for removing space --

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';









