-- 01_create_schema.sql
-- AI Grading Tool - FRAM-Based Schema
-- Initializes the database schema
-- Created: 2024-4-21
-- Author: Nathan Darby

--
SET search_path TO public;


-- CORE ********************************************************************************************

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
	created_by INTEGER, 			
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


-- USER ********************************************************************************************


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

-- Feedback ********************************************************************************************

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

-- FRAM_Steps ********************************************************************************************

-- === ENUM Types ===
CREATE TYPE aspect_type AS ENUM (
	'input',		-- what starts the function	
	'output',		-- what the function produces 
	'control',		-- what regulates it (rules, constraints)
	'precondition',	-- must be true before start 
	'resource',		-- whats needed to perform
	'time'			-- when it occurs or timing limits 
);		

CREATE TYPE interaction_type AS ENUM (
	'supports',		-- helps another aspect/function operate 
	'constrains',	-- limits how another aspect can act
	'triggers',		-- causes another function/aspect to start 
	'informs',		-- provides info without forcing action
	'requires',		-- must be present for something to work
	'delays' 		-- slows or postpones the target aspect/function
);


CREATE TYPE step_type AS ENUM ( -- Consider auto-scan, auto-match, flag, elevate, etc... 
	'scan',
	'match',
	'evaluate',
	're-evaluate'
);

-- === Fram_Function Table ===
CREATE TABLE FRAM_Function (
	function_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL, 	-- e.g., "Scan", "Match", "Evaluate"
	description TEXT 
);


-- === Function_Aspect Table ===
CREATE TABLE Function_Aspect (
	aspect_id SERIAL PRIMARY KEY,
	function_id INTEGER REFERENCES FRAM_Function(function_id) ON DELETE CASCADE,
	aspect_type aspect_type,
	description TEXT
); 

-- === Interaction Table ===
CREATE TABLE Interaction (
	interaction_id SERIAL PRIMARY KEY,
	from_aspect_id INTEGER REFERENCES Function_Aspect(aspect_id) ON DELETE CASCADE,
	to_aspect_id   INTEGER REFERENCES Function_Aspect(aspect_id) ON DELETE CASCADE, 
	interaction_type interaction_type, 		-- e.g., 'supports', 'constraints'
	notes TEXT 
);


-- === Grading_Step Table ===				
CREATE TABLE Grading_Step (
	step_id SERIAL PRIMARY KEY, 
	answer_id INTEGER REFERENCES Submission_Answer(answer_id) ON DELETE CASCADE,
	function_id INTEGER REFERENCES FRAM_Function(function_id) ON DELETE SET NULL,
	aspect_id INTEGER REFERENCES Function_Aspect(aspect_id) ON DELETE SET NULL,
	user_id INTEGER REFERENCES App_User(user_id) ON DELETE SET NULL,
	step_type step_type NOT NULL, 
	notes TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

-- FRAM_Steps ********************************************************************************************

CREATE TYPE applies_to_entity AS ENUM (
    'feedback',
    'ai_feedback',
    'grading_step',
    'submission_answer'
);

-- === Tag Table ===								-- the WHAT

CREATE TABLE Tag (									
	tag_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL			-- 'logic-error'									
);

-- === Tag_Context Table ===						-- the where allowed

CREATE TABLE Tag_Context (							
	tag_context_id SERIAL PRIMARY KEY,
	tag_id INTEGER REFERENCES Tag(tag_id) ON DELETE CASCADE,
	applies_to applies_to_entity NOT NULL,  -- ENUM: feedback, submission_answer. etc...
	description TEXT NOT NULL
);

-- === Entity_Tag Tables ===						-- applied on real data

CREATE TABLE Feedback_Tag (				
    feedback_id INTEGER REFERENCES Feedback(feedback_id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES Tag(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (feedback_id, tag_id)
);

CREATE TABLE AI_Feedback_Tag (
    ai_feedback_id INTEGER REFERENCES AI_Feedback(ai_feedback_id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES Tag(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (ai_feedback_id, tag_id)
);

CREATE TABLE Submission_Answer_Tag (
    answer_id INTEGER REFERENCES Submission_Answer(answer_id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES Tag(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (answer_id, tag_id)
);

CREATE TABLE Grading_Step_Tag (
    step_id INTEGER REFERENCES Grading_Step(step_id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES Tag(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (step_id, tag_id)
);















