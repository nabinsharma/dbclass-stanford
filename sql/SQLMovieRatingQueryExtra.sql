/* Question 1: Find the names of all reviewers who rated Gone with the Wind.
*/
select distinct name
from
reviewer join (movie join rating using(mID)) using (rID)
where title = 'Gone with the Wind';


/* Question 2: For any rating where the reviewer is the same as the
director of the movie, return the reviewer name, movie title, and
number of stars.
*/
select distinct name, title, stars
from
reviewer join (movie join rating using(mID)) using (rID)
where name = director;


/* Question 3: Return all reviewer names and movie names together in a
single list, alphabetized. (Sorting by the first name of the reviewer
and first word in the title is fine; no need for special processing on
last names or removing "The".)
*/
select name from reviewer
union
select title from movie;



/* Question 4: Find the titles of all movies not reviewed by Chris Jackson.
*/
select title
from movie
except
select title
from movie join rating using(mID)
where rID in (select rID
      	     	     from reviewer
		     where name = 'Chris Jackson');


/* Question 5: For all pairs of reviewers such that both reviewers gave a
rating to the same movie, return the names of both reviewers. Eliminate
duplicates, don't pair reviewers with themselves, and include each pair
only once. For each pair, return the names in the pair in alphabetical order.
*/
select distinct r1.name, r2.name
from (reviewer join rating using(rID)) r1,
     (reviewer join rating using(rID)) r2
where r1.mID = r2.mID and r1.name < r2.name;


/* Question 6: For each rating that is the lowest (fewest stars) currently
in the database, return the reviewer name, movie title, and number of stars.
*/
select name, title, stars
from
(reviewer join movie) R1,
(select *
	from rating
	where stars = (select min(stars) from rating)) R2
where R1.rID = R2.rID and R1.mID = R2.mID;
