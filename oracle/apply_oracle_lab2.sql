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
--   sql> @apply_oracle_lab2.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab1/apply_oracle_lab1.sql

-- Add your lab here:
-- ----------------------------------------------------------------------

@/home/student/Data/cit225/oracle/lab2/create_oracle_store.sql







-- ------------------------------------------------------------------
--  Program Name:   create_oracle_store.sql
--  Lab Assignment: Lab #2
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2010
-- ------------------------------------------------------------------
-- This creates tables, sequences, indexes, and constraints necessary
-- to begin lesson #3. Demonstrates proper process and syntax.
-- ------------------------------------------------------------------

-- Open log file.
SPOOL create_oracle_store.log

-- Set SQL*Plus environmnet variables.
SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- ------------------------------------------------------------------
-- Create SYSTEM_USER_LAB table and sequence and seed data.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'SYSTEM_USER_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE system_user_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'SYSTEM_USER_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE system_user_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE system_user_lab
( system_user_id              NUMBER
, system_user_name            VARCHAR2(20) CONSTRAINT nn_system_user_lab_1 NOT NULL
, system_user_group_id        NUMBER       CONSTRAINT nn_system_user_lab_2 NOT NULL
, system_user_type            NUMBER       CONSTRAINT nn_system_user_lab_3 NOT NULL
, first_name                  VARCHAR2(20)
, middle_name                 VARCHAR2(20)
, last_name                   VARCHAR2(20)
, created_by                  NUMBER       CONSTRAINT nn_system_user_lab_4 NOT NULL
, creation_date               DATE         CONSTRAINT nn_system_user_lab_5 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_system_user_lab_6 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_system_user_lab_7 NOT NULL
, CONSTRAINT pk_system_user_lab_1 PRIMARY KEY(system_user_id));

-- Create sequence.
CREATE SEQUENCE system_user_lab_s1 START WITH 1001;

-- Seed initial record in the SYSTEM_USER_LAB table.
INSERT INTO system_user_lab
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1,'SYSADMIN', 1, 1, 1, SYSDATE, 1, SYSDATE);

-- ------------------------------------------------------------------
-- Alter SYSTEM_USER_LAB table to include self-referencing foreign key constraints.
-- ------------------------------------------------------------------
ALTER TABLE system_user_lab
ADD CONSTRAINT fk_system_user_lab_1 FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_id);

ALTER TABLE system_user_lab
ADD CONSTRAINT fk_system_user_lab_2 FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_id);

-- ------------------------------------------------------------------
-- Create COMMON_LOOKUP_LAB table and sequence and seed data.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'COMMON_LOOKUP_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE common_lookup_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'COMMON_LOOKUP_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE common_lookup_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE common_lookup_lab
( common_lookup_id            NUMBER
, common_lookup_context       VARCHAR2(30) CONSTRAINT nn_clookup_lab_1 NOT NULL
, common_lookup_type          VARCHAR2(30) CONSTRAINT nn_clookup_lab_2 NOT NULL
, common_lookup_meaning       VARCHAR2(30) CONSTRAINT nn_clookup_lab_3 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_clookup_lab_4 NOT NULL
, creation_date               DATE         CONSTRAINT nn_clookup_lab_5 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_clookup_lab_6 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_clookup_lab_7 NOT NULL
, CONSTRAINT pk_c_lookup_lab_1    PRIMARY KEY(common_lookup_id)
, CONSTRAINT fk_c_lookup_lab_1    FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_id)
, CONSTRAINT fk_c_lookup_lab_2    FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_id));

-- Create a non-unique index.
CREATE INDEX common_lookup_lab_n1
  ON common_lookup_lab(common_lookup_context);

-- Create a unique index.
CREATE UNIQUE INDEX common_lookup_lab_u2
  ON common_lookup_lab(common_lookup_context,common_lookup_type);

-- Create a sequence.
CREATE SEQUENCE common_lookup_lab_s1 START WITH 1001;

