create table pizza_sales_table as
select 
od.pizza_id, od.order_id, pt.pizza_type_id, od.quantity,
o.order_date, o.order_time,
p.price, p.size,
 pt.category, pt.ingredients 
from order_details od 
join orders o on od.order_id = o.order_id 
join pizzas p on p.pizza_id = od.pizza_id
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id;

select *
from pizza_sales_table;

-- Total Revenue
select sum(price) as total_revenue from pizza_sales_table;

-- Average order value
select round(sum(price) / count(distinct(order_id))) as Average_order_value
from pizza_sales_table;

-- Average pizzas per order
SELECT CAST(SUM(quantity) / COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS avg_pizzas_per_order
FROM pizza_sales_table;

-- Hourly trend of total pizza sold
select hour(order_time) as hours, sum(quantity) as total_pizzas_sold
from pizza_sales_table
group by hours
order by hours desc; 

-- weekly trends for total order
select week(order_date) as week_numbers,year(order_date) as years, COUNT(DISTINCT order_id) as total_orders
from pizza_sales_table
group by week_numbers, years
order by week_numbers, years desc; 

-- percentage of sales by category
select category, round(sum(price) * 100 / (select sum(price) from pizza_sales_table),2) as percentage_of_sales
from pizza_sales_table
group by category;

-- percentage of sales by size
select size, round(sum(price) * 100 / (select sum(price) from pizza_sales_table),2) as percentage_of_sales
from pizza_sales_table
group by size;

-- I had forgotten to include name coulmn in pizza_sales_table, hence iam creatinga new one :-(
create table pizza_table as
select 
pst.pizza_id, pst.order_id, pst.pizza_type_id, pst.quantity,
pst.order_date, pst.order_time,
pst.price, pst.size,
 pst.category, pt.name, pst.ingredients 
from pizza_sales_table pst 
join pizza_types pt on pst.pizza_type_id = pt.pizza_type_id;

select *
from pizza_table;

-- Top 5 Best Sellers by Revenue, Total Quantity and Total Orders
select name, round(sum(quantity * price),2) as total_revenue, sum(quantity) as total_quantity, count(distinct(order_id)) as total_orders
from pizza_table
group by name 
order by 3 desc;
