--Chris de Leon

/* 1. Find the ids of instructors who are also students using the exists construct. */

select student.id
from student 
where exists (select instructor.id 
from instructor 
where student.id = instructor.id);

/* 2. Find the names and ids of the students who have taken all the courses that are offered by their departments. 
Notice, the table course contains information about courses offered by departments.*/

select student.id, student.name
from student 
join takes 
on student.id=takes.id
join course
on takes.course_id=course.course_id
where course.dept_name = student.dept_name
group by student.id, student.name
having count(distinct takes.course_id) = 
(select count(distinct course.course_id)
from course
where dept_name = student.dept_name);

/* 3. Find the names and ids of the students who have taken exactly one course in the Fall 2017 semester. */

select student.id, student.name
from student join takes
on student.id = takes.id
where takes.semester='Fall' and takes.year=2017
group by student.id, student.name
having count(*) = 1;

/* 4. Find the names and ids of the students who have taken at most one course in the Fall 2017 semester. 
Notice, at most one means one or zero. 
So, the answer should include students who did not take any course during that semester. */

select student.id, student.name
from student
left join takes on student.id=takes.id
and takes.semester='Fall'
and takes.year=2017
group by student.id, student.name
having count(takes.course_id) <= 1;

/* 5. Write a query that uses a derived relation to find the student(s)
who have taken at least two courses in the Fall 2017 semester. 
Schema of the output should be (id, number_courses). 
Remember: derived relation means a subquery in the from clause. */

select times_taken.id, sum(times_taken.course_count) as number_courses from
(select takes.id, takes.course_id, count(*) as course_count
from takes
where takes.semester='Fall' and takes.year=2017
group by takes.id, takes.course_id) as times_taken
group by times_taken.id
having sum(times_taken.course_count) >= 2;

/* 6. Write a query that uses a scalar query in the select clause
to find the number of distinct courses that have been taught by each instructor. 
Schema of the output should be (name, id, number_courses). */

select instructor.id, instructor.name, 
(select count(distinct teaches.course_id)
from teaches
where teaches.id = instructor.id) as number_courses
from instructor;

/* 7. Write a query that uses the with clause or a derived relation to find the id 
and number of courses that have been taken by student(s) who have taken the most number of courses. 
Schema of the output should be (id, number_courses). */

with total_courses_per_student as 
(select takes.id, count(*) as number_courses
from takes
group by takes.id)

select id, number_courses
from total_courses_per_student
where number_courses = (select max(number_courses) from total_courses_per_student);