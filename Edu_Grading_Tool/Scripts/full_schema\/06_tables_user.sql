-- 06_tables_user.sql
-- AI Grading Tool - FRAM-Based Schema
-- Core tables: App_User, Student_Profile, Grader_Profile 
-- Created: 2024-4-21
-- Author: Nathan Darby

DROP TABLE IF EXISTS App_User CASCADE;
DROP TABLE IF EXISTS Student_Profile CASCADE;
DROP TABLE IF EXISTS Grader_Profile CASCADE;
DROP TYPE IF EXISTS user_role CASCADE;
DROP TYPE IF EXISTS title CASCADE;


-- === User_Role Type ===
CREATE TYPE user_role AS ENUM (
	'student',
	'grader',
	'admin',
	'ai'
);
--

-- === Title type ===
CREATE TYPE title AS ENUM (
	'ta',
    'professor',
    'postdoc',
    'undergraduate',
    'external reviewer'
);

-- === App_User Table ===
CREATE TABLE App_User (
	user_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	email TEXT UNIQUE NOT NULL,
	password_hash TEXT NOT NULL,
	role user_role NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 

);

-- === Student_Profile Table === 
CREATE TABLE Student_Profile (
    user_id INTEGER PRIMARY KEY REFERENCES App_User(user_id),
    school TEXT,
    major TEXT,
    year INTEGER,
    gpa DECIMAL (3,2) 

);

-- === Grader_Profile === 
CREATE TABLE Grader_Profile (
    user_id INTEGER PRIMARY KEY REFERENCES App_User(user_id),
    title title NOT NULL,
    department TEXT,
    years_experience INTEGER
    
);