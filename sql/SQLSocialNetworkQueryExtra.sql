/* Question 1: For every situation where student A likes student B, but
student B likes a different student C, return the names and
grades of A, B, and C.
*/
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade from
(select l1.id1 as id1_l1, l1.id2 as id2_l1, l2.id1 as id1_l2, l2.id2 as id2_l2 from
	likes l1, likes l2
	where id2_l1 = id1_l2),
highschooler h1,
highschooler h2,
highschooler h3
where
id1_l1 <> id2_l2 and id1_l1 = h1.id and id2_l1 = h2.id and id2_l2 = h3.id;


/* Question 2: Find those students for whom all of their friends are in
different grades from themselves. Return the students' names and grades.
*/
select h1.name, h1.grade from
       highschooler h1
       where h1.grade not in
       (select h2.grade from
       	       highschooler h2 where h2.id in 
	       (select f1.id2 from
	       	       friend f1 where f1.id1 = h1.id));


/* Question 3: For every situation where student A likes student B, but
we have no information about whom B likes (that is, B does not appear as
an ID1 in the Likes table), return A and B's names and grades.
*/
select h1.name, h1.grade, h2.name, h2.grade from
       (select id1, id2 from
       	       likes
	       where id2 not in
	       (select id1 from likes)),
       highschooler h1,
       highschooler h2
       where
       h1.id = id1 and h2.id = id2;
