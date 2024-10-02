-- Exploratory Data Analysis

select * 
from layoff_staging2
;

select country,sum(total_laid_off) as total_off
from layoff_staging2
group by country
having total_off is not null
order by 2 desc
;

select company,sum(total_laid_off) as total_off
from layoff_staging2
group by company
having total_off is not null
order by 2 desc
;

select year(`date`) as Years,sum(total_laid_off) as total_off
from layoff_staging2
group by year(`date`)
having Years is not null
order by 1
;

select substring(`date`,1,7) as dates, sum(total_laid_off) as total_off
from layoff_staging2
group by dates
having dates is not null
order by 1
;

with dates_total_off as
(
select substring(`date`,1,7) as dates, sum(total_laid_off) as total_off
from layoff_staging2
group by dates
having dates is not null
order by 1
)
select dates,total_off, sum(total_off) over(order by dates) as running_total
from dates_total_off
;



select company,year(`date`) as Years,sum(total_laid_off) as total_off
from layoff_staging2
group by company,years
having Years is not null
order by 3 desc
;

WITH max_laid_off_with_years AS (
    SELECT 
        company, 
        YEAR(`date`) AS Years, 
        SUM(total_laid_off) AS total_off 
    FROM 
        layoff_staging2 
    GROUP BY 
        company, Years 
    HAVING 
        Years IS NOT NULL
)
SELECT 
    Years, 
    company, 
    total_off AS max_layoffs 
FROM 
    max_laid_off_with_years a
WHERE 
    total_off = (
        SELECT MAX(total_off) 
        FROM max_laid_off_with_years b
        where a.years = b.years
    )
order by 1;


select * 
from layoff_staging2;


WITH max_laid_off_with_years AS (
    SELECT 
        industry, 
        YEAR(`date`) AS Years, 
        SUM(total_laid_off) AS total_off 
    FROM 
        layoff_staging2 
    GROUP BY 
        industry, Years 
    HAVING 
        Years IS NOT NULL
)
SELECT 
    Years, 
    industry, 
    total_off AS max_layoffs 
FROM 
    max_laid_off_with_years a
WHERE 
    total_off = (
        SELECT MAX(total_off) 
        FROM max_laid_off_with_years b
        where a.years = b.years
    )
order by 1;


select industry,year(`date`) as Years,sum(total_laid_off) as total_off
from layoff_staging2
group by industry,years
having (Years is not null) and total_off is not null 
order by 2 desc
;


With max_laid_off_with_months as
(
select industry,substring(`date`,1,7) as dates, sum(total_laid_off) as total_off
from layoff_staging2
group by dates,industry
having dates is not null
order by 1
)
select industry,
dates,
total_off
from max_laid_off_with_months a
where total_off = (select max(total_off)
			from max_laid_off_with_months b
            where a.dates = b.dates)
order by 2;





With max_laid_off_with_months as
(
select company,substring(`date`,1,7) as dates, sum(total_laid_off) as total_off
from layoff_staging2
group by dates,company
having dates is not null
order by 1
)
select company,
dates,
total_off
from max_laid_off_with_months a
where total_off = (select max(total_off)
			from max_laid_off_with_months b
            where a.dates = b.dates)
            and dates like "2020%"
order by 2;







With max_laid_off_with_months as
(
select company,substring(`date`,1,7) as dates, sum(total_laid_off) as total_off
from layoff_staging2
group by dates,company
having dates is not null
order by 1
)
select company,
dates,
total_off
from max_laid_off_with_months a
where total_off = (select max(total_off)
			from max_laid_off_with_months b
            where a.dates = b.dates)
            and dates like "2023%"
order by 2;



select company,year(`date`) as Years,sum(total_laid_off) as total_off
from layoff_staging2
group by company,years
having (Years is not null) and total_off is not null 
;

with Company_Year as
(
select company,year(`date`) as Years,sum(total_laid_off) as total_off
from layoff_staging2
group by company,years
having (Years is not null) and total_off is not null 
),
Company_Year_Rank as
(
select company, Years, total_off, 
dense_rank() over (partition by years order by total_off desc) ranking
from Company_Year
)
select *
from Company_Year_Rank
where ranking<=5
;




with Company_Year as
(
select company,year(`date`) as Years,avg(percentage_laid_off) as percent_off
from layoff_staging2
group by company,years
having (Years is not null) and (percent_off is not null and percent_off != 1)
),
Company_Year_Rank as
(
select company, Years, percent_off, 
dense_rank() over (partition by years order by percent_off desc) ranking
from Company_Year
)
select *
from Company_Year_Rank
where ranking<=5
;


Select company as companies_shut_down, Year(`date`) Years, avg(percentage_laid_off) as percent_off
from layoff_staging2
group by company, Years
having percent_off = 1
;


with Industry_Year as
(
select industry,year(`date`) as Years,sum(total_laid_off) as total_off
from layoff_staging2
group by industry,years
having (Years is not null) and total_off is not null 
),
Industry_Year_Rank as
(
select industry, Years, total_off, 
dense_rank() over (partition by years order by total_off desc) ranking
from Industry_Year
)
select *
from Industry_Year_Rank
where ranking<=5
;




