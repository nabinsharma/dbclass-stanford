/* Question 1: Find the names of all students who are friends with someone named Gabriel.
*/
select name
from highschooler where id in
(select distinct id2 from friend where id1 in
	(select id from highschooler where name = 'Gabriel'));


/* Question 2: For every student who likes someone 2 or more grades younger
than themselves, return that student's name and grade, and the name and grade
of the student they like.
*/
select distinct name, grade, name2, grade2 from
(select name, grade, id2
	from 
	likes, highschooler
	where id1 = id and 
	exists(select grade1 from
	(select grade as grade1
		from highschooler hs1
		where hs1.id = id2)
	where grade1 <= grade - 2)),
(select id, name as name2, grade as grade2
from likes, highschooler)
where id = id2;

select h1.name, h1.grade, h2.name, h2.grade from
highschooler h1,
(select id1, id2
from likes
where
(select grade from highschooler where id = id1) >=
(select grade from highschooler where id = id2) + 2) R,
highschooler h2
where h1.id = R.id1 and R.id2 = h2.id;


/* Question 3: For every pair of students who both like each other, return
the name and grade of both students. Include each pair only once, with the
two names in alphabetical order.
*/
select name3, grade3, name4, grade4 from
       (select id as id3, name as name3, grade as grade3
       	       from highschooler), 
       (select id as id4, name as name4, grade as grade4
       	       from highschooler),
       (select id1, id2
       	       from likes
	       where
	       id1 in (select id2 from likes) and
	       id2 in (select id1 from likes)
	       and id1 <> id2)
       where name3 < name4 and id3 = id1 and id4 = id2;


/* Question 4: Find names and grades of students who only have friends in the
same grade. Return the result sorted by grade, then by name within each grade.
*/
select name, grade from 
highschooler h1 
where not exists(select * from highschooler, friend 
      	  		where id = id1 and id2 = h1.id and grade <> h1.grade)
order by grade, name;


/* Question 5: Find the name and grade of all students who are liked
by more than one other student.
*/
select name, grade
from
highschooler
where id in
      (select id2
      	      from likes
	      group by id2
	      having count(distinct id1) > 1);
