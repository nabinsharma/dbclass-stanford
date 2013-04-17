/* Question 1: Find all students who do not appear in the Likes table
(as a student who likes or is liked) and return their names and grades.
Sort by grade, then by name within each grade.
*/
select name, grade
from highschooler
where id not in
      (select id1 from likes
      union
      select id2 from likes)
order by grade, name;


/* Question 2: For each student A who likes a student B where the
two are not friends, find if they have a friend C in common
(who can introduce them!). For all such trios, return the name
and grade of A, B, and C.
*/
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade from
       (select distinct id1_l, id2_l, id2_f from
       	       (select R.id1 as id1_l, R.id2 as id2_l, f2.id1 as id1_f, f2.id2 as id2_f from
	       	       (select l1.id1, l1.id2 from
		       	       likes l1
			       where l1.id1 not in
			       (select f1.id2 from
			       	       friend f1 where f1.id1 = l1.id2)) R,
			friend f2
			where (R.id1 = f2.id1 or R.id2 = f2.id1)) RR
		where id2_f in
		(select id2 from 
			friend where id1 = id1_l)
		and id2_f in
		(select id2 from
			friend where id1 = id2_l)) RRR,
highschooler h1,
highschooler h2,
highschooler h3
where
h1.id = RRR.id1_l and h2.id = RRR.id2_l and h3.id = RRR.id2_f;


/* Question 3: Find the difference between the number of students in the school and
the number of different first names.
*/
select count(id) - count(distinct(name))
from highschooler;


/* Question 4: What is the average number of friends per student? (Your
result should be just one number.)
*/
select sum(numFriends*1.0) / count(id) from
       (select id, (select count(id2) from
       	       	   	   (select id2 from
	       	       	       friend where id1 = id))
		as numFriends from
	highschooler);


/* Question 5: Find the number of students who are either friends with Cassandra
or are friends of friends of Cassandra. Do not count Cassandra, even though
technically she is a friend of a friend.
*/
select count(id2) from
       ((select id as id_c from
       		highschooler where name = 'Cassandra') C,
	(select id2 as id_cf from
		friend where id1 = (select id from
		       	     	   	   highschooler
					   where name = 'Cassandra')) FC,
	friend)
	where
	id1 <> id_c and id1 = id_cf;


/* Question 6: Find the name and grade of the student(s) with the greatest
number of friends.
*/
select name, grade from
       highschooler where id in
       (select id from
       	       (select id, (select count(id2) from
	       	       	   	   (select id2 from
				   	   friend where id1 = id)) as 
		numNF from
		      highschooler)
		      where numNF = 
		      (select max(nf) as maxNF from
		      	      (select id, (select count(id2) from 
			      	      (select id2 from 
			      	      	      friend where id1 = id)) as 
			       nf from
			       highschooler)));
