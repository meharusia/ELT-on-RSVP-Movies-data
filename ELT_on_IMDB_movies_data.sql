USE  imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
 
-- Table: Movie
SELECT Count(*) AS Number_of_rows_in_Movie
FROM   movie; 
    
-- Table: Genre
SELECT Count(*) AS Number_of_rows_in_Genre
FROM   genre;

-- Table: Names
SELECT Count(*) AS Number_of_rows_in_Names
FROM   names; 
    
-- Table: Director_mapping
SELECT Count(*) AS Number_of_rows_in_Director_mapping
FROM   director_mapping; 
    
-- Table: Role_mapping
SELECT Count(*) AS Number_of_rows_in_Role_mapping
FROM   role_mapping; 
    
-- Table: ratings
SELECT Count(*) AS Number_of_rows_in_Ratings
FROM   ratings; 
/*There are five tables(director_mapping, genre, movie,names,ratings, role_mapping)
 in IMDB DataBase.*/
    

-- Q2. Which columns in the movie table have null values?(country, worlwide_gross_income, languages, production_company)
-- Type your code below: 


SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS NUMBER_OF_NULL_VALUE_ID,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS NUMBER_OF_NULL_VALUE_title,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS NUMBER_OF_NULL_VALUE_year,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS NUMBER_OF_NULL_VALUE_date_published,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS NUMBER_OF_NULL_VALUE_duration,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS NUMBER_OF_NULL_VALUE_country,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS NUMBER_OF_NULL_VALUE_worldwide_gross,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS NUMBER_OF_NULL_VALUE_languages,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS NUMBER_OF_NULL_VALUE_production_company
FROM   movie;
/*Movie table has nine columns : id ,title, year, date_published date, duration, country, worlwide_gross_income, languages, production_company.


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
-- Year wise:
SELECT year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year; 

-- Month wise
SELECT Month(date_published) AS month_num,
       Count(id)             AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 
/* Total number of movies produced in the year of 2017 is relativelt more compared to
2018 and 2019.
/* Maximum number of movies are produced in the month of march.


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
-- Total Movies produced in india and USA in the year of 2019:

SELECT Count(id) AS Movies_produced_in_USA_India_2019
FROM   movie
WHERE  ( country REGEXP 'USA?'
          OR country REGEXP 'India?' )
       AND year = 2019; 


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre AS Genre_list
FROM   genre; 

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre,
       Max(total) AS genre_with_Highest_movies
FROM   (SELECT genre,
               Count(id) AS Total
        FROM   movie
               INNER JOIN genre
                       ON movie.id = movie_id
        GROUP  BY genre) AS Results; 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH movies_table_count
     AS (SELECT Count(id) AS no_of_movies
         FROM   movie AS m
                INNER JOIN genre AS g
                        ON m.id = g.movie_id
         GROUP  BY id
         HAVING Count(id) = 1)
SELECT Sum(no_of_movies) AS No_of_movies_belong_to_single_genre
FROM   movies_table_count;
 

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
       round(Avg(duration), 2) AS Avg_duration_in_minutes
FROM   movie AS m
       INNER JOIN genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY avg_duration_in_minutes DESC; 


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

SELECT*
FROM  (SELECT genre,
              Count(id) as movie_count,
              Dense_rank()
                OVER(
                  ORDER BY Count(id) DESC) AS genre_rank
       FROM   movie
              INNER JOIN genre
                      ON id = movie_id
       GROUP  BY genre) AS m
WHERE  genre = "thriller"; 
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
SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 




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


SELECT     title,
           avg_rating,
           Rank() OVER (ORDER BY avg_rating DESC) AS movie_rank
FROM       movie                                  AS m
INNER JOIN ratings                                AS r
ON         m.id = r.movie_id limit 10;




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
ORDER  BY median_rating; 




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
SELECT *
FROM   (SELECT production_company,
               Count(id)                   AS movie_count,
               Rank()
                 OVER (
                   ORDER BY Count(id) DESC)AS prod_company_rank
        FROM   (SELECT production_company,
                       id,
                       avg_rating
                FROM   movie
                       INNER JOIN ratings
                               ON id = movie_id
                WHERE  avg_rating > 8
                ORDER  BY avg_rating DESC) AS H
        GROUP  BY production_company
        HAVING production_company IS NOT NULL
        ORDER  BY movie_count DESC)AS j
WHERE  prod_company_rank = 1; 



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
SELECT genre,
       Count(movie_id) AS movie_count
FROM   genre AS g
       INNER JOIN ratings AS r using (movie_id)
       INNER JOIN movie AS m
               ON g.movie_id = m.id
WHERE  total_votes > 1000
       AND Month(date_published) = 3
       AND year = 2017
GROUP  BY genre
ORDER  BY movie_count DESC;



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
SELECT title,
       avg_rating,
       genre
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
       INNER JOIN genre AS g
               ON m.id = g.movie_id
WHERE  avg_rating > 8
       AND title REGEXP '^The'
ORDER  BY genre; 



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT Count(id) AS movies_median_rating_8_BW_2018_to_2019
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  median_rating = 8
       AND (date_published BETWEEN "2018-4-1" AND "2019-4-1");
       




-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT country,
       Sum(total_votes) AS Total_number_of_votes
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
GROUP  BY country
HAVING country IN ( 'Germany', 'Italy' ); 
/* Yes, German movies (106710) got more votes compared italian movies(77965).*/



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
SELECT Count(id) - Count(NAME)             AS name_nulls,
       Count(id) - Count(height)           AS height_nulls,
       Count(id) - Count(date_of_birth)    AS date_of_birth_nulls,
       Count(id) - Count(known_for_movies) AS known_for_movies_nulls
