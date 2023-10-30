import logging

from faker import Faker
import random
import psycopg2
from psycopg2 import DatabaseError

STUDENTS = 500
GROUPS = 10
SUBJECTS = 16
TEACHERS = 8
GRADES = 8

fake = Faker()

# Підключення до бази даних
conn = psycopg2.connect(host="localhost", database="hw-06", user="postgres", password="123qwe")
cur = conn.cursor()

# Додавання груп
for _ in range(GROUPS):
    # Увага! Аргумент - кортеж!
    cur.execute("INSERT INTO groups (name) VALUES (%s)", (fake.word(),))

# Додавання викладачів
for _ in range(TEACHERS):
    # Увага! Аргумент - кортеж!
    cur.execute("INSERT INTO teachers (fullname) VALUES (%s)", (fake.name(),))

# Додавання предметів із вказівкою викладача
for teacher_id in range(1, TEACHERS + 1):
    " по 2 предмети на кожного викладача "
    for _ in range(1, int(SUBJECTS / TEACHERS + 1)):
        cur.execute("INSERT INTO subjects (name, teacher_id) VALUES (%s, %s)", (fake.word(), teacher_id))

# Додавання студентів і оцінок
" WOW! Перший раз зтикаюся з циклом [for] 4-ого (!) порядку! "
# Беремо групу з [group_id], виділяємо до неї 50 студентів, до кожного студента відносимо предмет з [subject_id]
# та по кожному предмету заповнюємо [GRADES] -> 8 оцінок 
for group_id in range(1, GROUPS + 1):
    " по 50 студентiв у групi" 
    for _ in range(int(STUDENTS / GROUPS)):
        cur.execute("INSERT INTO students (fullname, group_id) VALUES (%s, %s) RETURNING id",
                    (fake.name(), group_id))
        student_id = cur.fetchone()[0]
        for subject_id in range(1, SUBJECTS + 1):
            for _ in range(GRADES):
                cur.execute("INSERT INTO grades (student_id, subject_id, grade, grade_date) VALUES (%s, %s, %s, %s)",
                            (student_id, subject_id, random.randint(0, 100), fake.date_this_decade()))
                
""" Таким чином 8 оцiнок по кожному з 16 предметiв в кожного з 500 студентв буде вiдображено у таблицi [grades] -> 64_000 записiв """

try:
    # Збереження змін
    conn.commit()
except DatabaseError as err:
    logging.error(err)
    conn.rollback()
finally:
    # Закриття підключення
    cur.close()
    conn.close()
