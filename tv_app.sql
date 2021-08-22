-- Section 13
-- TO be used with the tv_app database 
-- reviewers table, series tables, and reviews table.
-- MANY to MANY examples
-- BOOKS to AUTHORS 
-- BLOG POST to TAGS 
-- STUDENTS to CLASSES 

-- database name 
CREATE DATABASE tv_app;

-- reviewsers table 
CREATE TABLE reviewers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

-- series table 
CREATE TABLE series(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    released_year YEAR(4),
    genre VARCHAR(100)
);

-- reviews table 
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rating DECIMAL(2,1),
    series_id INT,
    reviewer_id INT,
    FOREIGN KEY(series_id) REFERENCES series(id),
    FOREIGN KEY(reviewer_id) REFERENCES reviewers(id)
);

-- INSERT DATA for tables 

-- series data values 
INSERT INTO series (title, released_year, genre) VALUES
    ('Archer', 2009, 'Animation'),
    ('Arrested Development', 2003, 'Comedy'),
    ("Bob's Burgers", 2011, 'Animation'),
    ('Bojack Horseman', 2014, 'Animation'),
    ("Breaking Bad", 2008, 'Drama'),
    ('Curb Your Enthusiasm', 2000, 'Comedy'),
    ("Fargo", 2014, 'Drama'),
    ('Freaks and Geeks', 1999, 'Comedy'),
    ('General Hospital', 1963, 'Drama'),
    ('Halt and Catch Fire', 2014, 'Drama'),
    ('Malcolm In The Middle', 2000, 'Comedy'),
    ('Pushing Daisies', 2007, 'Comedy'),
    ('Seinfeld', 1989, 'Comedy'),
    ('Stranger Things', 2016, 'Drama');
    
    -- reviewers data value 
    INSERT INTO reviewers (first_name, last_name) VALUES
    ('Thomas', 'Stoneman'),
    ('Wyatt', 'Skaggs'),
    ('Kimbra', 'Masters'),
    ('Domingo', 'Cortes'),
    ('Colt', 'Steele'),
    ('Pinkie', 'Petit'),
    ('Marlon', 'Crafford');
    
    -- reviews data value 
    INSERT INTO reviews(series_id, reviewer_id, rating) VALUES
    (1,1,8.0),(1,2,7.5),(1,3,8.5),(1,4,7.7),(1,5,8.9),
    (2,1,8.1),(2,4,6.0),(2,3,8.0),(2,6,8.4),(2,5,9.9),
    (3,1,7.0),(3,6,7.5),(3,4,8.0),(3,3,7.1),(3,5,8.0),
    (4,1,7.5),(4,3,7.8),(4,4,8.3),(4,2,7.6),(4,5,8.5),
    (5,1,9.5),(5,3,9.0),(5,4,9.1),(5,2,9.3),(5,5,9.9),
    (6,2,6.5),(6,3,7.8),(6,4,8.8),(6,2,8.4),(6,5,9.1),
    (7,2,9.1),(7,5,9.7),
    (8,4,8.5),(8,2,7.8),(8,6,8.8),(8,5,9.3),
    (9,2,5.5),(9,3,6.8),(9,4,5.8),(9,6,4.3),(9,5,4.5),
    (10,5,9.9),
    (13,3,8.0),(13,4,7.2),
    (14,2,8.5),(14,3,8.9),(14,4,8.9);

-- first join example 
-- combines review with the series id it is associated with 
SELECT * FROM series;

SELECT * FROM reviews;

SELECT 
title, 
rating 
FROM series
JOIN reviews 
    ON series.id = reviews.series_id;

-- second join example 
-- AVG rating, this join statement groups the data by series id and orders it by the avg rating of the show. It joins the series id to the reviews series id 
SELECT 
    title, 
    AVG(rating) AS 'Average Rating' 
    FROM series
JOIN reviews 
    ON series.id = reviews.series_id
GROUP BY series.id
ORDER BY AVG(rating);

-- third join example 
-- first name of reviewer and last name. Then, join the reviewer to all of their ratings 
SELECT * FROM reviewers;

SELECT * FROM reviews;

SELECT 
    first_name, 
    last_name, 
    rating 
FROM reviewers
JOIN reviews 
    ON reviews.id = reviews.reviewer_id;
    
-- fourth join example 
-- identify the unreviewed series 
SELECT 
    title AS 'Unreviewed series', 
    genre
FROM series 
LEFT JOIN reviews 
    ON series.id = reviews.series_id
WHERE rating IS NULL;

-- fifth join example 
-- Grab the genre of all shows, group them and average their rating. Also we get to see round in action as we round our data to 2 decimals rather than the default 4  
SELECT 
    genre, 
    ROUND(AVG(rating), 2) AS 'AVG rating'  
FROM series 
INNER JOIN reviews -- we use inner join to avoid adding the null data of series/reviews to our actual data 
    ON series.id = reviews.series_id
GROUP BY genre; 
    
-- sixth join example 
-- show our reviewers names, count their reviews, display min review, display max reviews, display avg rating, and display whether they are active or inactive reviewers. 
SELECT 
    first_name, 
    last_name, 
    COUNT(rating) AS 'Count', 
    IFNULL(MIN(rating), 0) AS 'Min', 
    IFNULL(MAX(rating), 0) AS 'max', 
    ROUND(IFNULL(AVG(rating), 0), 2) AS 'AVG',
    CASE 
        WHEN COUNT(rating) >= 10 THEN 'Power User'
        WHEN COUNT(rating) > 0 THEN 'Active'
        ELSE 'Inactive'
    END AS 'Status'
FROM reviewers 
LEFT JOIN reviews 
    ON reviewers.id = reviews.reviewer_id
GROUP BY reviewers.id;

-- Seventh join example
-- putting all 3 tables together, print the title, the rating, and then the reviewer, concat the reviewer 
SELECT 
    title,
    rating,
    CONCAT(first_name, ' ', last_name) AS 'Reviewer'
FROM reviewers
INNER JOIN reviews    
    ON reviewers.id = reviews.reviewer_id
INNER JOIN series 
    ON series.id = reviews.series_id
ORDER BY title;
