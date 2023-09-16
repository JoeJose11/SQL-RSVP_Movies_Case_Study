USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT Count(*) AS Number_of_rows_director_mapping
FROM   director_mapping; 
    
-- Number of rows in director_mapping table - 3867

SELECT Count(*) AS Number_of_rows_genre
FROM   genre; 
    
-- Number of rows in genre table - 14662
    
SELECT Count(*) AS Number_of_rows_movie
FROM   movie; 
    
-- Number of rows in movie table - 7997
    
SELECT Count(*) AS Number_of_rows_names
FROM   names; 

-- Number of rows in names table - 25735

    
SELECT Count(*) AS Number_of_rows_ratings
FROM   ratings; 
    
-- Number of rows in ratings table - 7997
    
SELECT Count(*) AS Number_of_rows_role_mapping
FROM   role_mapping; 

-- Number of rows in role_mapping table - 15615




-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS null_id,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS null_title,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS null_date_published,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS null_duration,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS null_worlwide_gross_income,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS null_languages,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS null_production_company
FROM
    movie;

/* 'Country' (20 null values), 'worlwide_gross_income'( 3724 null values), 'languages' (194 null values) and 
'production_company' (528 null values)  columns have NULL values. */



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


-- Number of movies released each year

SELECT year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year; 

/* 2017- 3052 movies
   2018- 2944 movies
   2019- 2001 movies */
-- Highest number of movies were released in 2017 (3052 movies).



-- Number of movies released each month

SELECT Month(date_published) AS month_num,
       Count(id)             AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 


/*    month_num	number_of_movies
			1	804
			2	640
			3	824
			4	680
			5	625
			6	580
			7	493
			8	678
			9	809
			10	801
			11	625
			12	438
     
   Highest number of movies were released in March (824 movies) and lowest in December (438 movies). */


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(id) AS Movies_USA_India_2019
FROM   movie
WHERE  country REGEXP 'USA|India'
       AND year = 2019; 

-- A total of 1059 movies were produced in 2019 by USA and India.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre; 

-- There are a total of 13 genres.



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       COUNT(id) AS No_of_Movies
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY no_of_movies DESC
LIMIT  1; 

-- Genre "Drama" has the highest number of movies produced overall with 4285 movies. 



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

/* Creating a CTE to find out movies which belong to only one genre 
and then applying the count function to find the total number of movies. */

WITH movies_single_genre
     AS (SELECT movie_id,
                Count(genre) AS number_of_movies
         FROM   genre
         GROUP  BY movie_id
         HAVING number_of_movies = 1)
SELECT Count(*) AS single_genre_movies
FROM   movies_single_genre; 

-- A total of 3289 movies belong to only one genre.



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       Round(Avg(duration), 2) AS Average_Duration
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY average_duration DESC; 

-- Genre "Action" has the highest average duation (112.88 mnts) and "Horror" has the lowest average duration(92.72 mnts).


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


-- Creating a CTE and applying the RANK function to find out the rank of each genre based on number of movies.

