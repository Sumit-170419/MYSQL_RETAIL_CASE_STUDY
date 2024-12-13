select * from customer_profiles;
alter table customer_profiles
rename column ï»¿CustomerID to CustomerID;

alter table product_inventory
rename column ï»¿ProductID to ProductID;
select * from product_inventory;

alter table sales_transaction
rename column ï»¿TransactionID to TransactionID;
select * from sales_transaction;

-- Write a query to identify the number of duplicates in "sales_transaction" table.
-- Also, create a separate table containing the unique values and remove the the original table from the databases 
-- and replace the name of the new table with the original name.

select transactionid,count(*)
 from sales_transaction 
 group by 1 
 having count(*) >1;

 select distinct * 
 from sales_transaction; 

create table sales2 as 
 select distinct * 
 from sales_transaction;

 drop table sales_transaction; 

 alter table sales2
 rename to Sales_transaction;

-- Write a query to identify the discrepancies in the price of the same product in "sales_transaction" and "product_inventory" tables.
-- Also, update those discrepancies to match the price in both the tables.

select s.TransactionID,s.price as TransactionPrice,p.price as InventoryPrice 
from sales_transaction s 
join product_inventory p 
on s.productid = p.productid 
where s.price <> p.price;

update sales_transaction s 
join product_inventory p  
on s.productid = p.productid 
set s.price = p.price 
where s.price<>p.price ;

select * from sales_transaction;

-- Write a SQL query to identify the null values in the dataset and replace those by “Unknown”.

select count(*) 
from customer_profiles 
where location is null;

update customer_profiles 
set location = "Unknown"
where location is null;

select * from customer_profiles;

-- Write a SQL query to clean the DATE column in the dataset.

-- Steps:
-- Create a separate table and change the data type of the date column as it is in TEXT format and name it as you wish to.
-- Remove the original table from the database.
-- Change the name of the new table and replace it with the original name of the table.

create table updatedate as
select *,cast(transactiondate as date) as Transactiondate_updated
from sales_transaction;

drop table sales_transaction;

alter table updatedate 
rename to sales_transaction;
select * from sales_transaction;

-- Write a SQL query to summarize the total sales and quantities sold per product by the company.

select ProductID
         ,sum(quantitypurchased) TotalUnitsSold
         ,sum(quantitypurchased*price) TotalSales 
from sales_transaction
group by 1
order by 3 desc;   

-- Write a SQL query to count the number of transactions per customer to understand purchase frequency.

select CustomerID,count(transactionid) NumberOfTransactions 
from sales_transaction 
group by 1 
order by 2 desc;

-- Write a SQL query to evaluate the performance of the product categories based on the total sales 
-- which help us understand the product categories which needs to be promoted in the marketing campaigns.

select p.Category
         ,sum(s.quantitypurchased) TotalUnitsSold 
         ,sum(s.quantitypurchased*s.price) TotalSales 
from sales_transaction s 
join product_inventory p 
on s.productid = p.productid 
group by 1 
order by 3 desc; 

-- Write a SQL query to find the top 10 products with the highest total sales revenue from the sales transactions. 
-- This will help the company to identify the High sales products which needs to be focused to increase the revenue of the company.

select ProductID
        ,sum(price*quantitypurchased) TotalRevenue 
from sales_transaction 
group by 1 
order by 2 desc 
limit 10;      

-- Write a SQL query to find the ten products with the least amount of units sold from the sales transactions, 
-- provided that at least one unit was sold for those products.

select ProductID
         ,sum(quantitypurchased) TotalUnitsSold 
from sales_transaction 
group by 1 
having sum(quantitypurchased)>=1 
order by 2 
limit 10;         

-- Write a SQL query to identify the sales trend to understand the revenue pattern of the company.

select Transactiondate_updated as DATETRANS 
          ,count(transactionid) as Transaction_count
          ,sum(quantitypurchased) as TotalUnitsSold 
          ,sum(quantitypurchased*price) as TotalSales 
from sales_transaction          
group by 1 
order by 1 desc;

-- Write a SQL query to understand the month on month growth rate of sales of the company which will help understand the growth trend of the company.

with cte1 as(
    select month(transactiondate) as month,sum(quantitypurchased*price) as total_sales
    from sales_transaction
    group by 1)
select *,lag(total_sales) over() as previous_month_sales,
((total_sales-lag(total_sales) over())/lag(total_sales) over())*100 as mom_growth_percentage
from cte1;

-- Write a SQL query that describes the number of transaction along with the total amount spent by each customer 
-- which are on the higher side and will help us understand the customers who are the high frequency purchase customers in the company.

select CustomerID,count(transactionid) as NumberOfTransactions
,sum(price*quantitypurchased) as TotalSpent  
from sales_transaction 
group by 1
having NumberOfTransactions > 10 and TotalSpent > 1000
order by TotalSpent desc;

-- Write a SQL query that describes the number of transaction along with the total amount spent by each customer, 
-- which will help us understand the customers who are occasional customers or have low purchase frequency in the company.

select CustomerID,count(transactionid) as NumberOfTransactions
,sum(price*quantitypurchased) as TotalSpent  
from sales_transaction 
group by 1
having NumberOfTransactions <=2 
order by NumberOfTransactions, TotalSpent desc;

-- Write a SQL query that describes the total number of purchases made by each customer against each productID to understand the repeat customers in the company.

select CustomerID
         ,ProductID
         ,count(quantitypurchased) as TimesPurchased 
from sales_transaction 
group by 1,2 
having TimesPurchased > 1 
order by TimesPurchased desc;   

-- Write an SQL query that segments customers based on the total quantity of products they have purchased. 
-- Also, count the number of customers in each segment which will help us target a particular segment for marketing.

create table customer_segment as
with cte1 as(
select customerid,sum(quantitypurchased) as total_quantity
 from sales_transaction
 group by customerid) 
 select *,case
 when total_quantity between 1 and 9 then "Low"
 when total_quantity between 10 and 30 then "Med"
 else "High" end as CustomerSegment
 from cte1;

select CustomerSegment,count(*)
from customer_segment 
group by 1










      









































  
















      
