-- Seed the COMMON_LOOKUP_LAB table with 18 records.
INSERT INTO common_lookup_lab VALUES
( 1,'SYSTEM_USER','SYSTEM_ADMIN','System Administrator', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( 2,'SYSTEM_USER','DBA','Database Administrator', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'CONTACT','EMPLOYEE','Employee', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'CONTACT','CUSTOMER','Customer', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'MEMBER','INDIVIDUAL','Individual Membership', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'MEMBER','GROUP','Group Membership', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'MEMBER','DISCOVER_CARD','Discover Card', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'MEMBER','MASTER_CARD','Master Card', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'MEMBER','VISA_CARD','VISA Card', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'MULTIPLE','HOME','Home', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'MULTIPLE','WORK','Work', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'ITEM','DVD_FULL_SCREEN','DVD: Full Screen', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'ITEM','DVD_WIDE_SCREEN','DVD: Wide Screen', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'ITEM','NINTENDO_GAMECUBE','Nintendo GameCube', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'ITEM','PLAYSTATION2','PlayStation2', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'ITEM','XBOX','XBOX', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'ITEM','VHS_SINGLE_TAPE','VHS: Single Tape', 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup_lab VALUES
( common_lookup_lab_s1.nextval,'ITEM','VHS_DOUBLE_TAPE','VHS: Double Tape', 1, SYSDATE, 1, SYSDATE);

-- Add a constraint to the SYSTEM_USER_LAB table dependent on the COMMON_LOOKUP_LAB table.
ALTER TABLE system_user_lab
ADD CONSTRAINT fk_system_user_lab_3 FOREIGN KEY(system_user_type) REFERENCES common_lookup_lab(common_lookup_id);

-- ------------------------------------------------------------------
-- Create MEMBER_LAB table and sequence and seed data.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'MEMBER_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE member_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'MEMBER_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE member_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE member_lab
( member_id                   NUMBER
, member_type                 NUMBER
, account_number              VARCHAR2(10) CONSTRAINT nn_member_lab_2 NOT NULL
, credit_card_number          VARCHAR2(19) CONSTRAINT nn_member_lab_3 NOT NULL
, credit_card_type            NUMBER       CONSTRAINT nn_member_lab_4 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_member_lab_5 NOT NULL
, creation_date               DATE         CONSTRAINT nn_member_lab_6 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_member_lab_7 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_member_lab_8 NOT NULL
, CONSTRAINT pk_member_lab_1      PRIMARY KEY(member_id)
, CONSTRAINT fk_member_lab_1      FOREIGN KEY(member_type) REFERENCES common_lookup_lab(common_lookup_id)
, CONSTRAINT fk_member_lab_2      FOREIGN KEY(credit_card_type) REFERENCES common_lookup_lab(common_lookup_id)
, CONSTRAINT fk_member_lab_3      FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_id)
, CONSTRAINT fk_member_lab_4      FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_id));

-- Create a non-unique index.
CREATE INDEX member_lab_n1 ON member_lab(credit_card_type);

-- Create a sequence.
CREATE SEQUENCE member_lab_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create CONTACT_LAB table and sequence and seed data.
-- ------------------------------------------------------------------
-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'CONTACT_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE contact_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'CONTACT_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE contact_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE contact_lab
( contact_id                  NUMBER
, member_id                   NUMBER       CONSTRAINT nn_contact_lab_1 NOT NULL
, contact_type                NUMBER       CONSTRAINT nn_contact_lab_2 NOT NULL
, first_name                  VARCHAR2(20) CONSTRAINT nn_contact_lab_3 NOT NULL
, middle_name                 VARCHAR2(20)
, last_name                   VARCHAR2(20) CONSTRAINT nn_contact_lab_4 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_contact_lab_5 NOT NULL
, creation_date               DATE         CONSTRAINT nn_contact_lab_6 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_contact_lab_7 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_contact_lab_8 NOT NULL
, CONSTRAINT pk_contact_lab_1     PRIMARY KEY(contact_id)
, CONSTRAINT fk_contact_lab_1     FOREIGN KEY(member_id) REFERENCES member_lab(member_id)
, CONSTRAINT fk_contact_lab_2     FOREIGN KEY(contact_type) REFERENCES common_lookup_lab(common_lookup_id)
, CONSTRAINT fk_contact_lab_3     FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_id)
, CONSTRAINT fk_contact_lab_4     FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_id));

