--Sql Retail Sales Analysis 


CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

select * from retail_sales

select count(*) from retail_sales

select * from retail_sales 
where 
     transactions_id is null 
	 or 
	 sale_date is null 
	 or
	 sale_time is null 
	 or
	 gender is null
	 or  
	 category is null
	 or 
	 quantity is null 
	 or
	 cogs is null
	 or 
	 total_sale is null;

delete from retail_sales
where
     transactions_id is null 
	 or 
	 sale_date is null 
	 or
	 sale_time is null 
	 or
	 gender is null
	 or  
	 category is null
	 or 
	 quantity is null 
	 or
	 cogs is null
	 or 
	 total_sale is null;
	 
-- how many unique customers we have?
select count( distinct customer_id) from retail_sales

-- data analysis 7 Findings

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales
where sale_date = '2022-11-05';

--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  and quantity >= 4
  and sale_date >= '2022-11-01' 
  and sale_date < '2022-12-01';

--3.Write a SQL query to calculate the total sales (total_sale) for each category.:
select category, sum(total_sale)
from retail_sales
group by category;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select  round(avg(age),2)
from retail_sales
where category ='Beauty'

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select transactions_id
from retail_sales
where total_sale >1000


--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select category, gender, count(transactions_id)
from retail_sales
group by category, gender
order by category 

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select 
      year,
      month,
      avg_sale
from 
(
 select 
      extract (year from sale_date) as year,
	  extract (month from sale_date) as month, 
	  avg(total_sale) as avg_sale,
	  rank() over(partition by extract(year from sale_date)order by avg(total_sale)Desc)
from retail_sales
group by 1,2
) as T1
where rank = 1


--8.Write a SQL query to find the top 5 customers based on the highest total sales **:
select 
     customer_id,
	 sum(total_sale) as ts
from retail_sales
group by customer_id
order by ts desc 
limit 5


-- Write a SQL query to find the number of unique customers who purchased items from each category.:
select 
     category,
	 count(distinct(customer_id))
from retail_sales
group by 1 



-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
as
(
select *,
     case 
	     when extract (hour from sale_time) < 12 then 'Morning' 
		 when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
		 else ' Evening'
     end as shifts
from retail_sales
)     
select  
     shifts, 
     count(*) as total_orders
from hourly_sale
group by shifts
 


