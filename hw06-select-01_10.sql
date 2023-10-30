" Запит 1.
  5 студентів із найбільшим середнім балом з усіх предметів. "
SELECT 
    s.id, 
    s.fullname, 
    ROUND(AVG(g.grade), 2) AS average_grade
FROM students AS s
JOIN grades AS g ON s.id = g.student_id
GROUP BY s.id
ORDER BY average_grade DESC
LIMIT 5;



" Запит 2.1.
  Студент із найвищим середнім балом з певного предмета. "
SELECT 
    s.id, 
    s.fullname,
    g.subject_id,
    ROUND(AVG(g.grade), 2) AS average_grade
FROM grades AS g
JOIN students AS s ON s.id = g.student_id
where g.subject_id = 1
GROUP BY s.id, g.subject_id
ORDER BY average_grade desc
limit 1;

" Запит 2.2.
  Перші 5 студентів із найвищим середнім балом з кожного предмета. "
WITH RankedStudents AS (
    SELECT
        s.id AS student_id,
        s.fullname AS student_name,
        g.subject_id,
        ROUND(AVG(g.grade), 3) AS average_grade,
        RANK() OVER (PARTITION BY g.subject_id ORDER BY ROUND(AVG(g.grade), 3) DESC) AS ranking
    FROM
        students AS s
    JOIN
        grades g ON s.id = g.student_id
    GROUP BY
        s.id, s.fullname, g.subject_id
)
SELECT
    rs.subject_id,
    s.name AS subject_name,
    rs.student_id,
    rs.student_name,
    rs.average_grade
FROM
    RankedStudents AS rs
JOIN
    subjects AS s ON rs.subject_id = s.id
WHERE
    rs.ranking <= 5
ORDER BY
    rs.subject_id, rs.ranking;

" Спрощення? "
WITH StudentsAVGSubjects AS (
    SELECT
        s.id AS student_id,
        s.fullname AS student_name,
        g.subject_id,
        ROUND(AVG(g.grade), 3) AS average_grade,
        ROW_NUMBER() OVER (PARTITION BY g.subject_id ORDER BY ROUND(AVG(g.grade), 3) DESC) AS row_num
    FROM
        students AS s
    JOIN
        grades AS g ON s.id = g.student_id
    GROUP BY
        s.id, g.subject_id
    ORDER BY s.id, average_grade DESC
)
SELECT
    sas.subject_id,
    s.name AS subject_name,
    sas.student_id,
    sas.student_name,
    sas.average_grade
FROM
    StudentsAVGSubjects AS sas
JOIN
    subjects AS s ON sas.subject_id = s.id
WHERE row_num <= 5
ORDER BY
    sas.subject_id, sas.average_grade DESC;



" Запит 3.1.
  Середній бал у групах з певного предмета. "
SELECT
    groups.id,
    groups.name AS group_name,
    ROUND(AVG(grades.grade), 2) AS average_grade
FROM
    groups
JOIN
    students ON groups.id = students.group_id
JOIN
    grades ON students.id = grades.student_id
WHERE
    grades.subject_id = 10
GROUP BY
    groups.id, groups.name
order by groups.id;

" Запит 3.2.
  Середній бал по кожній групі зі всіх предметів. "
SELECT
    groups.name AS group_name,
    ROUND(AVG(grades.grade), 2) AS average_grade
FROM
    groups
JOIN
    students ON groups.id = students.group_id
JOIN
    grades ON students.id = grades.student_id
WHERE
    grades.subject_id IN (
        SELECT subjects.id
        FROM subjects
    )    
GROUP BY
     grades.subject_id, groups.name
order by groups.name, average_grade DESC;



" Запит 4.
  Середній бал на потоці (по всій таблиці оцінок). "
SELECT ROUND(AVG(grades.grade), 2) AS average_grade
FROM grades;



" Запит 5.1.
  Які курси на потоці читає певний викладач. "
SELECT
    subjects.name AS course_name
FROM
    subjects
WHERE
    subjects.teacher_id = 5;

" Запит 5.2.
  Які курси на потоці читає кожний викладач. "
SELECT
    teachers.fullname AS teacher_name,
    subjects.name AS course_name
FROM
    teachers
JOIN
    subjects ON teachers.id = subjects.teacher_id;



" Запит 6.
  Cписок студентів у певній групі. "
SELECT
    students.id,
    students.fullname AS student_name
FROM
    students
WHERE
    students.group_id = 7;



" Запит 7.
  Оцінки студентів у окремій групі з певного предмета. "
SELECT
    students.id,
    students.fullname AS student_name,
    grades.grade
FROM
    students
JOIN
    grades ON students.id = grades.student_id
WHERE
    students.group_id = 8
    AND grades.subject_id = 10;



" Запит 8.1.
  Середній бал, який ставить певний викладач зі своїх предметів. "
SELECT
    teachers.id,
    teachers.fullname AS teacher_name,
    ROUND(AVG(grades.grade), 2) AS average_grade
FROM
    teachers
JOIN
    subjects ON teachers.id = subjects.teacher_id
JOIN
    grades ON subjects.id = grades.subject_id
WHERE
    teachers.id = 5
GROUP BY
    teachers.id;

" Запит 8.2.
  Cередні бали, які ставить кожний викладач по кожному зі своїх предметів. "
SELECT
    teachers.id,
    teachers.fullname AS teacher_name,
    subjects.name AS course_name,
    ROUND(AVG(grades.grade), 2) AS average_grade
FROM
    teachers
JOIN
    subjects ON teachers.id = subjects.teacher_id
JOIN
    grades ON subjects.id = grades.subject_id
GROUP BY
    teachers.id, subjects.name;



" Запит 9.
  Cписок курсів, які відвідує студент. "
SELECT
    DISTINCT
    students.id,
    students.fullname,
    subjects.name AS course_name
FROM
    students
JOIN
    grades ON students.id = grades.student_id
JOIN
    subjects ON grades.subject_id = subjects.id
WHERE
    students.id = 186;



" Запит 10.1.
  Cписок курсів, які певному студенту читає певний викладач. "
SELECT
    DISTINCT
    students.id,
    students.fullname,
    subjects.name AS course_name,
    teachers.fullname as teacher
FROM
    students
JOIN
    grades ON students.id = grades.student_id
JOIN
    subjects ON grades.subject_id = subjects.id
JOIN
    teachers ON subjects.teacher_id = teachers.id
WHERE
    students.id = 333 AND teachers.id = 4;



" Запит 10.2.
  Cписок курсів, які певному студенту читають всі викладачі. "
SELECT
    DISTINCT 
    students.id,
    students.fullname,
    subjects.name AS course_name,
    teachers.fullname as teacher
FROM
    students
JOIN
    grades ON students.id = grades.student_id
JOIN
    subjects ON grades.subject_id = subjects.id
JOIN
    teachers ON subjects.teacher_id = teachers.id
WHERE
    students.id = 444
ORDER BY
    teacher;