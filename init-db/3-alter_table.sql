-- ============================================================================
-- AlterTable.sql  -  Stage 4: auxiliary schema additions
-- Creates booking_audit, the central log table consumed by Trigger1, Trigger2,
-- Function1, and Function2. Adds total_bookings to USERS so Trigger2 can
-- maintain a per-user confirmed-booking counter. Adds last_updated to
-- ATTRACTIONS so Function2 can stamp refresh timestamps.
-- Run this file BEFORE any other Stage-4 file.
-- ============================================================================

-- Audit / change-log table
CREATE TABLE IF NOT EXISTS booking_audit (
    audit_id    SERIAL           PRIMARY KEY,
    booking_id  INT              NOT NULL,
    user_id     INT,
    old_status  VARCHAR(50),
    new_status  VARCHAR(50),
    old_amount  DOUBLE PRECISION,
    new_amount  DOUBLE PRECISION,
    changed_by  VARCHAR(100)     NOT NULL DEFAULT current_user,
    change_type VARCHAR(20)      NOT NULL,   -- 'INSERT' | 'UPDATE' | 'DELETE'
    change_time TIMESTAMP        NOT NULL DEFAULT NOW(),
    notes       TEXT
);

-- Running counter: how many bookings each user has completed
ALTER TABLE USERS
    ADD COLUMN IF NOT EXISTS total_bookings INT NOT NULL DEFAULT 0;

-- Timestamp: when were this attraction's stats last refreshed
ALTER TABLE ATTRACTIONS
    ADD COLUMN IF NOT EXISTS last_updated TIMESTAMP DEFAULT NOW();
