-- creating hrdata table

CREATE TABLE hrdata(
	emp_no int8 PRIMARY KEY,
	gender varchar(50) NOT NULL,
	marital_status varchar(50),
	age_band varchar(50),
	age int8,
	department varchar(50),
	education varchar(50),
	education_field varchar(50),
	job_role varchar(50),
	business_travel varchar(50),
	employee_count int8,
	attrition varchar(50),
	attrition_label varchar(50),
	job_satisfaction int8,
	active_employee int8
)


-- import data in csv 


--select data

select * from hrdata

-- How many employees are High School graduates?

select sum(employee_count) as employee_count from hrdata
where education = 'High School'

-- How many employees are in the R&D department? 
select sum(employee_count) as employee_count from hrdata
where department = 'R&D'

-- how many employees have a Medical education field background? 
select sum(employee_count) as employee_count from hrdata
where education_field = 'Medical'


-- the number of attrition count
select count(attrition) from hrdata
where attrition = 'Yes'


-- the number of attrition with a doctoral degree? 
select count(attrition) from hrdata
where attrition = 'Yes' AND education = 'Doctoral Degree'


-- the number of attrition in the R&D department? 
select count(attrition) from hrdata
where attrition = 'Yes' AND department = 'R&D'

-- the number of attrition in the R&D department with medical education? 
select count(attrition) from hrdata
where attrition = 'Yes' AND department = 'R&D' and education_field = 'Medical'

--attrition rate
select round(((select count(attrition) from hrdata where attrition = 'Yes') /
sum(employee_count)) *100 ,2) from hrdata data

-- sales department attrition rate
select round(((select count(attrition) from hrdata where attrition = 'Yes' and 
department = 'Sales') / sum(employee_count)) *100 ,2) from hrdata data 
where department = 'Sales'

--active male employee 
select sum(employee_count) - (select count(attrition) from hrdata 
where attrition = 'Yes' and gender = 'Male')
from hrdata 
where gender = 'Male'

--avg age of employee 
select round(avg(age)) from hrdata

--attrition by gender 
select gender, count(attrition) from hrdata
where attrition = 'Yes' 
Group by gender

-- attrition by gender  with eduction of High school
select gender, count(attrition) from hrdata
where attrition = 'Yes' and education = 'High School'
Group by gender

-- attrition by department
select department, count(attrition),
round((cast(count (attrition) as numeric) / 
(select count(attrition) from hrdata where attrition = 'Yes' )) *100,2)
from hrdata
where attrition = 'Yes'
group by department
order by count(attrition) desc

--attrition by gender and department
select department, count(attrition),
round((cast(count (attrition) as numeric) /(select count(attrition) from 
hrdata where attrition = 'Yes' and gender = 'Female')) *100,2)
from hrdata
where attrition = 'Yes' and gender = 'Female'
group by department
order by count(attrition) desc

--no. of employee by age group
select age, sum(employee_count) from hrdata
group by age
order by age

--attrition by age group
select age_band, gender, count(attrition),
round((cast(count(attrition) as numeric)/ (select count(attrition)
 from hrdata where attrition = 'Yes'))*100,2)
from hrdata
where attrition= 'Yes'
group by age_band, gender
order by age_band, gender desc



CREATE EXTENSION IF NOT EXISTS tablefunc;

-- job satisfaction rating 
SELECT *
FROM crosstab(
'SELECT job_role, job_satisfaction, sum(employee_count)
	FROM hrdata
	GROUP BY job_role, job_satisfaction
	ORDER BY job_role, job_satisfaction')
	AS ct(job_role varchar(50), one numeric, two numeric, three numeric, four numeric)
	ORDER BY job_role;

--number of employee per age group
SELECT age_band, gender, sum(employee_count) from hrdata
group by age_band, gender
order by age_band, gender desc
