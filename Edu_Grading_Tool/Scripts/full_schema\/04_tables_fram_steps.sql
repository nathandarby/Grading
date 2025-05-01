-- 04_tables_fram_steps.sql
-- AI Grading Tool - FRAM-Based Schema
-- Core tables: Fram_Function, Function_Aspect, Interaction, Grader, Grading_Step
-- Created: 2024-4-21
-- Author: Nathan Darby

DROP TABLE IF EXISTS FRAM_Function CASCADE;
DROP TABLE IF EXISTS Function_Aspect CASCADE;
DROP TABLE IF EXISTS Interaction CASCADE;
DROP TABLE IF EXISTS Grading_Step CASCADE;
DROP TABLE IF EXISTS Grader Cascade; 
DROP TYPE IF EXISTS aspect_type CASCADE;
DROP TYPE IF EXISTS interaction_type CASCADE; 
DROP TYPE IF EXISTS grader_role CASCADE;
DROP TYPE IF EXISTS step_type CASCADE; 



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












