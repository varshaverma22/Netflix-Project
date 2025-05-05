use master
drop table netflix_data

create TABLE [dbo].[netflix_data](
	[show_id] [varchar](10) primary key,
	[type] [varchar](10) NULL,
	[title] [nvarchar](200) NULL,
	[director] [varchar](250) NULL,
	[cast] [varchar](1000) NULL,
	[country] [varchar](150) NULL,
	[date_added] [varchar](20) NULL,
	[release_year] [int] NULL,
	[rating] [varchar](10) NULL,
	[duration] [varchar](10) NULL,
	[listed_in] [varchar](100) NULL,
	[description] [varchar](500) NULL
) 

----- Transform Netflix Data --------

-- Delete the rows where the title contain the "?" 
delete from netflix_data

8807-15

select * from netflix_data
delete from netflix_data
where title like '?%'

-- remove duplicate

select show_id,count(*) from netflix_data 
group by show_id
having count(*)>1

-- Taking the two colm for uniqueness and find out the duplicates
-- Checking which record is duplicate
select * from netflix_data 
where concat(upper(title),type) in(
select concat(upper(title),type)
from netflix_data 
group by upper(title),type
having count(*)>1)
order by title

-- Only see the unique value
select * from netflix_data

with cte as(select * , row_number() over(partition by title, type order by show_id) as	rn
from netflix_data)
select * from cte where rn=1

-- new table for listed in, director, country, cast
select show_id, trim(value) as listed_in
into listed_in
from netflix_data
cross apply string_split(listed_in,',')

select show_id, trim(value) as director
into director
from netflix_data
cross apply string_split(director,',')

select show_id, trim(value) as country
into country
from netflix_data
cross apply string_split(country,',')

select show_id, trim(value) as cast
into cast
from netflix_data
cross apply string_split(cast,',')

-- change the data type of date
select * from netflix_data
WITH cte AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY title, type ORDER BY show_id) AS rn FROM netflix_data)
SELECT show_id, type, title, CAST(date_added AS DATE) AS date_added,release_year, rating, duration, description
FROM cte
WHERE rn = 1;

-- Populate the Missing value in country, duration colm
select show_id,country
from netflix_data
where country is null


select director,country --Just join the country and director based on show_id
from country c
inner join director d on c.show_id=d.show_id
group by director,country
order by director

insert into country                       -- Added in country table
select show_id,m.country                  -- Those country contain the null value, just mapping with above query 
from netflix_data rn                      -- help for handling the null value
inner join(select director,country
from country c
inner join director d on c.show_id=d.show_id
group by director,country) m on rn.director=m.director
where rn.country is null

------------- Handling the Nulls in duration

WITH cte AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY title, type ORDER BY show_id) AS rn FROM netflix_data)
SELECT show_id, type, title, CAST(date_added AS DATE) AS date_added,release_year, rating,
case when duration is null then rating else duration end as duration, description
into netflix
FROM cte
WHERE rn = 1

-- Final Clean data rest thing we can add using join

select * from netflix

-----------------------------------NETFLIX DATA ANALYSIS------------------------------------------

/* 1. For each director count the no of movie and tv shows created by them in seperate columns for directors who
have created tv show and moives both*/

select d.director,
count(distinct(case when type='TV Show' then n.show_id end)) as  no_of_TV_Show
,count(distinct(case when type='Movie' then n.show_id end)) as no_of_Movie
from netflix n
inner join director d on n.show_id=d.show_id
group by d.director
having count(distinct n.type)>1

--2. Which country has highest number of comedy movies

select top 1 country,count(listed_in) as no_of_comedies
from listed_in l
inner join country c on l.show_id=c.show_id
where listed_in='Comedies'
group by country
order by count(listed_in) desc

--3. For each year (as per date added to netflix), which director has maximum number of movies released
with cte as(select year(date_added) as date_year, count(n.show_id) as no_of_movie ,d.director from netflix n
inner join director d on n.show_id=d.show_id
where type='Movie'
group by year(date_added),d.director),cte2 as (
select *, row_number() over(partition by date_year order by no_of_movie desc,director) as rn
from cte)
select * from cte2 where rn=1

--4. What is average duration of movies in each genre
select *,cast(replace(replace(duration,'min',''),'Season','') as int) as duration
from netflix n
inner join listed_in l on n.show_id=l.show_id
where type='Movie'



