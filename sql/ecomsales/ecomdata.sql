-- create table

CREATE TABLE ecomdata(
	customer_id varchar(50),
	customer_first_name varchar(50),
	customer_last_name varchar(50),
	category_name varchar(50),
	product_name varchar(50),
	customer_segment varchar(50),
	customer_city varchar(50),
	customer_state varchar(50),
	customer_country varchar(50),
	customer_region varchar(50),
	delivery_status varchar(50),
	order_date date,
	order_id varchar(50),
	ship_date date,
	shipping_type varchar(50),
	days_for_shipment_scheduled smallint,
	days_for_shipment_real smallint,
	order_item_discount float,
	sales_per_order float,
	order_quantity smallint,
	profit_per_order float
)

-- import csv

--adding a year column
alter table ecomdata
add year_of_sales integer;

update ecomdata
set year_of_sales = EXTRACT(YEAR from order_date)

-- total profit of 2021
select sum(round(profit_per_order::numeric, 2)) as profit_in_2021
from ecomdata
where year_of_sales = 2021

-- total profit of 2022
select sum(round(profit_per_order::numeric, 2)) as profit_in_2021
from ecomdata
where year_of_sales = 2022


--total profit
select SUM(ROUND(profit_per_order::numeric,2)) as total_profit
from ecomdata

--total sales in 2021
select sum(round(sales_per_order::numeric, 2)) as sales_in_2021
from ecomdata
where year_of_sales = 2021

--total sales in 2022
select sum(round(sales_per_order::numeric, 2)) as sales_in_2022
from ecomdata
where year_of_sales = 2022

--total sales 
select sum(round(sales_per_order::numeric, 2)) as total_sales
from ecomdata

--quantity sold in 2021
select sum(order_quantity) as total_qty_sold_2021
from ecomdata 
where year_of_sales = 2021

--quantity sold in 2022
select sum(order_quantity) as total_qty_sold_2022
from ecomdata 
where year_of_sales = 2022

--total qty sold
select sum(order_quantity) as total_qty_sold
from ecomdata

--profit margin 2021
select (sum(profit_per_order::numeric) / sum(sales_per_order::numeric))*100 
				as profit_margin_2021
from ecomdata
where year_of_sales = 2021

-- profit margin 2022
select (sum(profit_per_order::numeric) / sum(sales_per_order::numeric))*100 
				as profit_margin_2021
from ecomdata
where year_of_sales = 2022

--total profit margin 

select (sum(profit_per_order::numeric) / sum(sales_per_order::numeric))*100 
				as profit_margin_2021
from ecomdata

--sales by category 2021
select distinct(category_name), round(sum(sales_per_order::numeric),2) as category_sales_2021
from ecomdata 
where year_of_sales = 2021
group by category_name
order by category_sales desc

--sales by category 2022
select distinct(category_name), round(sum(sales_per_order::numeric),2) as category_sales_2022
from ecomdata 
where year_of_sales = 2022
group by category_name
order by category_sales desc

-sales by category total 
select distinct(category_name), round(sum(sales_per_order::numeric),2) as category_sales
from ecomdata 
group by category_name
order by category_sales desc

-- top 10 sold items 2021
select distinct(product_name), sum(order_quantity) as order_qty, Round(sum(sales_per_order::numeric),2) as sales
from ecomdata 
where year_of_sales = 2021
group by product_name
order by order_qty desc limit 10

-- top 10 sold items 2022
select distinct(product_name), sum(order_quantity) as order_qty, Round(sum(sales_per_order::numeric),2) as sales
from ecomdata 
where year_of_sales = 2022
group by product_name
order by order_qty desc limit 10

--top 10 sold items total
select distinct(product_name), sum(order_quantity) as order_qty, Round(sum(sales_per_order::numeric),2) as sales
from ecomdata 
group by product_name
order by order_qty desc limit 10

--sales per region 2021
select distinct(customer_region), round(sum(sales_per_order::numeric),2) as sales_per_region
from ecomdata
where year_of_sales = 2021
group by customer_region
order by sales_per_region desc

--sales per region 2022
select distinct(customer_region), round(sum(sales_per_order::numeric),2) as sales_per_region
from ecomdata
where year_of_sales = 2022
group by customer_region
order by sales_per_region desc

-- sales per region total
select distinct(customer_region), round(sum(sales_per_order::numeric),2) as sales_per_region
from ecomdata
group by customer_region
order by sales_per_region desc

-- top 10 states with most sales 2021
select distinct(customer_state), round(sum(sales_per_order::numeric),2) as sales_per_region
from ecomdata
where year_of_sales = 2021
group by customer_state
order by sales_per_region desc
limit 10

--top 10 states with most sales 2022
select distinct(customer_state), round(sum(sales_per_order::numeric),2) as sales_per_region
from ecomdata
where year_of_sales = 2022
group by customer_state
order by sales_per_region desc
limit 10

-- top 10 state with most sales total
select distinct(customer_state), round(sum(sales_per_order::numeric),2) as sales_per_region
from ecomdata
group by customer_state
order by sales_per_region desc
limit 10
