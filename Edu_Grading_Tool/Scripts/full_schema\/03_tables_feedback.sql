-- 03_tables_feedback.sql
-- AI Grading Tool - FRAM-Based Schema
-- Core tables: Feedback, AI_Feedback, Confidence_Log
-- Created: 2024-4-21
-- Author: Nathan Darby

-- === DROP TABLES FOR CLEAN RESET (DEV ONLY) ===
DROP TABLE IF EXISTS Feedback CASCADE;
DROP TABLE IF EXISTS AI_Feedback CASCADE;
DROP TABLE IF EXISTS Confidence_Log CASCADE;
DROP TYPE IF EXISTS confidence_type CASCADE;

-- === ENUM Types === 

CREATE TYPE confidence_type AS ENUM (
	-- AI_Feedback
	'M_C_I_M',	-- Pre-Evaluation (Helps Grader)
	'G_C_I_M', 	-- Post-Evaluation (Analytics/Training)
	-- Feedback 
	'M_C_I_G',	-- Post-Evaluation (Helps Grader)
	'G_C_I_G'	-- Post-Evaluation Analytics/Training
);


-- === Feedback Table ===

CREATE TABLE Feedback (
	feedback_id SERIAL PRIMARY KEY,
	answer_id INTEGER REFERENCES Submission_Answer(answer_id) ON DELETE CASCADE,
	user_id INTEGER REFERENCES App_User(user_id) ON DELETE SET NULL, 
	comment TEXT,
	score DECIMAL(5,2), 
	grader_confidence_in_grader FLOAT NOT NULL,		-- Post-Evaluation
	model_confidence_in_grader FLOAT,				-- Post-Evaluation (M_C_I_G)
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

-- === AI_Feedback Table ===

CREATE TABLE AI_Feedback (
	ai_feedback_id SERIAL PRIMARY KEY,
	answer_id INTEGER REFERENCES Submission_Answer(answer_id) ON DELETE CASCADE,
	user_id INTEGER REFERENCES App_User(user_id) ON DELETE SET NULL,
	generated_comment TEXT,
	score_suggestion DECIMAL(5,2),					-- Pre-Evaluation (M_C_I_M)
	model_version TEXT,
	model_confidence_in_model FLOAT NOT NULL, 		-- Pre-Evaluation 
	grader_confidence_in_model FLOAT,				-- Post-Evaluation
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- === Confidence_Log ===

CREATE TABLE Confidence_Log (
	log_id SERIAL PRIMARY KEY,
	feedback_id INTEGER REFERENCES Feedback(feedback_id) ON DELETE CASCADE, 
	ai_feedback_id INTEGER REFERENCES AI_Feedback(ai_feedback_id) ON DELETE CASCADE,
	confidence_type confidence_type NOT NULL,
	confidence_value FLOAT NOT NULL,
	reasoning TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);


--  Grader opens grading process: and consider A/B Testing
--> Grader opens Question 1: Prompt + students answer shown
--> AI-generated suggestion appears: AI_Feedback with score_suggestion + generated_comment
--> Grader runs through FRAM steps: Grading_Step logs Scan -> Match -> Evaluate -> etc..
--> Grader evaluates answer: Grader decides on a score + comment -> Feedback
--> Grader Reflects on AI's suggestion: Could log grader_confidence_in_model (optional)
--> Model Logs confidence in grader's score: M_C_I_G (Defer for after model training)"
