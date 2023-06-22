-- Week8, day 2 Lab | SQL Rolling calculations


use sakila;


-- 1. Get number of monthly active customers.


select * from customer;


with cte_active_customer as (
select 
	customer_id, 
    date(rental_date) as date,
    extract(month from rental_date) as activity_month,
    extract(year from rental_date) as activity_year
from rental
) select 
	activity_year,
    activity_month,
    count(distinct customer_id) as active_customers
from cte_active_customer
group by activity_year, activity_month;



-- 2. Active users in the previous month.

with cte_active_customer as (
select 
	customer_id, 
    date(rental_date) as date,
    extract(month from rental_date) as activity_month,
    extract(year from rental_date) as activity_year
from rental
),
cte_active_month_total as(
select 
	activity_year,
    activity_month,
    count(distinct customer_id) as active_customers
from cte_active_customer
group by activity_year, activity_month
) 
select 
	activity_year, 
	activity_month, 
	active_customers,
    lag(active_customers) over (order by activity_year,activity_month) as last_month
from cte_active_month_total;




-- 3. Percentage change in the number of active customers.

with cte_active_customer as (
select 
	customer_id, 
    date(rental_date) as date,
    extract(month from rental_date) as activity_month,
    extract(year from rental_date) as activity_year
from rental
),
cte_active_month_total as(
select 
	activity_year,
    activity_month,
    count(distinct customer_id) as active_customers
from cte_active_customer
group by activity_year, activity_month
),
cte_active_prev as (
select 
	activity_year, 
	activity_month, 
	active_customers,
    lag(active_customers) over (order by activity_year,activity_month) as last_month
from cte_active_month_total
)
select *,
	(active_customers - last_month) as difference,
    concat(round((active_customers - last_month)/active_customers*100), "%") as percent_difference
from cte_active_prev;




-- 4. Retained customers every month.


with cte_active_customer as (
select 
	customer_id, 
    date(rental_date) as date,
    extract(month from rental_date) as activity_month,
    extract(year from rental_date) as activity_year
from rental
),
active_month as (
select distinct 
	customer_id as active_id, 
	activity_year, 
	activity_month
from cte_active_customer
order by active_id, activity_year, activity_month
)
select acm1.active_id , acm1.activity_year, acm1.activity_month, acm2.activity_month as previous_month
from active_month acm1
join active_month acm2
on acm1.active_id = acm2.active_id
and acm1.activity_year = acm2.activity_year
and acm1.activity_month = acm2.activity_month + 1
order by acm1.active_id, acm1.activity_year, acm2.activity_month;









