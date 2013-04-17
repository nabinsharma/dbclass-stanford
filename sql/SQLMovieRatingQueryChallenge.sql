/* Question 1: For each movie, return the title and the 'rating spread', that is, the
difference between highest and lowest ratings given to that movie. Sort by rating
spread from highest to lowest, then by movie title.
*/
select title, max(stars) - min(stars) as ratingSpread from
movie join rating using(mID)
group by title
order by ratingSpread desc, title;


/* Question 2: Find the difference between the average rating of movies
released before 1980 and the average rating of movies released after 1980.
(Make sure to calculate the average rating for each movie, then the average
of those averages for movies before 1980 and movies after. Don't just
calculate the overall average rating before and after 1980.)
*/
select B.superAvg - A.superAvg
from
(select avg(avgStars) as superAvg
	from
	(select mID, year, avg(stars) as avgStars
		from
		movie join rating using(mID)
		group by mID)
	where year < 1980) as B,
(select avg(avgStars) as superAvg
	from
	(select mID, year, avg(stars) as avgStars
		from
		movie join rating using(mID)
		group by mID)
	where year > 1980) as A;


/* Question 3: Some directors directed more than one movie. For all such
directors, return the titles of all movies directed by them, along with
the director name. Sort by director name, then movie title. (As an extra
challenge, try writing the query both with and without COUNT.)
*/
select title, director
from
movie
where director in
      (select director
      from movie
      group by director
      having count(*) > 1)
order by director, title;

select title, director
from movie m1
where
director in
	 (select director
	 from movie m2
	 where
	 m2.title <> m1.title)
order by director, title;


/* Question 4: Find the movie(s) with the highest average rating. Return
the movie title(s) and average rating. (Hint: This query is more difficult
to write in SQLite than other systems; you might think of it as finding
the highest average rating and then choosing the movie(s) with that
average rating.)
*/
select title, avgStars
from 
(select title, avg(stars) as avgStars
	from
	movie join rating using(mID)
	group by title)
where
avgStars = 
(select max(avgStars)
	from
	(select title, avg(stars) as avgStars
	from
	movie join rating using(mID)
	group by title));


/* Question 5: Find the movie(s) with the lowest average rating. Return
the movie title(s) and average rating. (Hint: This query may be more
difficult to write in SQLite than other systems; you might think of
it as finding the lowest average rating and then choosing the movie(s)
with that average rating.)
*/
select title, avgStars
from 
(select title, avg(stars) as avgStars
	from
	movie join rating using(mID)
	group by title)
where
avgStars = 
(select min(avgStars)
	from
	(select title, avg(stars) as avgStars
	from
	movie join rating using(mID)
	group by title));


/* Question 6: For each director, return the director's name together with
the title(s) of the movie(s) they directed that received the highest
rating among all of their movies, and the value of that rating. Ignore
movies whose director is NULL.
*/
select distinct director, title, stars
from
(movie join rating using(mID)) MR1
where director is not null and
      MR1.stars >= (select max(stars) from (movie join rating using(mID)) MR2
      		   	   where MR2.director = MR1.director);
