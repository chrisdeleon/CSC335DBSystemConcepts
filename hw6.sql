-- 1. Find the number of students in each department. 
-- Rename the second attribute in the output as number_students. 
-- This means the schema of the output is (dept_name, number_students).

select dept_name, count(*) as number_students
from student
group by dept_name;

-- 2. [20 points] For departments that have at least three students, 
-- find department name and number of students. 
-- Rename the second attribute in the output as number_students.
-- Remark: this question is similar to the previous one
-- but the output lists only department that has at least three students.

select dept_name, count(*) as number_students
from student
group by dept_name
having count(*) >= 3;

-- 3. Find the ids of instructors who are also students using a set operation.
-- Assume that a person is identified by her or his id. 
-- So, if the same id appears in both instructor and student, 
-- then that person is both an instructor and a student. 
-- Remember: set operation means union, intersect or set difference.

select id
from instructor
intersect
select id
from student;

-- 4. Find the ids of instructors who are also students using the set membership operator.

select id
from instructor
where id in (select id
             from student);