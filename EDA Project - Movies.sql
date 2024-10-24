CREATE TABLE IF NOT EXISTS public.movies_data
(
    movie text ,
    director text ,
    running_time integer,
    actor_1 text,
    actor_2 text,
    actor_3 text,
    genre text,
    budget bigint,
    box_office bigint,
    actors_box_office double precision,
    director_box_office double precision,
    earnings bigint,
    oscar_and_golden_globes_nominations integer,
    oscar_and_golden_globes_awards integer,
    release_year integer,
    imdb_score double precision
)

SELECT * FROM movies_data;

COPY movies_data(movie, director, running_time, actor_1, actor_2, actor_3, genre, budget, box_office, actors_box_office,
				director_box_office, earnings, oscar_and_golden_globes_nominations, oscar_and_golden_globes_awards, release_year, imdb_score)
FROM 'D:\Data Analyst\PostgreSQL EDA Project - Movies\movies_data.csv'
DELIMITER ','
CSV HEADER;

-- Basic queries:

-- Three most profitable movie
SELECT movie, earnings
FROM movies_data
ORDER BY earnings DESC
LIMIT 3;


-- Three least profitable movie
SELECT movie, earnings
FROM movies_data
ORDER BY earnings DESC
LIMIT 3;


-- Three most budgeted movies
SELECT movie, budget
FROM movies_data
ORDER BY budget
LIMIT 3;


-- Three most profitable directors
SELECT director, SUM(earnings) total_earnings
FROM movies_data
GROUP BY director
ORDER BY total_earnings DESC
LIMIT 3;


-- Three least profitable directors
SELECT director, SUM(earnings) total_earnings
FROM movies_data
GROUP BY director
ORDER BY total_earnings
LIMIT 3;


-- Ten longest movies and their earnings
SELECT movie, running_time, earnings
FROM movies_data
ORDER BY running_time DESC
LIMIT 10;


-- Total movies, budgets, earnings, awards and average runtime per genre
SELECT genre, COUNT(*) total_movies, SUM(budget) total_budgets, SUM(earnings) total_earnings,
		SUM(oscar_and_golden_globes_awards) total_awards, AVG(running_time) runtime, AVG(imdb_score) average_imdb_score
FROM movies_data
GROUP BY genre
ORDER BY total_earnings DESC;


-- Ratio between nominations and awards per genre
SELECT genre, ROUND(cast(SUM(oscar_and_golden_globes_awards) as decimal)/SUM(oscar_and_golden_globes_nominations), 3) ratio
FROM movies_data
GROUP BY genre
HAVING SUM(oscar_and_golden_globes_nominations) > 0
ORDER BY ratio DESC;


-- Ratio between nominations and awards per director
SELECT director, SUM(oscar_and_golden_globes_awards) total_awards, 
		ROUND(cast(SUM(oscar_and_golden_globes_awards) as decimal)/SUM(oscar_and_golden_globes_nominations), 3) ratio
FROM movies_data
GROUP BY director
HAVING SUM(oscar_and_golden_globes_nominations) > 0
ORDER BY total_awards DESC;


-- Comparing between total budgets, total box offices and total earnings through the years
SELECT release_year, SUM(budget) total_budgets, SUM(box_office) total_box_offices,
		SUM(earnings) total_earnings, ROUND(CAST(AVG(imdb_score) as numeric), 2) average_imdb_score
FROM movies_data
GROUP BY release_year
ORDER BY release_year;


-- Number of directorials of each director
SELECT director, COUNT(*) directorials
FROM movies_data
GROUP BY director
ORDER BY directorials DESC;


-- Awards-winning movies, with negative profit
SELECT movie, oscar_and_golden_globes_awards, imdb_score, earnings
FROM movies_data
WHERE oscar_and_golden_globes_awards > 0 AND earnings < 0
ORDER BY oscar_and_golden_globes_awards desc, earnings;


-- Awards-less movies with the highest imdb score
SELECT movie, oscar_and_golden_globes_awards, imdb_score, earnings
FROM movies_data
WHERE oscar_and_golden_globes_awards = 0
ORDER BY imdb_score DESC;


-- Comparison between imdb score and earnings
SELECT movie, imdb_score, earnings
FROM movies_data
ORDER BY imdb_score DESC;


-- Number of movies and total budgets in each year
SELECT release_year, COUNT(*) total_movies, SUM(budget) total_budgets
FROM movies_data
GROUP BY release_year
ORDER BY release_year;


-- Complex queries:

-- Number of appearances of each actor
WITH actors_list AS
(
	SELECT actor_1 actor
	FROM movies_data
	UNION ALL
	SELECT actor_2
	FROM movies_data
	UNION ALL
	SELECT actor_3
	FROM movies_data
)
SELECT actor, COUNT(actor) total_appearances
FROM actors_list
GROUP BY actor
ORDER BY total_appearances DESC;


-- Rolling total of earnings of directors over the years
WITH tmp AS
(
	SELECT director, release_year, SUM(earnings) earnings
	FROM movies_data
	GROUP BY director, release_year
)
SELECT director, release_year, SUM(earnings) OVER(PARTITION BY director ORDER BY release_year) cumulative_earnings
FROM tmp
WHERE director IN (SELECT director FROM movies_data GROUP BY director HAVING COUNT(*) > 10);


-- Rolling total of earnings of genres over the years
WITH tmp AS
(
	SELECT genre, release_year, SUM(earnings) earnings
	FROM movies_data
	GROUP BY genre, release_year
)
SELECT genre, release_year, SUM(earnings) OVER(PARTITION BY genre ORDER BY release_year) cumulative_earnings
FROM tmp;


-- Five most profitable movies each year
WITH ranked_table AS
(
	SELECT *, DENSE_RANK() OVER(PARTITION BY release_year ORDER BY earnings DESC) rank_tmp
	FROM movies_data
)
SELECT movie, release_year, earnings
FROM ranked_table
WHERE rank_tmp <= 5
ORDER BY release_year, earnings DESC;


-- Three most profitable genres each year
WITH genre_yearly_earning AS
(
	SELECT genre, release_year, SUM(earnings) earnings
	FROM movies_data
	GROUP BY genre, release_year
	ORDER BY release_year
), genre_yearly_earning_ranked AS
(
	SELECT *, DENSE_RANK() OVER(PARTITION BY release_year ORDER BY earnings DESC) rank_tmp
	FROM genre_yearly_earning
)
SELECT genre, release_year, earnings
FROM genre_yearly_earning_ranked
WHERE rank_tmp <= 3
ORDER BY release_year DESC, earnings DESC;








