-- AgriTrace Database Initialization Script
-- This script sets up the initial database configuration

-- Create extensions if they don't exist
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Create additional schemas if needed
-- CREATE SCHEMA IF NOT EXISTS analytics;

-- Set timezone
SET timezone = 'UTC';

-- Create initial indexes for performance
-- These will be created by Django migrations, but we can prepare the database

-- Log the initialization
DO $$
BEGIN
    RAISE NOTICE 'AgriTrace database initialized successfully at %', NOW();
END $$;