FROM   names; 



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

SELECT name as director_name,
       Count(r.movie_id) AS movie_count
FROM   genre AS g
       INNER JOIN ratings AS r
               ON g.movie_id = r.movie_id
       INNER JOIN director_mapping AS d
               ON g.movie_id = d.movie_id
       INNER JOIN names AS n
               ON d.name_id = n.id
WHERE  genre IN ( "drama", "action", "comedy" )
       AND avg_rating > 8
GROUP  BY name
ORDER  BY movie_count DESC
LIMIT  3; 


-- Top three genres queried below:
-- select genre, count(g.movie_id)
-- from genre as g inner join ratings as r
-- on g.movie_id = r.movie_id
-- where avg_rating > 8
-- group by genre
-- order by count(g.movie_id) desc
-- limit 3;




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
SELECT NAME              AS actor_name,
       Count(r.movie_id) AS movie_count
FROM   names AS n
       INNER JOIN role_mapping AS r
              ON n.id = r.name_id
       INNER JOIN movie AS m
               ON r.movie_id = m.id
       INNER JOIN ratings AS ra
               ON m.id = ra.movie_id
WHERE  median_rating >= 8
GROUP  BY NAME
ORDER  BY movie_count DESC
limit 2; 

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

WITH production_company_table
     AS (SELECT production_company,
                Sum(total_votes)                    AS vote_count,
                Rank()
                  OVER(
                    ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         GROUP  BY production_company)
SELECT production_company,
       vote_count,
       prod_comp_rank
FROM   production_company_table
WHERE  prod_comp_rank <= 3; 



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

SELECT NAME                                             AS actor_name,
       Sum(total_votes)                                 AS total_votes,
       Count(m.id)                                      AS movie_count,
       round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating,
       Rank()
         OVER(
           ORDER BY Sum(avg_rating*total_votes)/Sum(total_votes) DESC, Sum(
         total_votes)
         DESC)                                          AS actor_rank
FROM   names AS n
       INNER JOIN role_mapping AS r
               ON n.id = r.name_id
       INNER JOIN movie AS m
               ON r.movie_id = m.id
       INNER JOIN ratings AS ra
               ON m.id = ra.movie_id
WHERE  country = "india"
       AND category = "actor"
GROUP  BY actor_name
HAVING Count(m.id) > 4; 
/* Vijay sethupathi tops the list*/



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

SELECT NAME        AS actress_name,
       total_votes,
       Count(m.id) AS movie_count,
       round(Sum(avg_rating * total_votes) / Sum(total_votes),2) as actress_avg_rating ,
       Rank()
         OVER(
           ORDER BY Sum(avg_rating*total_votes)/Sum(total_votes) DESC ) as actress_rank
FROM   names AS n
       INNER JOIN role_mapping AS r
               ON n.id = r.name_id
       INNER JOIN movie AS m
               ON r.movie_id = m.id
       INNER JOIN ratings AS ra
               ON m.id = ra.movie_id
WHERE  category = "actress"
       AND country regexp "india"
       AND languages regexp "hindi"
GROUP  BY NAME
HAVING Count(m.id) > 2
limit 5; 




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT 
    title,
    genre,
    avg_rating,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        WHEN avg_rating < 5 THEN 'Flop movies'
    END AS movie_category
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    genre = 'Thriller'
ORDER BY avg_rating DESC;





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
       round(Avg(duration), 2)                                AS avg_duration,
       SUM(duration)
         over(
           ORDER BY genre ROWS unbounded preceding) AS "running_total_duration",
       Avg(duration)
         over (
           ORDER BY genre ROWS unbounded preceding) AS "moving_average_duration"
FROM   genre AS g
       inner join movie AS m
               ON g.movie_id = m.id
GROUP  BY genre; 
/* sum and average are used with unbounded preceeding to find running total duration and
moving average duration. 




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

WITH movie_info AS
(
           SELECT     genre,
                      year,
                      m.title AS movie_name,
                      m.worlwide_gross_income,
                      Rank() OVER( partition BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
           FROM       genre                                                               AS g
           INNER JOIN movie                                                               AS m
           ON         g.movie_id = m.id
           WHERE      genre IN ( "action",
                                "comedy",
                                "drama" )
           GROUP BY   movie_name)
SELECT genre,
       year,
       movie_name,
       CASE
              WHEN worlwide_gross_income regexp "^INR" THEN replace(worlwide_gross_income, "INR", "$")
              ELSE worlwide_gross_income
       END AS worlwide_gross_income,
       movie_rank
FROM   movie_info
WHERE  movie_rank < 6;
/*Top 3 Genres based on most number of movies are (Drama, Action, comdey). So,
where clause was used to fetch required records and also rank , Partition used also 
converted the INR values of some records into $ values for the sake of analysis even
it is irrelavant.








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
WITH production_table AS
(
           SELECT     production_company,
                      Count(m.id) AS movie_count
           FROM       movie       AS m
           INNER JOIN ratings     AS r
           ON         m.id = r.movie_id
           WHERE      median_rating >= 8
           AND        production_company IS NOT NULL
           AND        position(',' IN languages)>0
           GROUP BY   production_company
           ORDER BY   movie_count DESC)
SELECT   *,
         rank() OVER(ORDER BY movie_count DESC) AS prod_comp_rank
FROM     production_table limit 2;
/* Created CTE as Production_table and rank over movie_count in descending order*/
 






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

WITH actress_summary AS
(
           SELECT     n.NAME AS actress_name,
                      SUM(total_votes) AS total_votes,
                      Count(r.movie_id)                                     AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 AS m
           INNER JOIN ratings                                               AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS ro
           ON         m.id = ro.movie_id
           INNER JOIN names AS n
           ON         ro.name_id = n.id
           INNER JOIN GENRE AS g
           ON g.movie_id = m.id
           WHERE      category = 'ACTRESS'
           AND        avg_rating>8
           AND genre = "Drama"
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_summary LIMIT 3;
/* Created rank column over avg_rating in descending order, used inner join to merge the tables 
and limit was used to fetch top three records*/




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

WITH date_published_info AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS d_difference
       FROM   date_published_info)
SELECT   name_id                    AS director_id,
         NAME                       AS director_name,
         Count(movie_id)            AS number_of_movies,
         Round(Avg(d_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)   AS avg_rating,
         Sum(total_votes)           AS total_votes,
         Min(avg_rating)            AS min_rating,
         Max(avg_rating)            AS max_rating,
         Sum(duration)              AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;
/*Created CTE date_published_info, used inner join to merge the tables
 and then wrote a query to fetch required variables*/







