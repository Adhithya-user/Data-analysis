-- sql project data cleaning
select*from employee_layoffs.layoffs;
-- remove duplicate
-- standardise data
-- no values or blank values
-- remove any column

-- use database to identify where it is located
use  employee_layoffs;
create table layoff_stage like layoffs;

-- now run another table like layoff_stage
select*from layoff_stage;

-- it is empty of the table so values can be inserted from before table like that

insert into layoff_stage select*from layoffs;

-- now run this query it show the values

select *,row_number() over( partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions) row_num from layoff_stage;
with duplicate as 
(
select *, row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions) as row_num from layoff_stage
) 
select*from duplicate where row_num>1;

-- finding duplicate 
select * from layoff_stage where company='elemy';
-- delete 
with duplicate as 
(
select *, row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions) as row_num from layoff_stage
) 
delete from duplicate where row_num>1;

-- delete process not applicable
CREATE TABLE `layoff_stage2` (
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

SELECT* from layoff_stage2;
insert into layoff_stage2 select *,row_number() over(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions) row_num from layoff_stage;
select* from layoff_stage2 where row_num>1;
-- delete data now is easy here
-- but it is not deleted because sql always have safe update,deletion process
delete from layoff_stage2 where row_num>1;
set sql_safe_updates=0;

-- safe update is enable

delete from layoff_stage2 where row_num>1;

-- STANDARDISING DATA 
SELECT company,trim(company)from layoff_stage2;
update layoff_stage2 set company = trim(company);

select distinct industry from layoff_stage2 order by 1;
select * from layoff_stage2 where industry like 'crypto%';

update layoff_stage2 set industry = 'crypto' 
where industry like 'crypto%';
select distinct industry from layoff_stage2;

-- now you have to check where the duplicate value can be occur

select distinct location from layoff_stage2;
-- in location column there is no duplicates

select distinct country from layoff_stage2 order by 1;

-- in this country column there is a duplicte value is occur (united states, united states.)

select distinct country,trim( trailing '.' from country) from layoff_stage2;

-- now you can be update 
update layoff_stage2 
set country=trim(trailing '.' from country) 
where country like 'united states%';

select DISTINCT country FROM layoff_stage2 order by 1;
-- now you see they are not full stop here in united states only  show distinct country one value united states
-- time series so date in text so it is a problem

select `date` from layoff_stage2;
-- arranging 
select `date`, str_to_date(`date`, '%m/%d/%y') from layoff_stage2;

-- now you can update
update layoff_stage2 
set `date`= str_to_date(`date`,'%m/%d/%Y');
-- MIND IT 'Y' should be capital
select `date` from layoff_stage2;

-- date in text so modify the function
alter table layoff_stage2 
modify column `date`  date;
 -- date in date 
 
 select* from layoff_stage2;
 
 -- null or blank values
 select * from layoff_stage2 
 where total_laid_off is null and percentage_laid_off is null;
 
 select * from layoff_stage2 where industry is null or industry='';
 
 -- '' no more gap it will give only one values
 select * from layoff_stage2
 where company = 'Airbnb';
 
 select * from layoff_stage2 t1 join layoff_stage2 t2 on  t1.company=t2.company
 where (t1.industry is  null or t1.industry ='' ) and t2.industry is not null;
 
 select t1.industry,t2.industry from layoff_stage2 t1 join layoff_stage2 t2 on t1.company=t2.company 
 where  (t1.industry is null or t1.industry='') and t2.industry is not null; 
 
 update layoff_stage2 t1 
 join layoff_stage2 t2 on t1.company = t2.company
 set t1.industry=t2.industry
 where (t1.industry is null or t1.industry='')
 and t2.industry is not null;
 
 -- update in industry look like a blanck then  I recover it blanck to replace in null
 
 update layoff_stage2
 set industry= null 
 where industry=''; 

select*from layoff_stage2;

-- remove any rows or column

select total_laid_off,percentage_laid_off from layoff_stage2 
where percentage_laid_off is null and total_laid_off is null;

select * from layoff_stage2 
where percentage_laid_off is null and total_laid_off is null;

-- null in tot and percent could be deleted

delete from layoff_stage2
where percentage_laid_off is null and total_laid_off is null;

-- now tot lay off plus percent lay off is not null it could be a values

select* from layoff_stage2;

-- now in final stage on this project
alter table layoff_stage2
drop column row_num;

select* from layoff_stage2;

-- data cleaning project is finined 

  
 
 
 
 