WITH rank_genre
     AS (SELECT genre,
                Count(movie_id)                    AS movie_count,
                RANK()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   rank_genre
WHERE  genre = "Thriller"; 

-- Genre "Thriller" is in rank 3 based on the number of movies produced with a movie count of 1484.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too


-- Using the RANK function to find the top 10 movies based on their average rating.

SELECT     title,
           avg_rating,
           RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM       ratings r
INNER JOIN movie m
ON         r.movie_id = m.id limit 15;

-- Movies named "Kirket" and "Love in Kilnerry" have the highest average rating.


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


-- Creating a CTE and using the RANK function to find the production company with the most hit movies.

WITH top_prod_company
     AS (SELECT production_company,
                Count(id)                    AS movie_count,
                RANK()
                  OVER(
                    ORDER BY Count(id) DESC) AS prod_company_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   top_prod_company
WHERE  prod_company_rank = 1; 

/*  Dream Warrior Pictures and National Theatre Live are the production companies who produced the most number of 
     hit movies (average rating > 8). */


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


-- Regular Expression is used in the query for pattern matching.

SELECT genre,
       COUNT(id) AS movie_count
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON g.movie_id = r.movie_id
WHERE  ( country REGEXP 'USA' )
       AND year = 2017
       AND MONTH(date_published) = 3
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

-- "Drama", "Comdedy" and "Action" are the top 3 genres released during March 2017 in the USA and had more than 1,000 votes.




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


-- Regular Expression is used in the query for pattern matching.

SELECT title,
       avg_rating,
       genre
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
       INNER JOIN genre g
               ON m.id = g.movie_id
WHERE  title REGEXP '^The'
       AND avg_rating > 8
ORDER  BY avg_rating DESC; 

-- There are a total of 8 movies that start with the word ‘The’ and which have an average rating > 8.



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- BETWEEN operator is used in the query to find the movies released between 1 April 2018 and 1 April 2019.

SELECT median_rating,
       Count(id) AS movie_count
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND median_rating = 8; 

-- 361 movies released between 1 April 2018 and 1 April 2019 were given a median rating of 8.



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


/*  Finding the toal number of votes for both German and Italian movies and using the 
    UNION operator to display the results together.   */
    
SELECT "German"         AS Language,
       SUM(total_votes) AS Total_votes
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  languages REGEXP 'German'
UNION
SELECT "Italian"        AS Language,
       SUM(total_votes) AS Total_votes
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  languages REGEXP 'Italian'; 

-- German movies got more votes than Italian movies.
-- German movies got 4421525 votes where as Ialian movies got only 2559540 votes.


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) 				AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) 			AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) 		AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) 	AS known_for_movies_nulls
FROM names;


-- Column "name" has no NULL values
-- Columns "height", "date_of_birth" and "known_for_movies" have NULL values.


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- A CTE is created to find the top 3 genres based on the number of movies with an average rating > 8.

WITH top_genre AS
(
           SELECT     genre,
                      Count(id)                            AS movie_count,
                      Rank() OVER(ORDER BY Count(id) DESC) AS rank_genre
           FROM       movie m
           INNER JOIN ratings r
           ON         m.id = r.movie_id
           INNER JOIN genre g
           ON         m.id = g.movie_id
           WHERE      avg_rating >8
           GROUP BY   genre limit 3)
SELECT     NAME              AS director_name ,
           Count(d.movie_id) AS movie_count
FROM       director_mapping d
INNER JOIN genre g
using      (movie_id)
INNER JOIN names n
ON         n.id = d.name_id
INNER JOIN top_genre tg
using      (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 5 ;

/*   James Mangold,Anthony Russo,Soubin Shahir and Joe Russo are among the top 3 directors in the top three genres 
     whose movies have an average rating > 8.   */



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name                 AS actor_name,
       Count(rm.movie_id) AS movie_count
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN ratings r
               ON r.movie_id = rm.movie_id
WHERE  median_rating >= 8
       AND category = 'actor'
GROUP  BY name
ORDER  BY movie_count DESC
LIMIT  2; 

-- Top two actors whose movies have a median rating >= 8 are Mammootty and Mohanlal.


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


/*  Creating a CTE with the RANK function and  applying the select statement on the CTE with the WHERE clause to find 
	the top three production houses based on the number of votes received by their movies.  */
    
    
WITH ranks
     AS (SELECT production_company,
                Sum(total_votes)                    AS vote_count,
                Rank()
                  OVER(
                    ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         GROUP  BY production_company)
SELECT production_company,
       vote_count,
       prod_comp_rank
FROM   ranks
WHERE  prod_comp_rank < 4; 

/*  Marvel Studios, Twentieth Century Fox and Warner Bros. are the top three production houses based on the number of votes 
    received by their movies.  */


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

/*  Using Regular Expression to pattern matching and to filter the data based on country as some of the movies were released 
    in more than one country and all the country names are metioned together separated by a comma */
    
    

SELECT     name                                                                                               AS actor_name,
           Sum(total_votes)                                                                                   AS total_votes,
           Count(m.id)                                                                                  	  AS movie_count,
           Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)                                         AS actor_avg_rating,
           Rank() OVER(ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) DESC, 
           Sum(total_votes) DESC) 		
																											  AS actor_rank