-- Create non-unique index.
CREATE INDEX contact_lab_n1 ON contact_lab(member_id);
CREATE INDEX contact_lab_n2 ON contact_lab(contact_type);

-- Create sequence.
CREATE SEQUENCE contact_lab_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create ADDRESS_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'ADDRESS_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE address_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'ADDRESS_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE address_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE address_lab
( address_id                  NUMBER
, contact_id                  NUMBER       CONSTRAINT nn_address_lab_1 NOT NULL
, address_type                NUMBER       CONSTRAINT nn_address_lab_2 NOT NULL
, city                        VARCHAR2(30) CONSTRAINT nn_address_lab_3 NOT NULL
, state_province              VARCHAR2(30) CONSTRAINT nn_address_lab_4 NOT NULL
, postal_code                 VARCHAR2(20) CONSTRAINT nn_address_lab_5 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_address_lab_6 NOT NULL
, creation_date               DATE         CONSTRAINT nn_address_lab_7 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_address_lab_8 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_address_lab_9 NOT NULL
, CONSTRAINT pk_address_lab_1     PRIMARY KEY(address_id)
, CONSTRAINT fk_address_lab_1     FOREIGN KEY(contact_id) REFERENCES contact_lab(contact_id)
, CONSTRAINT fk_address_lab_2     FOREIGN KEY(address_type) REFERENCES common_lookup_lab(common_lookup_id)
, CONSTRAINT fk_address_lab_3     FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_id)
, CONSTRAINT fk_address_lab_4     FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_id));

-- Create a non-unique index.
CREATE INDEX address_lab_n1 ON address_lab(contact_id);
CREATE INDEX address_lab_n2 ON address_lab(address_type);

-- Create a sequence.
CREATE SEQUENCE address_lab_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create STREET_ADDRESS_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'STREET_ADDRESS_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE street_address_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'STREET_ADDRESS_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE street_address_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE street_address_lab
( street_address_id           NUMBER
, address_id                  NUMBER       CONSTRAINT nn_saddress_lab_1 NOT NULL
, street_address              VARCHAR2(30) CONSTRAINT nn_saddress_lab_2 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_saddress_lab_3 NOT NULL
, creation_date               DATE         CONSTRAINT nn_saddress_lab_4 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_saddress_lab_5 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_saddress_lab_6 NOT NULL
, CONSTRAINT pk_s_address_lab_1   PRIMARY KEY(street_address_id)
, CONSTRAINT fk_s_address_lab_1   FOREIGN KEY(address_id) REFERENCES address_lab(address_id)
, CONSTRAINT fk_s_address_lab_3   FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_id)
, CONSTRAINT fk_s_address_lab_4   FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_id));

-- Create sequence.
CREATE SEQUENCE street_address_lab_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create TELEPHONE_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'TELEPHONE_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE telephone_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'TELEPHONE_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE telephone_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE telephone_lab
( telephone_id                NUMBER
, contact_id                  NUMBER       CONSTRAINT nn_telephone_lab_1 NOT NULL
, address_id                  NUMBER
, telephone_type              NUMBER       CONSTRAINT nn_telephone_lab_2 NOT NULL
, country_code                VARCHAR2(3)  CONSTRAINT nn_telephone_lab_3 NOT NULL
, area_code                   VARCHAR2(6)  CONSTRAINT nn_telephone_lab_4 NOT NULL
, telephone_number            VARCHAR2(10) CONSTRAINT nn_telephone_lab_5 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_telephone_lab_6 NOT NULL
, creation_date               DATE         CONSTRAINT nn_telephone_lab_7 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_telephone_lab_8 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_telephone_lab_9 NOT NULL
, CONSTRAINT pk_telephone_lab_1   PRIMARY KEY(telephone_id)
, CONSTRAINT fk_telephone_lab_1   FOREIGN KEY(contact_id) REFERENCES contact(contact_id)
, CONSTRAINT fk_telephone_lab_2   FOREIGN KEY(telephone_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_telephone_lab_3   FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_telephone_lab_4   FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));

-- Create non-unique indexes.
CREATE INDEX telephone_lab_n1 ON telephone_lab(contact_id,address_id);
CREATE INDEX telephone_lab_n2 ON telephone_lab(address_id);
CREATE INDEX telephone_lab_n3 ON telephone_lab(telephone_type);

