-- Data Cleaning --

SELECT*
FROM layoffs;


-- 1. Remove duplicates --
-- 2. Standardize the Data --
-- 3. Null values or blank values --
-- 4. Remove any columns --

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

SET SQL_SAFE_UPDATES = 0; -- FOR DELETING-- 

DELETE
FROM layoffs_staging2
WHERE row_num =2; 

SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM layoffs_staging2
WHERE row_num >1; 













