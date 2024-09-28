DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix;

---1. Count the Number of Movies vs TV Shows-----

select type, count(*) as count from netflix
group by type
order by count desc;

--- 2. Find the most common rating for movies and TV shows ---

with cte as(
select type, rating, count(*) as count ,
	dense_rank() over(partition by type order by count(*) desc) as rnk
	from netflix
group by type, rating
order by  count desc
	)
select type,rating from cte where rnk = 1;
	select type, count, dense_rank() over(partit)


--- 3. List all movies released in a specific year (e.g., 2020)---

select * from netflix
where type = 'Movie'
and release_year = 2020;

--- 4. Find the top 5 countries with the most content on Netflix---

select unnest(string_to_array(country, ',')) as new_country , count(*) as count
from netflix
where country is not null
group by 1
order by count desc
limit 5;

--- 5. Identify the longest movie-----
select title, duration from netflix
where type = 'Movie'
and duration = (select max(duration) from netflix)
order by duration desc;

----6. Find content added in the last 5 years-----
SELECT * 
FROM netflix
WHERE CAST(date_added AS DATE) <= CURRENT_DATE - INTERVAL '5 years';

----7. Find all the movies/TV shows by director 'Rajiv Chilaka'!----

SELECT * FROM netflix
WHERE director ILIKE 'Rajiv Chilaka';

-----8. List all TV shows with more than 5 seasons-----

select * , cast(left(duration,1) as integer) as seasons from netflix
where type = 'TV Show'
and cast(left(duration,1) as integer) > 5;


---- 9. Count the number of content items in each genre ----

select  unnest(string_to_array(listed_in, ',')) as genres,
count(*) as number from netflix
group by 1
order by number desc;

10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

select release_year, avg(duration) from netflix
group by release_year
---- 11. List all movies that are documentaries----

SELECT * FROM netflix
WHERE listed_in ILIKE '%Documentaries%';
----12. Find all content without a director---
SELECT * FROM netflix
WHERE director IS NULL;


13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select actors, count(*)
from (
select *, unnest(string_to_array(casts,',')) as actors from netflix
where release_year <=  extract(year from (CURRENT_DATE)) - 10) subquery
group by actors
having actors = 'Salman Khan';

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select actors, count(*)
from (
select *, unnest(string_to_array(casts,',')) as actors from netflix
where country ILIKE '%INDIA%') subquery
group by actors
order by count desc
limit 10;

15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
 
 with cte as (
select * , 
case when description ilike '%kill' or description ilike '%violence' then 'Bad'
else 'Good'
end as lable
 from netflix)
select lable, 
count(*)
from cte
group by lable;

WITH cte AS (
    SELECT *, 
    CASE 
        WHEN description ILIKE '%kill%' THEN 'Bad'  -- Checks if "kill" appears anywhere in the description
        ELSE 'Good'
    END AS label
    FROM netflix
)
SELECT label, 
       COUNT(*)
FROM cte
GROUP BY label;
