# EDA-Project-Movies
Exploratory Data Analysis Project in PostgreSQL

-- Running instructions below

This dataset, taken from https://www.kaggle.com/datasets/delfinaoliva/movies/data, contains data regarding movies.

The columns in this dataset are:
1.	Movie - Name of the film
2.	Director - Film director that controls the making of the movie and supervises the actors and technical crew
3.	Running time - The length of time in minutes of the movie
4.	Actor 1, Actor 2 and Actor 3 - Three different actors that participate in the movie
5.	Genre - Category of the film
6.	Budget - Money spent on making the movie and it's publicity
7.	Box Office - Money from ticket sales
8.	Actors Box Office % - Percentage that reflects how many times the actors managed to at least double the budget in their other films movies
9.	Director Box Office % - Percentage that reflects how many times the director managed to at least double the budget in their other films movies
10.	Earnings - Difference between box office and budget
11.	Oscars and Golden Globes nominations - Amount of nominations that the movie had in the Oscars and the Golden Globes
12.	Oscars and Golden Globes awards - Amount of awards that the movie had in the Oscars and the Golden Globes
13.	Release year - Year when the movie was first released
14.	IMDb score - Score out of 10 that is calculated from the votes of registered IMDb users on the movie

In this project, I performed an exploratory data analysis (EDA) on the movie dataset using PostgreSQL.
I utilized CTEs and window functions to generate insightful queries, uncovering trends in genre profitability, conducting comparisons between genres, directors, years, awards, etc.

Attached are the project file and the csv file contains the dataset.

Running instructions:
1. Download both csv file and SQL file to a specific folder in your computer. 
2. Run the CREATE TABLE query which creates the 'movies_data' table.
3. Run the COPY query in order to import the data from the csv file into the table. Make sure to write the correct file location in the FROM clause.
   