-- Create sequence.
CREATE SEQUENCE telephone_lab_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create RENTAL_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'RENTAL_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE rental_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'RENTAL_LAV_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE rental_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE rental_lab
( rental_id                   NUMBER
, customer_id                 NUMBER CONSTRAINT nn_rental_lab_1 NOT NULL
, check_out_date              DATE   CONSTRAINT nn_rental_lab_2 NOT NULL
, return_date                 DATE   CONSTRAINT nn_rental_lab_3 NOT NULL
, created_by                  NUMBER CONSTRAINT nn_rental_lab_4 NOT NULL
, creation_date               DATE   CONSTRAINT nn_rental_lab_5 NOT NULL
, last_updated_by             NUMBER CONSTRAINT nn_rental_lab_6 NOT NULL
, last_update_date            DATE   CONSTRAINT nn_rental_lab_7 NOT NULL
, CONSTRAINT pk_rental_lab_1      PRIMARY KEY(rental_id)
, CONSTRAINT fk_rental_lab_1      FOREIGN KEY(customer_id) REFERENCES contact_lab(contact_id)
, CONSTRAINT fk_rental_lab_2      FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_id)
, CONSTRAINT fk_rental_lab_3      FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_id));

-- Create a sequence.
CREATE SEQUENCE rental_lab_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create ITEM_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'ITEM_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE item_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'ITEM_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE item_lab_s1';
  END LOOP;
END;
/

-- Create a table.
CREATE TABLE item_lab
( item_id                     NUMBER
, item_barcode                VARCHAR2(14) CONSTRAINT nn_item_lab_1 NOT NULL
, item_type                   NUMBER       CONSTRAINT nn_item_lab_2 NOT NULL
, item_title                  VARCHAR2(60) CONSTRAINT nn_item_lab_3 NOT NULL
, item_subtitle               VARCHAR2(60)
, item_rating                 VARCHAR2(8)  CONSTRAINT nn_item_lab_4 NOT NULL
, item_release_date           DATE         CONSTRAINT nn_item_lab_5 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_item_lab_6 NOT NULL
, creation_date               DATE         CONSTRAINT nn_item_lab_7 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_item_lab_8 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_item_lab_9 NOT NULL
, CONSTRAINT pk_item_lab_1        PRIMARY KEY(item_id)
, CONSTRAINT fk_item_lab_1        FOREIGN KEY(item_type) REFERENCES common_lookup_lab(common_lookup_id)
, CONSTRAINT fk_item_lab_2        FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_id)
, CONSTRAINT fk_item_lab_3        FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_id));

-- Create a sequence.
CREATE SEQUENCE item_lab_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create RENTAL_ITEM_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'RENTAL_ITEM_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE rental_item_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'RENTAL_ITEM_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE rental_item_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE rental_item_lab
( rental_item_id              NUMBER
, rental_id                   NUMBER CONSTRAINT nn_rental_item_lab_1 NOT NULL
, item_id                     NUMBER CONSTRAINT nn_rental_item_lab_2 NOT NULL
, created_by                  NUMBER CONSTRAINT nn_rental_item_lab_3 NOT NULL
, creation_date               DATE   CONSTRAINT nn_rental_item_lab_4 NOT NULL
, last_updated_by             NUMBER CONSTRAINT nn_rental_item_lab_5 NOT NULL
, last_update_date            DATE   CONSTRAINT nn_rental_item_lab_6 NOT NULL
, CONSTRAINT pk_rental_item_lab_1 PRIMARY KEY(rental_item_id)
, CONSTRAINT fk_rental_item_lab_1 FOREIGN KEY(rental_id) REFERENCES rental_lab(rental_id)
, CONSTRAINT fk_rental_item_lab_2 FOREIGN KEY(item_id) REFERENCES item_lab(item_id)
, CONSTRAINT fk_rental_item_lab_3 FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_id)
, CONSTRAINT fk_rental_item_lab_4 FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_id));

-- Create a sequence.
CREATE SEQUENCE rental_item_lab_s1 START WITH 1001;

-- Commit inserted records.
COMMIT;

-- Close log file.
SPOOL OFF
