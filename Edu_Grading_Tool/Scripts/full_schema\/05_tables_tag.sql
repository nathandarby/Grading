-- 05_tables_tag.sql
-- AI Grading Tool - FRAM-Based Schema
-- Core tables: Tag, Tag_Context, 'Entity'_Tag, 
-- Created: 2024-4-21
-- Author: Nathan Darby

-- Feedback (grader's comments will get tagged by AI)
-- AI_Feedback ( AI's comments and score suggestion will get tagged by human/script)
-- Submission_Answer ( will get tagged by both AI and grader, but AI tags will be approved by grader)
-- Grading_Step ( tagged by both AI and grader?) 


DROP TABLE IF EXISTS Tag CASCADE;
DROP TABLE IF EXISTS Tag_Context CASCADE;
DROP TABLE IF EXISTS Feedback_Tag Cascade; 
DROP TABLE IF EXISTS AI_Feedback_Tag CASCADE;
DROP TABLE IF EXISTS Submission_Answer_Tag CASCADE;
DROP TABLE IF EXISTS Grading_Step_Tag CASCADE;
DROP TYPE IF EXISTS applies_to_entity CASCADE;

-- === Applies_To_Entity Type ===

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






