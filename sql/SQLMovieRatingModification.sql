/* Question 1: Add the reviewer Roger Ebert to your database, with
an rID of 209.
*/
insert into reviewer values(209, 'Roger Ebert');


/* Question 2: Insert 5-star ratings by James Cameron for all movies
in the database. Leave the review date as NULL.
*/
insert into rating
select (select rID from reviewer where name = 'James Cameron') as rID,
       mID, 5 as stars,
       null as ratingDate
       from
       movie;


/* Question 3: For all movies that have an average rating of 4 stars
or higher, add 25 to the release year. (Update the existing tuples;
don't insert new tuples.)
*/
update movie
set year = year + 25
    where mID in
    (select mID from
    	    rating
	    group by mID
	    having avg(stars) >= 4.0);


/* Question 4: Remove all ratings where the movie's year is before 1970
or after 2000, and the rating is fewer than 4 stars.
*/
delete from rating
       where
       stars < 4 and
       mID in (select mID from
       	      	      movie where year < 1970 or year > 2000);
