-- 01_create_schema.sql
-- AI Grading Tool - FRAM-Based Schema
-- Initializes the database schema
-- Created: 2024-4-21
-- Author: Nathan Darby

-- Drop existing schema if re-running (optional during development)
DROP SCHEMA IF EXISTS FRAM_grading CASCADE;


-- Create fresh schema
CREATE SCHEMA fram_grading;

-- Set default search path to this schema for this session
SET search_path TO fram_grading; 

