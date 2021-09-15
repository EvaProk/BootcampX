-- Get the total number of assistance_requests for a teacher.
-- Select the teacher's name and the total assistance requests.
-- Since this query needs to work with any specific teacher name, use 'Waylon Boehm' for the teacher's name here.

SELECT teachers.name as name , count(*) as total_assistance_request
FROM teachers
JOIN assistance_requests ON teacher_id = teachers.id
WHERE teachers.name = 'Waylon Boehm'
GROUP BY name;

-- Get the total number of assistance_requests for a student.
-- Select the student's name and the total assistance requests.
-- Since this query needs to work with any specific student name, use 'Elliot Dickinson' for the student's name here.

SELECT students.name as name , count(*) as total_assistance_request
FROM students
JOIN assistance_requests ON student_id = students.id
WHERE name = 'Elliot Dickinson'
GROUP BY name;

-- Select the teacher's name, student's name, assignment's name, and the duration of each assistance request.
-- Subtract completed_at by started_at to find the duration.
-- Order by the duration of the request.

SELECT teachers.name as teacher_name, students.name as student_name, assignments.name as assignment_name, completed_at::timestamp - started_at::timestamp as duration
FROM assistance_requests
JOIN students ON  students.id = student_id
JOIN teachers ON teachers.id = assistance_requests.teacher_id
JOIN assignments ON assignments.id = assistance_requests.assignment_id
ORDER by duration;


-- Get the average time of an assistance request.q
-- Select just a single row here and name it average_assistance_request_duration
-- In Postgres, we can subtract two timestamps to find the duration between them. (timestamp1 - timestamp2)

SELECT AVG(completed_at - started_at) as avg_assistance_duration
FROM assistance_requests;


-- Get the average duration of assistance requests for each cohort.
-- Select the cohort's name and the average assistance request time.
-- Order the results from shortest average to longest.

SELECT cohorts.name as cohort_name, AVG(assistance_requests.completed_at - assistance_requests.started_at) as avg_assistance_duration
FROM cohorts
JOIN students ON students.cohort_id = cohorts.id
JOIN assistance_requests ON assistance_requests.student_id = students.id
GROUP BY cohort_name
ORDER BY avg_assistance_duration;

-- Get the cohort with the longest average duration of assistance requests.
-- The same requirements as the previous query, but only return the single row with the longest average.


SELECT cohorts.name as cohort_name, AVG(assistance_requests.completed_at - assistance_requests.started_at) as avg_assistance_duration
FROM cohorts
JOIN students ON students.cohort_id = cohorts.id
JOIN assistance_requests ON assistance_requests.student_id = students.id
GROUP BY cohort_name
ORDER BY avg_assistance_duration DESC 
LIMIT 1;


-- Calculate the average time it takes to start an assistance request.
-- Return just a single column here.

SELECT AVG( started_at - created_at) as assistance_wait_time
FROM assistance_requests;

-- Get the total duration of all assistance requests for each cohort.
-- Select the cohort's name and the total duration the assistance requests.
-- Order by total_duration.
-- Look at the ERD to see how to join the tables.

SELECT cohorts.name as cohort_name, SUM(completed_at - started_at) as total_assistance_duration
FROM cohorts
JOIN students ON students.cohort_id = cohorts.id
JOIN assistance_requests ON assistance_requests.student_id = students.id
GROUP BY cohort_name
ORDER BY total_assistance_duration;

-- Calculate the average total duration of assistance requests for each cohort.
-- Use the previous query as a sub query to determine the duration per cohort.
-- Return a single row average_total_duration

SELECT AVG(total_assistance_duration) AS average_total_duration 
FROM 
(SELECT cohorts.name as cohort_name, SUM(completed_at - started_at) as total_assistance_duration
FROM cohorts
JOIN students ON students.cohort_id = cohorts.id
JOIN assistance_requests ON assistance_requests.student_id = students.id
GROUP BY cohort_name
ORDER BY total_assistance_duration) AS average_total_duration;

-- List each assignment with the total number of assistance requests with it.
-- Select the assignment's id, day, chapter, name and the total assistances.
-- Order by total assistances in order of most to least.

SELECT assignments.id as id, assignments.name as name, assignments.day as day, assignments.chapter as chapter, count(*) as total_assistancies
FROM assignments
JOIN assistance_requests ON assignment_id = assignments.id
GROUP BY assignments.id
ORDER BY total_assistancies DESC;


-- Get each day with the total number of assignments and the total duration of the assignments.
-- Select the day, number of assignments, and the total duration of assignments.
-- Order the results by the day.

SELECT day, count(assignments.id) as number_of_assignments, sum(duration) as duration
FROM assignments
GROUP By day
ORDER By day;

-- Select the instructor's name and the cohort's name.
-- Don't repeat the instructor's name in the results list.
-- Order by the instructor's name.
-- This query needs to select data for a cohort with a specific name, use 'JUL02' for the cohort's name here.

SELECT DISTINCT teachers.name as name, cohorts.name as cohort
FROM teachers
JOIN assistance_requests ON teacher_id = teachers.id
JOIN students ON assistance_requests.student_id = students.id
JOIN cohorts ON cohorts.id = students.cohort_id
WHERE cohorts.name = 'JUL02'
ORDER BY name;


-- Perform the same query as before, but include the number of assistances as well.


SELECT teachers.name as name, cohorts.name as cohort, count(assistance_requests) as total_assist
FROM teachers
JOIN assistance_requests ON teacher_id = teachers.id
JOIN students ON assistance_requests.student_id = students.id
JOIN cohorts ON cohorts.id = students.cohort_id
WHERE cohorts.name = 'JUL02'
GROUP BY teachers.name, cohorts.name
ORDER BY name;
