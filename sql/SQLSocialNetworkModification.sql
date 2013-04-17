/* Question 1: It's time for the seniors to graduate. Remove all
12th graders from Highschooler.
*/
delete from highschooler
       where grade = 12;


/* Question 2: If two students A and B are friends, and A likes B
but not vice-versa, remove the Likes tuple.
*/
delete from likes
       where id1 in
       (select id1 from
       	       (select l1.id1, l1.id2 from
	       	       friend f1, likes l1
		       where l1.id1 = f1.id1 and l1.id2 = f1.id2
		       and
		       l1.id1 not in
		       (select l2.id2 from
		       	       likes l2 where l2.id1 = l1.id2)));


/* Question 3: For all cases where A is friends with B, and B is friends with C,
add a new friendship for the pair A and C. Do not add duplicate friendships,
friendships that already exist, or friendships with oneself.
*/
insert into friend
       select * from
       	      (select distinct f1.id1, f2.id2 from
	      	      friend f1, friend f2
		      where
		      f1.id2 = f2.id1 and f2.id2 <> f1.id1)
       except
       select id1, id2 from
       	      (select id1, id2 from
	      	      friend
	      intersect

	      select distinct f1.id1, f2.id2 from
	      	     friend f1, friend f2
		     where
		     f1.id2 = f2.id1 and f2.id2 <> f1.id1);
