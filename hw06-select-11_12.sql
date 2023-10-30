" Запит 11.1.
  Середній бал, який певний викладач ставить певному студентові. "
SELECT
    students.id,
    students.fullname,
    teachers.fullname AS teacher,
    ROUND(AVG(grades.grade), 3) AS average_grade
FROM
    students
JOIN
    grades ON students.id = grades.student_id
JOIN
    subjects ON grades.subject_id = subjects.id
JOIN
    teachers ON subjects.teacher_id = teachers.id
WHERE
    students.id = 313
    AND subjects.teacher_id = 5
GROUP BY
    students.id, teachers.fullname;

" Запит 11.2.
  Середні бали, які певному студентові ставить кожен викладач. "
SELECT
    students.id,
    students.fullname,
    subjects.teacher_id,
    teachers.fullname AS teacher,
    ROUND(AVG(grades.grade), 3) AS average_grade
FROM
    students
JOIN
    grades ON students.id = grades.student_id
JOIN
    subjects ON grades.subject_id = subjects.id
JOIN
    teachers ON subjects.teacher_id = teachers.id
WHERE
    students.id = 255
GROUP BY
    students.id, subjects.teacher_id, teachers.fullname;



" Запит 12.
  Оцінки студентів у певній групі з певного предмета на останньому занятті. "
SELECT
    students.id,
    students.fullname AS student_name,
    subjects.name,
    grades.grade,
    grades.grade_date
FROM
    students
JOIN
    grades ON students.id = grades.student_id
JOIN
    subjects ON grades.subject_id = subjects.id
WHERE
    students.group_id = 9
    AND subjects.id = 2
    AND grades.grade_date = (
        SELECT
            MAX(grade_date)
        FROM
            grades
        WHERE
            student_id = students.id
            AND subject_id = 2
    );