FROM       names n
INNER JOIN role_mapping rm
ON         n.id = rm.name_id
INNER JOIN movie m
ON         rm.movie_id = m.id
INNER JOIN ratings
USING     (movie_id)
WHERE      country REGEXP 'India' AND category = 'actor'
GROUP BY   NAME
HAVING     movie_count >=5;


-- Top actor is Vijay Sethupathi with 23114 total votes, 5 movie count and 8.42 rating followed by Fahadh Faasil and Yogi Babu.



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH top_actress_hindi AS
(SELECT     name                                                                                              AS actress_name,
           Sum(total_votes)                                                                                   AS total_votes,
           Count(m.id)                                                                                  	  AS movie_count,
           Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)                                         AS actress_avg_rating,
           Rank() OVER(ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) DESC, 
           Sum(total_votes) DESC) 		
																											  AS actress_rank

FROM       names n
INNER JOIN role_mapping rm
ON         n.id = rm.name_id
INNER JOIN movie m
ON         rm.movie_id = m.id
INNER JOIN ratings
USING     (movie_id)
WHERE      languages REGEXP 'Hindi' AND country REGEXP 'India' AND category = 'actress'
GROUP BY   NAME
HAVING     movie_count >=3)

SELECT * FROM top_actress_hindi
WHERE actress_rank <= 5;

/* Top five actresses in Hindi movies released in India based on their average ratings are 
   Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor and Kriti Kharbanda respectively. */



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Using CASE statement to classify thriller movies as per avg rating.

SELECT title,
       avg_rating,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         WHEN avg_rating < 5 THEN 'Flop movies'
       END AS Rating_classification
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  genre = 'thriller'; 



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
       ROUND(AVG(duration), 2)                         AS avg_duration,
       SUM(ROUND(AVG(duration), 2))
         OVER(
           ORDER BY genre ROWS unbounded preceding)    AS running_total_duration
       ,
       ROUND(AVG(ROUND(AVG(duration), 2))
               OVER(
                 ORDER BY genre ROWS 10 preceding), 2) AS moving_avg_duration
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY genre; 


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:




/*  Creating a CTE and converting worlwide_gross_income datatype from varchar to decimal and then converting the values in INR 
	to USD. (Conversion rate is taken as 1 USD = 80 INR) */
    
/* Creating another CTE to find out the top 3 genres based on the most number of movies and applying the rank function to rank the 
	movies based on the worlwide_gross_income of each year and finally filtering the data with a WHERE clause to display the five 
	highest-grossing movies of each year that belong to the top three genres.   */


WITH gross_usd AS
(
       SELECT *,
              CASE
                     WHEN worlwide_gross_income LIKE 'INR%' THEN Round(Cast(Replace(worlwide_gross_income, 'INR', '') AS DECIMAL(12)) / 82)
                     WHEN worlwide_gross_income LIKE '$%' THEN Round(Cast(Replace(worlwide_gross_income, '$', '') AS     DECIMAL(12)))
                     ELSE Round(Cast(worlwide_gross_income AS                                                            DECIMAL(12)))
              END worldwide_gross_income
       FROM   movie ), top3_genre AS
(
           SELECT     genre,
                      Count(movie_id)
           FROM       genre g
           INNER JOIN movie m
           ON         g.movie_id = m.id
           GROUP BY   genre
           ORDER BY   Count(movie_id) DESC limit 3 ), top5_movies AS
(
           SELECT     genre,
                      m.year,
                      m.title AS movie_name,
                      worldwide_gross_income,
                      Dense_rank() OVER(partition BY year ORDER BY worldwide_gross_income DESC) AS movie_rank
           FROM       movie m
           INNER JOIN genre g
           ON         m.id= g.movie_id
           INNER JOIN gross_usd usd
           ON         m.id = usd.id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top3_genre)
           GROUP BY   genre,
                      m.year,
                      movie_name,
                      worldwide_gross_income
           ORDER BY   m.year)
