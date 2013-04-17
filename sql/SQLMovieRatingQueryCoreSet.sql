/* Question 1: Find the titles of all movies directed by Steven Spielberg.
*/
select title 
from movie
where director = 'Steven Spielberg';


/* Question 2: Find all years that have a movie that received a rating of
4 or 5, and sort them in increasing order.
*/
select distinct year
from movie, rating
where Movie.mID = Rating.mID and stars >= 4
order by year


/* Question 3: Find the titles of all movies that have no ratings.
*/
select title
from movie
where mID not in (select mID from rating);


/* Question 4: Some reviewers didn't provide a date with their rating.
Find the names of all reviewers who have ratings with a NULL value for
the date. 
*/
select name
from reviewer, rating
where reviewer.rID = rating.rID and ratingDate is null;


/* Question 5: Write a query to return the ratings data in a more
readable format: reviewer name, movie title, stars, and ratingDate.
Also, sort the data, first by reviewer name, then by movie title, and
lastly by number of stars.
*/
select name, title, stars, ratingDate
from (movie join reviewer) join rating using(mID, rID)
order by name, title, stars;


/* Question 6:
For all cases where the same reviewer rated the same movie twice and gave
it a higher rating the second time, return the reviewer's name and
the title of the movie.
*/
select name, title from
reviewer, movie,
(select r3.rid, r3.mid from
	(select * from rating where
		rid in
		(select distinct rid from rating r1 where rid in 
			(select rid from rating r2 where r2.rid = r1.rid and
			r2.mid = r1.mid group by r2.mid having count(*) = 2)) and
		mid in 
		(select distinct mid from rating r1 where rid in 
			(select rid from rating r2 where r2.rid = r1.rid and
			r2.mid = r1.mid group by r2.mid having count(*) = 2))) r3,
	(select * from rating where
		rid in
		(select distinct rid from rating r1 where rid in 
			(select rid from rating r2 where r2.rid = r1.rid
			and r2.mid = r1.mid group by r2.mid having count(*) = 2)) and
		mid in 
		(select distinct mid from rating r1 where rid in
			(select rid from rating r2 where r2.rid = r1.rid and
			r2.mid = r1.mid group by r2.mid having count(*) = 2))) r4
	where (r3.mID = r4.mID and r3.rID = r4.rID and r3.stars > r4.stars and
	r3.ratingDate > r4.ratingDate)) R
where reviewer.rid = R.rid and movie.mid = R.mid;


/* Question 7: For each movie that has at least one rating, find the highest
number of stars that movie received. Return the movie title and number of
stars. Sort by movie title.
*/
select title, maxStars
from movie,
(select mid, max(stars) as maxStars
	from rating
	group by mid) R
where movie.mid = R.mid
order by title;


/* Question 8: List movie titles and average ratings, from highest-rated to
lowest-rated. If two or more movies have the same average rating, list them
in alphabetical order.
*/
select title, avg(stars) as avgStars
from movie join rating using(mID)
group by title
order by avgStars desc;


/* Question 9: Find the names of all reviewers who have contributed three
or more ratings. (As an extra challenge, try writing the query without
HAVING or without COUNT.)
*/
select name
from reviewer join rating using(rID)
group by name
having count(*) >= 3;
