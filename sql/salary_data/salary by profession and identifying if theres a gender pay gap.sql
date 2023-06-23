--create table 

Create table salaryData(
	age smallint,
	gender varchar(10),
	educational_lvl varchar(50),
	job_title varchar(100),
	years_of_exp smallint,
	salary float
)

-- import csv
COPY salaryData FROM 'sql\salary_data\salary_Data.csv' CSV HEADER;

--check data 
select * from salarydata

--updating data to remove inconsistency
UPDATE salaryData
SET educational_lvl = 
  CASE
    WHEN educational_lvl = 'phD' THEN 'PhD'
    WHEN educational_lvl = 'Master''s' THEN 'Master''s Degree'
    WHEN educational_lvl = 'Bachelor''s' THEN 'Bachelor''s Degree'
    ELSE NULL
  END
WHERE educational_lvl IN ('phD', 'Master''s', 'Bachelor''s', NULL);


""" avg salary for each profession with less than 1 year of exp. also indicated 
		the lower end and higher end of the salary"""
select distinct(job_title), avg(salary) as sal, years_of_exp, max(salary) as higherEnd, min(salary) as lowerEnd from salarydata
where years_of_exp <= 1
group by 1,3
order by sal desc

 
select job_title, max(salary)  from salarydata 
where years_of_exp = 1 
group by 1
limit 1

-- professions with lowest salary with 1 year exp
select job_title, min(salary)  from salarydata 
where years_of_exp = 1 
group by 1
limit 1


-- gender pay gap if any 
SELECT job_title,
       AVG(CASE WHEN gender = 'Male' THEN salary END) AS avg_male_salary,
       AVG(CASE WHEN gender = 'Female' THEN salary END) AS avg_female_salary
FROM salarydata
WHERE years_of_exp = 2
GROUP BY job_title;


-- avg salary by educational level and years of exp. 
SELECT DISTINCT job_title, educational_lvl , avg(salary)
FROM salarydata
WHERE educational_lvl = 'Bachelor''s Degree' and years_of_exp = 1
group by job_title, educational_lvl
order by 3 desc
