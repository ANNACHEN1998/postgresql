------------------------------------------------------
-- COMP9311 24T2 Project 1 
-- SQL and PL/pgSQL 
-- Solution Template
-- Name:
-- zID:
------------------------------------------------------
-- Note: Before submission, please check your solution on the nw-syd-vxdb server using the check file.


-- Q1:
DROP VIEW IF EXISTS Q1 CASCADE;
CREATE VIEW Q1(code) as
--... SQL statements, possibly using other views/functions defined by you ...
SELECT DISTINCT subjects.code 
FROM subjects
INNER JOIN orgunits ON subjects.offeredby = orgunits.id
WHERE (subjects.longname LIKE '%database%' OR subjects.longname LIKE '%Database%')
  AND orgunits.longname = 'School of Computer Science and Engineering';

;

-- Q2:
DROP VIEW IF EXISTS Q2 CASCADE;
CREATE VIEW Q2(id) as
--... SQL statements, possibly using other views/functions defined by you ...
SELECT DISTINCT courses.id
FROM courses
INNER JOIN classes ON courses.id = classes.course
INNER JOIN class_types ON class_types.id = classes.ctype
INNER join rooms ON rooms.id = classes.room
WHERE class_types.name = 'Laboratory' AND rooms.longname ='MB-G4'

;

-- Q3:
DROP VIEW IF EXISTS Q3 CASCADE;
CREATE VIEW Q3(name) as
--... SQL statements, possibly using other views/functions defined by you ...
SELECT DISTINCT people.name
FROM people 
JOIN students ON people.id = students.id
INNER join course_enrolments ON course_enrolments.student = students.id
INNER join courses ON course_enrolments.course = courses.id
INNER join subjects ON subjects.id = courses.subject
WHERE course_enrolments.mark >= 95 AND subjects.code = 'COMP3311'


;

-- Q4:
DROP VIEW IF EXISTS Q4 CASCADE;
CREATE VIEW Q4(code) as
--... SQL statements, possibly using other views/functions defined by you ...
SELECT DISTINCT subjects.code
FROM subjects
INNER JOIN courses ON courses.subject = subjects.id
INNER JOIN classes ON classes.course = courses.id
INNER JOIN rooms ON classes.room = rooms.id
INNER JOIN room_facilities ON room_facilities.room = rooms.id
INNER JOIN facilities ON facilities.id = room_facilities.facility
WHERE facilities.description = 'Student wheelchair access'
  AND subjects.code LIKE 'COMM%'
;

-- Q5:
DROP VIEW IF EXISTS Q5 CASCADE;
CREATE VIEW Q5(unswid) as
--... SQL statements, possibly using other views/functions defined by you ...
SELECT  people.unswid
FROM people
JOIN students ON people.id = students.id
JOIN course_enrolments ON course_enrolments.student = students.id
JOIN courses ON course_enrolments.course = courses.id
JOIN subjects ON subjects.id = courses.subject
WHERE subjects.code LIKE 'COMP9%'
GROUP BY people.unswid
HAVING COUNT(*) = COUNT(CASE WHEN course_enrolments.grade = 'HD' THEN 1 END)

;

-- Q6:
DROP VIEW IF EXISTS Q6 CASCADE;
CREATE VIEW Q6(code, avg_mark) as
--... SQL statements, possibly using other views/functions defined by you ...
	
SELECT subjects.code ,ROUND(AVG(course_enrolments.mark), 2) AS avg_mark
FROM subjects 
INNER JOIN orgunits ON subjects.offeredby = orgunits.id
INNER JOIN courses ON courses.subject = subjects.id
INNER JOIN semesters ON courses.semester = semesters.id
INNER JOIN course_enrolments ON course_enrolments.course = courses.id
WHERE subjects.career = 'UG' 
AND subjects.uoc < 6 
AND orgunits.longname = 'School of Civil and Environmental Engineering' 
AND semesters.year = '2008'
AND course_enrolments.mark >= 50
GROUP BY subjects.code
ORDER BY avg_mark DESC;
 
;

-- Q7:
DROP VIEW IF EXISTS Q7 CASCADE;
CREATE VIEW Q7(student, course) as
--... SQL statements, possibly using other views/functions defined by you ...
SELECT  people.id,courses.id 
FROM people
INNER JOIN students ON people.id = students.id
INNER JOIN course_enrolments ON course_enrolments.student = students.id
INNER JOIN courses ON course_enrolments.course = courses.id
INNER JOIN subjects ON subjects.id = courses.subject
INNER JOIN semesters ON courses.semester = semesters.id
WHERE subjects.code LIKE 'COMP93%'
AND semesters.year = '2008'
AND semesters.term = 'S1'
AND course_enrolments.mark = 
(SELECT  MAX(ce.mark) 
FROM course_enrolments ce
INNER JOIN courses co ON ce.course = co.id
INNER JOIN subjects s ON s.id = co.subject
INNER JOIN semesters se ON co.semester = se.id
WHERE subjects.code LIKE 'COMP93%'
AND semesters.year = '2008'
AND semesters.term = 'S1'
AND co.id = courses.id)



;

-- Q8:
DROP VIEW IF EXISTS Q8 CASCADE;
CREATE VIEW Q8(course_id, staffs_names) as 
--... SQL statements, possibly using other views/functions defined by you ...
SELECT courses.id ,STRING_AGG(distinct people.given, ', ' ORDER BY people.given) AS staffnames
FROM courses
INNER JOIN course_enrolments ON course_enrolments.course = courses.id
INNER JOIN course_staff ON courses.id = course_staff.course
INNER JOIN staff ON staff.id = course_staff.staff
INNER JOIN people ON people.id = staff.id
WHERE people.title = 'AProf'
group by courses.id 
having count (distinct course_enrolments.student)>=650 and count(distinct staff.id)=2
;


-- Q9
DROP FUNCTION IF EXISTS Q9 CASCADE;
CREATE or REPLACE FUNCTION Q9(subject_code text) returns text
as $$
--... PL/pgSQL statements, possibly using other views/functions defined by you ...
$$ language plpgsql;


-- Q10
DROP FUNCTION IF EXISTS Q10 CASCADE;
CREATE or REPLACE FUNCTION Q10(subject_code text) returns text
as $$
--... PL/pgSQL statements, possibly using other views/functions defined by you ...
$$ language plpgsql;
