-- Netflix Project 

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix 
(
	show_id	VARCHAR (6),
	type	VARCHAR (10),
	title	VARCHAR (150),
	director	VARCHAR(210),
	casts	VARCHAR(1000),
	country	VARCHAR(150),
	date_added	VARCHAR(150),
	release_year INT,	
	rating	VARCHAR (10),
	duration	VARCHAR (15),
	listed_in	VARCHAR (100),
	description VARCHAR (250)

)

SELECT * FROM netflix

--1. Count the Number of Movies vs TV Shows

SELECT 
	type,
	COUNT(* ) 

FROM netflix
GROUP BY type;

--2. Find the Most Common Rating for Movies and TV Shows
SELECT type,
	   rating
FROM

   (SELECT 
          type,
          rating,
	    COUNT(rating),    
	     RANK() OVER ( PARTITION BY type ORDER BY COUNT(rating) DESC) AS rnk
  FROM netflix
   GROUP BY type, rating)
WHERE rnk = 1

--3. List All Movies Released in a Specific Year ( 2020)

SELECT *
FROM netflix
WHERE release_year = '2020'
	AND type = 'Movie';

--4.Find the Top 5 Countries with the Most Content on Netflix

SELECT 
	TRIM(
	UNNEST(STRING_TO_ARRAY(country,','))) AS new_country,
	count(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--5.Identify the Longest Movie

SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC********

--6. Find Content Added in the Last 5 Years

SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--7.Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT * 
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

--8.List All TV Shows with More Than 5 Seasons

SELECT *
FROM netflix
WHERE type = 'TV Show'
      AND 
      SPLIT_PART(duration, ' ',1):: numeric > 5;

--9.  Count the Number of Content Items in Each Genre

SELECT 
     UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
     COUNT (show_id) AS total_content
FROM netflix
GROUP BY 1

--10.Find each year and the average numbers of content release in India on netflix.

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

--11. List All Movies that are Documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

--12.Find All Content Without a Director
SELECT * 
FROM netflix
WHERE director IS NULL;

--13.Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

14.Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;