SELECT *
FROM   top5_movies
WHERE  movie_rank<=5;


-- The Fate of the Furious is the highest-grossing movie of 2017 that belongs to one of the top three genres.
-- Bohemian Rhapsody is the highest-grossing movie of 2018 that belongs to one of the top three genres.
-- Avengers: Endgame is the highest-grossing movie of 2019 that belongs to one of the top three genres.




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


-- If the movie is multilingual, 'languages' column would contain multiple values separated by a comma(",").
--  Using the 'Position' function in the query to check for a "," in the 'languages' column to find whether the movie is multilingual or not.

WITH prod_company
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM   movie m
                inner join ratings r
                        ON m.id = r.movie_id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
       RANK()
         OVER(
           ORDER BY movie_count DESC) AS prod_comp_rank
FROM   prod_company
LIMIT 2; 

/*  Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits 
among multilingual movies with a movie count of 7 and 4 respectively.  */


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


/*  Creating a CTE and applying the SELECT clause with a WHERE clause to find top 3 actresses based on number of Super Hit movies
    in drama genre.  */
    
    
WITH top3_actress
     AS (SELECT n.NAME                                                     AS
                actress_name,
                Sum(total_votes)                                           AS
                   total_votes,
                Count(r.movie_id)                                          AS
                   movie_count,
                Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) AS
                   actor_avg_rating,
                RANK()
                  OVER(
                    ORDER BY Count(r.movie_id) DESC)                       AS
                   actress_rank
         FROM   names n
                INNER JOIN role_mapping rm
                        ON n.id = rm.name_id
                INNER JOIN genre g using(movie_id)
                INNER JOIN ratings r using(movie_id)
         WHERE  category = 'actress'
                AND genre = 'Drama'
                AND avg_rating > 8
         GROUP  BY NAME)
SELECT *
FROM   top3_actress
WHERE  actress_rank <= 3; 

/*  Parvathy Thiruvothu, Susan Brown, Amanda Lawrence and Denise Gough are among the top 3 actresses based on 
    the number of Super Hit movies in drama genre.  */



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH director_details
     AS (SELECT dm.name_id,
                NAME,
                dm.movie_id,
                avg_rating,
                total_votes,
                duration,
                date_published,
                Lag(date_published, 1)
                  OVER(
                    partition BY dm.name_id
                    ORDER BY date_published) AS prev_date_published
         FROM   names n
                INNER JOIN director_mapping dm
                        ON n.id = dm.name_id
                INNER JOIN movie m
                        ON dm.movie_id = m.id
                INNER JOIN ratings r
                        ON m.id = r.movie_id),
     top_dir
     AS (SELECT name_id                                                    AS
                director_id,
                NAME                                                       AS
                   director_name,
                Count(movie_id)                                            AS
                   number_of_movies,
                Round(Avg(Datediff(date_published, prev_date_published)))  AS
                avg_inter_movie_days,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
                avg_rating
                   ,
                Sum(total_votes)
                   AS total_votes,
                Round(Min(avg_rating), 1)                                  AS
                min_rating
                   ,
                Round(Max(avg_rating), 1)
                   AS max_rating,
                Sum(duration)                                              AS
                   total_duration,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC)                         AS
                   director_rank
         FROM   director_details
         GROUP  BY director_id)
SELECT director_id,
       director_name,
       number_of_movies,
       avg_inter_movie_days,
       avg_rating,
       total_votes,
       min_rating,
       max_rating,
       total_duration
FROM   top_dir
WHERE  director_rank <= 9; 

/*  The top 9 directors based on number of movies are - A.L. Vijay, Andrew Jones, Steven Soderbergh, Jesse V. Johnson, Sam Liu, 
    Sion Sono, Chris Stokes, Justin Price and  Özgür Bakar.  */




