import psycopg
from db_config import DB_CONFIG

### ========================== Users
def seed_app_users():
    users = [
        ("Nathan Darby", "student@example.com", "student_pass", "student"),
        ("Grader User", "grader@example.com", "grader_pass", "grader"),
        ("Admin User", "admin@example.com", "admin_pass", "admin"),
        ("AI Agent", "ai@system.local", "ai_pass", "ai"),
    ]

    with psycopg.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM Student_Profile")
            cur.execute("DELETE FROM Grader_Profile")
            cur.execute("DELETE FROM App_User")
            cur.execute("ALTER SEQUENCE app_user_user_id_seq RESTART WITH 1")
            cur.executemany(
                "INSERT INTO App_User (name, email, password_hash, role) VALUES (%s, %s, %s, %s)",
                users
            )
        conn.commit()
        print("App Users seeded successfully.")

def seed_student_profile():
    student = [
        (1, "UCSB", "Statistics", 2, 3.85),
    ]

    with psycopg.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM Student_Profile")
            cur.executemany(
                "INSERT INTO Student_Profile (user_id, school, major, year, gpa) VALUES (%s, %s, %s, %s, %s)",
                student
            )
        conn.commit()
        print("Student Profile seeded successfully.")

def seed_grader_profile():
    grader = [
        (2, "ta", "Mathematics", 3),
    ]

    with psycopg.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM Grader_Profile")
            cur.executemany(
                "INSERT INTO Grader_Profile (user_id, title, department, years_experience) VALUES (%s, %s, %s, %s)",
                grader
            )
        conn.commit()
        print("Grader Profile seeded successfully.")

### ========================== Core Contents
def seed_subjects():
    subjects = [
        ("Mathematics", "Undergraduate level math"),
        ("Physics", "Basic concepts in classical mechanics"),
    ]

    with psycopg.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            # Optional: clear the table first
            cur.execute("DELETE FROM Subject")
            cur.execute("ALTER SEQUENCE subject_subject_id_seq RESTART WITH 1")
            # Insert new rows
            cur.executemany(
                "INSERT INTO Subject (name, description) VALUES (%s, %s)",
                subjects
            )

        conn.commit()
        print("Subjects seeded successfully.")
def seed_branches():
    branches = [
        # subject_id = 1 Mathematics, subject_id 2 = Physics
        (1, "Discrete Math", "Finite and/or countable mathematical structures"),
        (1, "Geometry", "Shapes and proofs"),
        (2, "Mechanics", "Newton's laws and motion"),
    ]

    with psycopg.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM Branch")
            cur.execute("ALTER SEQUENCE branch_branch_id_seq RESTART WITH 1")
            cur.executemany(
                "INSERT INTO Branch (subject_id, name, description) VALUES (%s, %s, %s)",
                branches
            )
        conn.commit()
        print("Branches seeded successfully.")
def seed_domains():
    domains = [
        # branch_id 1 = Discrete Math, 2 = Geometry, 3 = Mechanics
        (1, "Logic and Proofs", "Foundations of reasoning and argument structure"),
        (1, "Set Notation", "Represent collections of elements"),
        (3, "Newton's Laws", "Force and motion")
    ]

    with psycopg.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM Domain")
            cur.execute("Alter SEQUENCE domain_domain_id_seq RESTART WITH 1")
            cur.executemany(
                "INSERT INTO DOMAIN (branch_id, name, description) VALUES (%s, %s, %s)",
                domains
            )
        conn.commit()
        print("Domains seeded successfully.")
def seed_content():
    content = [
        # domain_id 1 = Logic and Proofs
        (1, "PSTAT 8: Second Midterm", "Understanding logic rules and induction proofs",
         "Identify valid/invalid arguments", "Follow the steps to classify each proof", 2),
        (1, "Math 8: First Midterm", "Truth Tables",
         "Use a truth table to analyze the statement", "Complete and analyze truth tables", 2),
    ]

    with psycopg.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM Content")
            cur.execute("ALTER SEQUENCE content_content_id_seq RESTART WITH 1")
            cur.executemany(
                """INSERT INTO Content 
                   (domain_id, title, description, learning_objectives, instructions, created_by)
                   VALUES (%s, %s, %s, %s, %s, %s)""",
                content
            )
        conn.commit()
        print("Content seeded successfully.")
def seed_questions():
    questions = [
        # content_id 1 = PSTAT 8: Second Midterm
        (1, 1, "Is this argument valid? Justify your answer.", "proof", "Uses valid rules of inference", "Recognize valid/invalid forms", 5.0),
        (1, 2, "Explain the structure of a direct proof.", "explanation", "Clarity and logical flow", "Understand proof structure", 3.0),
        # content_id 2 = Math 8: First Midterm
        (2, 1, "Build a truth table for A ∧ B", "computation", "Correct values in all rows", "Practice truth table logic", 2.0),
    ]

    with psycopg.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM Question")
            cur.execute("ALTER SEQUENCE question_question_id_seq RESTART WITH 1")
            cur.executemany(
                """INSERT INTO Question
                   (content_id, question_number, prompt, content_type, rubric, learning_objectives, points_possible)
                   VALUES (%s, %s, %s, %s, %s, %s, %s)""",
                questions
            )
        conn.commit()
        print("Questions seeded successfully.")


if __name__ == "__main__":
    seed_app_users()
    seed_student_profile()
    seed_grader_profile()
    seed_subjects()
    seed_branches()
    seed_domains()
    seed_content()
    seed_questions()
