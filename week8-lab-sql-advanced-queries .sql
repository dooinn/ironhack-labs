-- Week 8 | SQL Advanced queries

use sakila;


-- 1. List each pair of actors that have worked together.
select fa1.actor_id as actor1, fa2.actor_id as actor2 from film_actor fa1
join film_actor fa2
on fa1.actor_id <> fa2.actor_id
and fa1.film_id = fa2.film_id
where fa1.actor_id < fa2.actor_id;

-- 2. For each film, list actor that has acted in more films. > 107
 select actor_id
from film_actor
group by actor_id
having count(*) = (
    select max(count)
    from (
        select count(*) as count
        from film_actor
        group by actor_id
    ) as subquery
);

-- same result using CTE

with actor_counts as (
    select actor_id, count(*) as count
    from film_actor
    group by actor_id
),
max_count as (
    select max(count) as max_count
    from actor_counts
)
select actor_id
from actor_counts
where count = (select max_count from max_count);





