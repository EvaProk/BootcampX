--  Get the names of all of the students from a single cohort.
SELECT id, name
FROM students
WHERE cohort_id = 1
ORDER BY name; 

-- Select the total number of students who were in the first 3 cohorts.
SELECT COUNT(id) AS num_students
FROM students
WHERE cohort_id IN (1,2,3);

-- Get all of the students that don't have an email or phone number
SELECT id, name, cohort_id
FROM students
WHERE email IS NULL 
OR phone IS NULL;

-- Get all of the students without a gmail.com account and a phone number
SELECT id, name, email, cohort_id
FROM students
WHERE  email NOT LIKE '%@gmail.com'
AND phone IS NULL;

-- Get all of the students currently enrolled.
SELECT id, name, cohort_id
FROM students
WHERE  end_date IS NULL
ORDER BY cohort_id;

-- Get all graduates without a linked Github account
SELECT name, email, phone
FROM students
WHERE  Github IS NULL
AND end_date IS NOT NULL;

-- Get the student's name, student's start_date, cohort's name, and cohort's start_date.
-- Alias the column names to be more descriptive.
-- Order by the start date of the cohort.
SELECT students.name, cohorts.name   students.start_date as student_start_date, cohorts.start_date as cohorts_start_date
FROM students 
JOIN cohorts ON cohorts.id = cohort_name
WHERE cohorts.start_date != students.start_date
ORDER BY cohort_start_date;



