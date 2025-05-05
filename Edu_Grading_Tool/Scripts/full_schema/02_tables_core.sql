-- 02_tables_core.sql
-- AI Grading Tool - FRAM-Based Schema
-- Core tables: Subject, Branch, Domain, Content, Questions, Submission, Submission_answers 
-- Created: 2024-4-21
-- Author: Nathan Darby

-- === DROP TABLES FOR CLEAN RESET (DEV ONLY) ===
DROP TABLE IF EXISTS Submission_Answer CASCADE;
DROP TABLE IF EXISTS Submission CASCADE;
DROP TABLE IF EXISTS Student CASCADE;
DROP TABLE IF EXISTS Question CASCADE;
DROP TABLE IF EXISTS Content CASCADE;
DROP TABLE IF EXISTS Domain CASCADE;
DROP TABLE IF EXISTS Branch CASCADE;
DROP TABLE IF EXISTS Subject CASCADE;
DROP TYPE IF EXISTS content_type CASCADE;

-- === ENUM TYPES ===
CREATE TYPE content_type AS ENUM (
	'proof',						
	'explanation',
	'computation',
	'derivation',
	'multiple_choice' 
);


-- === Subject Table === (MVP: Mathematics)
CREATE TABLE Subject (
	subject_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	description TEXT
);


-- === Branch Table === (MVP: Discrete Mathematics)
CREATE TABLE Branch ( 
	branch_id SERIAL PRIMARY KEY,
	subject_id INTEGER REFERENCES Subject(subject_id) ON DELETE CASCADE,
	name TEXT NOT NULL,
	description TEXT
); 


-- === Domain Table === (MVP: Logic and Proofs)
CREATE TABLE Domain (
	domain_id SERIAL PRIMARY KEY,
	branch_id INTEGER REFERENCES Branch(branch_id) ON DELETE CASCADE,
	name TEXT NOT NULL,
	description TEXT
);


-- === Content Table ===
CREATE TABLE Content (
	content_id SERIAL PRIMARY KEY, 
	domain_id INTEGER REFERENCES Domain(domain_id) ON DELETE SET NULL,
	title VARCHAR(100) NOT NULL, 	
	description TEXT,				
	learning_objectives TEXT, 		
	instructions TEXT, 				
	created_by INTEGER REFERENCES App_User(user_id) ON DELETE SET NULL, 			
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 


-- === Question Table ===
CREATE TABLE Question (
	question_id SERIAL PRIMARY KEY,
	content_id INTEGER REFERENCES Content(content_id) ON DELETE CASCADE,
	question_number INTEGER NOT NULL,
	prompt TEXT NOT NULL,
	content_type content_type NOT NULL, -- ENUM HERE
	rubric TEXT,
	learning_objectives TEXT,
	points_possible DECIMAL(5,2), 
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
); 


-- === Submission Table ===  
CREATE TABLE Submission (
	submission_id SERIAL PRIMARY KEY,
	content_id INTEGER REFERENCES Content(content_id) ON DELETE CASCADE,
	user_id INTEGER REFERENCES App_User(user_id) ON DELETE SET NULL,
	submission_name TEXT,
	submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
	notes TEXT 
); 


-- === Submission_Answer === 
CREATE TABLE Submission_Answer (
	answer_id SERIAL PRIMARY KEY,
	submission_id INTEGER REFERENCES Submission(submission_id) ON DELETE CASCADE, 
	question_id INTEGER REFERENCES Question(question_id) ON DELETE CASCADE, 
	answer_text TEXT NOT NULL,
	extracted_confidence FLOAT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



















