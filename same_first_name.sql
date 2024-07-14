-- サブクエリとJOIN
explain
select a.actor_id
     , a.first_name
     , a.last_name
     , same_first_name_actor.count as same_first_name_actor_count
from actor a
         left outer join (select sub_a.first_name AS first_name, count(*) AS count
                          from actor sub_a
                          group by sub_a.first_name) same_first_name_actor
                         on a.first_name = same_first_name_actor.first_name
         left join film_actor fa on a.actor_id = fa.actor_id
         left join film f on fa.film_id = f.film_id
where f.description like '%Documentary%' -- various conditions
group by a.actor_id
order by same_first_name_actor_count desc, a.actor_id
;

-- count distinctで複数
explain
select a.actor_id
     , a.first_name
     , a.last_name
     , count(distinct same_first_name_actor.actor_id, same_first_name_actor.first_name) as same_first_name_actor_count
from actor a
         left join actor same_first_name_actor on a.first_name = same_first_name_actor.first_name
         left join film_actor fa on a.actor_id = fa.actor_id
         left join film f on fa.film_id = f.film_id
where f.description like '%Documentary%' -- various conditions
group by a.actor_id
order by same_first_name_actor_count desc, a.actor_id
;

-- count distinctで複数
explain
select a.actor_id
     , a.first_name
     , a.last_name
     , same_first_name_actor.count as same_first_name_actor_count
from actor a
         left join lateral (
    select
        sub_a.first_name,
        count(sub_a.actor_id) as count
        from actor sub_a
    where a.first_name = sub_a.first_name
             group by sub_a.first_name
    ) same_first_name_actor on a.first_name = same_first_name_actor.first_name
         left join film_actor fa on a.actor_id = fa.actor_id
         left join film f on fa.film_id = f.film_id
where f.description like '%Documentary%' -- various conditions
group by a.actor_id
order by same_first_name_actor_count desc, a.actor_id
;

-- with句
with same_first_name_actor as (
    select first_name, count(actor_id) as count
    from actor
    group by first_name
)
select a.actor_id,
       a.first_name,
       a.last_name,
       sfa.count AS same_first_name_actor_count
FROM actor a
         LEFT JOIN same_first_name_actor sfa ON a.first_name = sfa.first_name
         LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
         LEFT JOIN film f ON fa.film_id = f.film_id
where f.description like '%Documentary%' -- various conditions
group by a.actor_id
order by same_first_name_actor_count desc, a.actor_id
;
