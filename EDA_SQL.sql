-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Checking to see which company had the most layoffs at once

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off >= 12000;

-- looking at the companies that went bankrupt

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Checking different catergories of layoffs 

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY SUM(total_laid_off) DESC;

-- Looking at the amount of layoffs that happened each month

SELECT SUBSTRING(`date`,1, 7) AS `month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY `month` ASC;

-- Seeing how each month of layoffs contributed to the total amount of layoffs that were made

WITH Rolling_Total AS (
SELECT SUBSTRING(`date`,1, 7) AS `month`, SUM(total_laid_off) AS laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY `month` ASC)
SELECT `month`, laid_off,SUM(laid_off) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_Total;

-- Seeing what companies had the most layoffs each year

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;

WITH Company_Year (company, years, total_laid_off) AS (
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)),
Company_Year_Rank AS(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM COMPANY_Year
WHERE years IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;




