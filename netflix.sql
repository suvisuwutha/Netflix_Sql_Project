SELECT * FROM netflix_titles

 Count the number of Movies vs TV Shows

 SELECT  TYPE ,  COUNT(*) FROM netflix_titles
 GROUP BY TYPE

 2. Find the most common rating for movies and TV shows

 SELECT * FROM netflix_titles

 WITH MOST_RATING AS (
 SELECT TYPE,rating  , COUNT(*) as countof_rating FROM netflix_titles GROUP BY  TYPE,rating ),

 ranked as (SELECT TYPE,rating, RANK() OVER(PARTITION BY TYPE order by countof_rating desc) as rank  from MOST_RATING )
  
  select TYPE, rating , rank from ranked where rank = 1

  3. List all movies released in a specific year (e.g., 2020)

  SELECT * FROM netflix_titles

  SELECT type , release_year FROM netflix_titles where release_year = 2020 


4. Find the top 5 countries with the most content on Netflix

  SELECT * FROM netflix_titles
  with all_owncountries as (
  SELECT country,  
  LTRIM(RTRIM(value)) AS country_name
  FROM netflix_titles 
  cross apply STRING_SPLIT(country, ',') as all_countryies 
   )
  select  top 5 country_name, 
  count(*) as total_title
  from all_owncountries 
  group by country_name
  order by total_title desc

5. Identify the Longest Movie


   SELECT top 1 type , 
   duration  FROM 
   netflix_titles order by 
   duration desc

6. Find Content Added in the Last 5 Years

  SELECT * FROM netflix_titles

  SELECT * FROM netflix_titles where CONVERT(date, date_added, 107) 
  >= DATEADD(YEAR, -5, GETDATE())

 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'


   SELECT * FROM netflix_titles

   with directgors_values as (
   SELECT count(*),  LTRIM(RTRIM(value)) AS director_name

   FROM netflix_titles 
   cross apply STRING_SPLIT(director, ',') as all_countryies  where director = 'Rajiv Chilaka'  )

   select count(* )from directgors_values where director = 'Rajiv Chilaka'

   select count(* )from netflix_titles where director = 'Rajiv Chilaka'


8. List All TV Shows with More Than 5 Seasons


   --SELECT type, COUNT(*) FROM netflix_titles where type = 'TV Show' and   duration >= '5 Season' group by type

    --SELECT duration , type, COUNT(*) FROM netflix_titles where  duration >='5 Season' group by type, duration
	SELECT * FROM netflix_titles where  type = 'TV Show'  and
    CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) > 5

9. Count the Number of Content Items in Each Genre

   select COUNT(*), 
   value from (SELECT n.* , 
   s.value FROM netflix_titles as n 
   cross apply string_split(listed_in , ',' ) as s )  as t 
   group by value

10.Find each year and the average numbers of content release in India on netflix.

     SELECT * FROM netflix_titles


     SELECT country, avg( release_year), COUNT(show_id) as total_release ,

	 Round(
	 cast( COUNT(show_id) as float) /  CAST((SELECT COUNT(show_id) FROM netflix_titles WHERE country = 'India') AS FLOAT) 
        * 100, 
        2
    ) AS avg_release
	 
	 FROM netflix_titles where country = 'india' group by release_year , country order by avg_release desc



  
11. List all movies that are documentaries
    
	  SELECT * FROM netflix_titles


     SELECT * FROM netflix_titles
     WHERE listed_in LIKE '%Documentaries'

12. Find all content without a director

    SELECT * FROM netflix_titles
    WHERE director IS NULL

13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
 
    SELECT * FROM netflix_titles
    where  cast LIKE '%Salman Khan%'and  CONVERT(date, date_added, 107) 
  >= DATEADD(YEAR, -10, GETDATE())


14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

    SELECT 
	value ,
	count(*)

    FROM netflix_titles
	 cross apply STRING_SPLIT(cast, ',')
	group by value
	order by count(*)

15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords









