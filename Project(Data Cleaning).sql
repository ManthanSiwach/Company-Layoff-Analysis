select * 
from layoff_staging;

Create table layoff_staging
like layoffs;

Insert Layoff_staging
Select * 
from layoffs;

WITH remove_dupes AS (
    SELECT 
        row_number() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS rn
    FROM layoff_staging
)
UPDATE layoff_staging l
JOIN remove_dupes rd ON 
    l.company = rd.company AND
    l.location = rd.location AND
    l.industry = rd.industry AND
    l.total_laid_off = rd.total_laid_off AND
    l.percentage_laid_off = rd.percentage_laid_off AND
    l.`date` = rd.`date` AND
    l.stage = rd.stage AND
    l.country = rd.country AND
    l.funds_raised_millions = rd.funds_raised_millions
SET l.row_num = rd.rn;

select count(company)
from layoff_staging;

alter table layoff_staging
drop column row_num ;

insert into layoff_staging(row_num,company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
SELECT 
row_number() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS rn,
company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
FROM layoff_staging;

CREATE TABLE `layoff_staging2` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select * 
from layoff_staging2
;

insert into layoff_staging2
SELECT *,
row_number() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_staging;


delete 
from layoff_staging2
where row_num>1;


update layoff_staging2
set company = trim(company);
update layoff_staging2
set location = trim(location);
update layoff_staging2
set industry = trim(industry);
update layoff_staging2
set country = trim(country);



SELECT distinct industry
from layoff_staging2
order by 1
;

Update layoff_staging2
set industry = 'Crypto'
where industry like 'Crypto%';



select * 
from layoff_staging2
;

select distinct country
from layoff_staging2
order by 1
;

select distinct location
from layoff_staging2
order by 1
;


Update layoff_staging2
set country =  Trim(trailing '.' from country);


select `date`
from layoff_staging2
;

update layoff_staging2
set `date` = 
	Case 
    
	when `date` like '%/%/%' then str_to_date(`date`,"%m/%d/%Y")
	
    when `date` like '%-%-%' then str_to_date(`date`,"%m-%d-%Y")

	End ;
    
alter table layoff_staging2
modify column `date` date;


select *
from layoff_staging2
;

select distinct location
from layoff_staging2
order by 1
;

update layoff_staging2
set location = "Dusseldorf"
where location like "%sseldorf"
;

update layoff_staging2
set location = "Malmo"
where location like "Malm%"
;

select *
from layoff_staging2
;

select company,location,industry
from layoff_staging2
where industry is null
or industry = ''
;

select company, industry
from layoff_staging2
where company = "airbnb"
;



select t1.industry,t2.industry
from layoff_staging2 t1
join layoff_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and (t2.industry is not null and t2.industry != '')
;

update layoff_staging2 t1
join layoff_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and (t2.industry is not null and t2.industry != '')
;


select distinct industry
from layoff_staging2
order by 1
;

select *
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null
;

delete 
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null
;

select *
from layoff_staging2
where total_laid_off =''
;


select *
from layoff_staging2
;


alter table layoff_staging2
drop column row_num
;


select *
from layoff_staging2
;