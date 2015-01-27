-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab5.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab1/apply_oracle_lab1.sql

-- Add your lab here:
-- ----------------------------------------------------------------------

SPOOL apply_oracle_lab5.txt;

-- 1. [4 points] Write INNER JOIN queries that use the USING subclause
-- A)
SELECT member_id,
       contact_id
FROM   member INNER JOIN contact
USING  (member_id);

-- B)
SELECT contact_id,
       address_id
FROM   contact INNER JOIN address
USING  (contact_id);

-- C)
SELECT address_id,
       street_address_id
FROM   address INNER JOIN street_address
USING  (address_id);

-- D)
SELECT contact_id,
       telephone_id
FROM   contact INNER JOIN telephone
USING  (contact_id);

-- 2. [2 points] Write INNER JOIN queries that use the ON subclause
-- A)
SELECT contact_id,
       system_user_id
FROM   contact c INNER JOIN system_user su
ON     c.created_by = su.system_user_id;

-- B)
SELECT contact_id,
       system_user_id
FROM   contact c INNER JOIN system_user su
ON     c.last_updated_by = su.system_user_id;

-- 3. [2 points] Write INNER JOIN queries that use the ON subclause
-- A)
SELECT su1.system_user_id,
       su1.created_by,
       su2.system_user_id
FROM   system_user su1, system_user su2
WHERE  su1.created_by = su2.system_user_id;

-- B)
SELECT su1.system_user_id,
       su1.last_updated_by,
       su2.system_user_id
FROM   system_user su1, system_user su2
WHERE  su1.last_updated_by = su2.system_user_id;

-- 4. [2 points] Display the RENTAL_ID column from the RENTAL table, the RENTAL_ID and ITEM_ID from the RENTAL_ITEM table, and ITEM_ID column from the ITEM table. You should make a join from the RENTAL table to the RENTAL_ITEM table, and then the ITEM table. Join the tables based on their respective primary and foreign key values.
SELECT r.rental_id,
       ri.rental_id,
       ri.item_id,
       i.item_id
FROM   rental r INNER JOIN rental_item ri
ON     r.rental_id = ri.rental_id  INNER JOIN item i
ON     ri.item_id = i.item_id;

SPOOL OFF;

