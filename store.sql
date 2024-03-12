select * from store;
select count(Row_ID) from store -- 2121 
select count(distinct Row_ID) from store -- 2121
select distinct Product_Name from store --380
select count(distinct Order_ID) from store --1764
select count (distinct Customer_Name) from store --707
select count (distinct Customer_ID) from store --707
select distinct Product_ID from store --375
select distinct Sub_Category from store --4
select min(Order_Date), max(Order_Date) from store -- 4 years
select distinct Ship_Mode from store --4
select distinct Segment from store --3
select distinct State from store --48
select distinct Region from store --4




-- Check And Removing Duplication 
with cte as
(
select * , rank() over(partition by [Order_ID],[Order_Date],[Ship_Date],[Ship_Mode],[Customer_ID],[Customer_Name]
,[Segment],[Country],[City],[State],[Postal_Code],[Region],[Product_ID],[Category],[Sub_Category],[Product_Name]
,[Sales],[Quantity],[Discount],[Profit] order by Row_ID) as duplicated
from store)
delete from cte
where duplicated > 1;


--select s1.Order_ID,s1.Customer_ID,s2.Order_ID,s2.Customer_ID
--from store s1 join store s2
--on s1.Order_ID = s2.Order_ID and s1.Customer_ID <> s2.Customer_ID


 --   SELECT Order_ID, Customer_ID, COUNT(*) AS occurrence
 --   FROM store
 --   GROUP BY Order_ID, Customer_ID
 --   HAVING COUNT(*) > 1
	--order by occurrence desc

select * from store

update store
set Discount = round(Discount,2);

update store
set Region = 'North'
where Region = 'Central';

exec sp_rename 'store.Discount%','Discount','column';

select min(Sales),max(Sales), avg(Sales)
from Store ;


------- There are More than Product Name for a lot of Product ID --------
--select Product_ID, count(distinct Product_Name) as Count
--from store
--group by Product_ID
--order by Count desc

select * from store 

------------------------------------------------------------------------
//---------------------------------------- KPIS REQUIREMENTS -------------------------------//
------------------------------------------------------------------------

--1)----- Total Sales --------
select cast(sum(Sales) as decimal(10,2)) as Total_Sales 
from store; -- 741718.42

--2)----- Total Profit --------
select cast(sum(Profit) as decimal(10,2)) as Total_Sales 
from store; -- 18463.33

--3)----- Shipping Rate --------
with ship as
(
select distinct Order_ID, Order_Date, Ship_Date, datediff(day,Order_Date,Ship_Date) as day_date_difference
from store
)
select CEILING(sum(cast(day_date_difference as decimal))/count(distinct Order_ID))  -- 4
from ship

--4)----- Avg Sales Per Order For Each Segment --------
select Segment, sum(Sales)/count(distinct Order_ID) Avg
from store
group by Segment;

--5)----- Top 10 Product Name Sales --------
select top 10 Product_Name, sum(Sales) as Sales
from store
group by Product_Name
order by Sales desc;
 
--6)----- Segment Sales PCT --------
select Segment , sum(Sales)*100/(select sum(Sales) from store) as PCT
from store
group by Segment
order by PCT desc;

--7)----- Top 10 Profitable Product Name,Sub Category --------
select top 10 Product_Name,Sub_Category, sum(Profit) profit
from store
group by Product_Name,Sub_Category
order by profit desc;

--8)----- Worst 10 Profitable Product Name,Sub Category --------
select top 10 Product_Name,Sub_Category, sum(Profit) profit
from store
group by Product_Name,Sub_Category
order by profit;

--9)----- Worst 10 Sales Product Name --------
select top 10 Product_Name, sum(Sales) as sales
from store
group by Product_Name
order by sales;

--10)----- Worst 10 Sales Cities --------
select top 10 City, sum(Sales) as sales
from store
group by City
order by sales;

--11)----- Top 10 Sales Cities --------
select top 10 City, sum(Sales) as sales
from store
group by City
order by sales desc;

--12)----- Top 10 Profit Cities --------
select top 10 City, sum(Profit) as sales
from store
group by City
order by sales desc;

select * from store











