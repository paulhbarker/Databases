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
--   sql> @apply_oracle_lab11.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab11/apply_oracle_lab11.sql

-- ----------------------------------------------------------------------
-- Step 1
-- [3 points] Create the CALENDAR table
-- ----------------------------------------------------------------------
SPOOL apply_oracle_lab12.txt

BEGIN
 FOR i IN (SELECT null FROM user_tables WHERE table_name = 'CALENDAR') LOOP
   EXECUTE IMMEDIATE 'DROP TABLE calendar CASCADE CONSTRAINTS';
 END LOOP;
 FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'CALENDAR_S1') LOOP
   EXECUTE IMMEDIATE 'DROP SEQUENCE calendar_s1';
 END LOOP;
END;
/

create table calendar
( calendar_id              NUMBER
, calendar_name            VARCHAR2(10)    CONSTRAINT nn_calendar_1     NOT NULL
, calendar_short_name      VARCHAR2(3)     CONSTRAINT nn_calendar_2     NOT NULL
, start_date               DATE            CONSTRAINT nn_calendar_3     NOT NULL
, end_date                 DATE            CONSTRAINT nn_calendar_4     NOT NULL
, created_by               NUMBER          CONSTRAINT nn_calendar_5     NOT NULL
, creation_date            DATE            CONSTRAINT nn_calendar_6     NOT NULL
, last_updated_by          NUMBER          CONSTRAINT nn_calendar_7     NOT NULL
, last_update_date         DATE            CONSTRAINT nn_calendar_8     NOT NULL
, CONSTRAINT pk_calendar_1 PRIMARY KEY(calendar_id)
, CONSTRAINT fk_calendar_1 FOREIGN KEY(CREATED_BY) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_calendar_2 FOREIGN KEY(LAST_UPDATED_BY) REFERENCES system_user(system_user_id));

-- ----------------------------------------------------------------------
-- Step 2
-- [3 points] seed calendar
-- ----------------------------------------------------------------------
CREATE SEQUENCE calendar_s1;

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'January'
, 'JAN'
, '01-JAN-2009'
, '31-JAN-2009'
, 1
, sysdate
, 1
, sysdate);

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'February'
, 'FEB'
, '01-FEB-2009'
, '28-FEB-2009'
, 1
, sysdate
, 1
, sysdate);

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'March'
, 'MAR'
, '01-MAR-2009'
, '31-MAR-2009'
, 1
, sysdate
, 1
, sysdate);

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'April'
, 'APR'
, '01-APR-2009'
, '30-APR-2009'
, 1
, sysdate
, 1
, sysdate);

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'May'
, 'MAY'
, '01-MAY-2009'
, '31-MAY-2009'
, 1
, sysdate
, 1
, sysdate);

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'June'
, 'JUN'
, '01-JUN-2009'
, '30-JUN-2009'
, 1
, sysdate
, 1
, sysdate);

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'July'
, 'JUL'
, '01-JUL-2009'
, '31-JUL-2009'
, 1
, sysdate
, 1
, sysdate);

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'August'
, 'AUG'
, '01-AUG-2009'
, '31-AUG-2009'
, 1
, sysdate
, 1
, sysdate);

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'September'
, 'SEP'
, '01-SEP-2009'
, '30-SEP-2009'
, 1
, sysdate
, 1
, sysdate);

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'October'
, 'OCT'
, '01-OCT-2009'
, '31-OCT-2009'
, 1
, sysdate
, 1
, sysdate);

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'November'
, 'NOV'
, '01-NOV-2009'
, '30-NOV-2009'
, 1
, sysdate
, 1
, sysdate);

INSERT INTO calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( calendar_s1.nextval
, 'December'
, 'DEC'
, '01-DEC-2009'
, '31-DEC-2009'
, 1
, sysdate
, 1
, sysdate);

BEGIN
 FOR i IN (SELECT null FROM user_tables WHERE table_name = 'TRANSACTION_REVERSAL') LOOP
   EXECUTE IMMEDIATE 'DROP TABLE transaction_reversal CASCADE CONSTRAINTS';
 END LOOP;
 FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'TRANSACTION_REVERSAL_S1') LOOP
   EXECUTE IMMEDIATE 'DROP SEQUENCE transaction_reversal_s1';
 END LOOP;
END;
/

create table transaction_reversal
   ( transaction_id          number
   , transaction_account     varchar2(15)
   , transaction_type        number
   , transaction_date        date
   , transaction_amount      number
   , rental_id               number
   , payment_method_type     number
   , payment_account_number  varchar2(19)
   , created_by              number
   , creation_date           date
   , last_updated_by         number
   , last_update_date        date
   )
   ORGANIZATION EXTERNAL
   ( TYPE ORACLE_LOADER
     DEFAULT DIRECTORY upload
     ACCESS PARAMETERS
     ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
     BADFILE     'UPLOAD':'transaction_upload2.bad'
     DISCARDFILE 'UPLOAD':'transaction_upload2.dis'
     LOGFILE     'UPLOAD':'transaction_upload2.log'
     FIELDS TERMINATED BY ','
     OPTIONALLY ENCLOSED BY "'"
     MISSING FIELD VALUES ARE NULL     )
     LOCATION
      ( 'transaction_upload2.csv'
      )
   )
  REJECT LIMIT UNLIMITED;

-- '

-- Move the data from TRANSACTION_REVERSAL to TRANSACTION.
INSERT INTO TRANSACTION
(SELECT
  transaction_s1.nextval
, transaction_account
, transaction_type
, transaction_date
, transaction_amount
, rental_id
, payment_method_type
, payment_account_number
, created_by
, creation_date
, last_updated_by
, last_update_date
FROM transaction_reversal WHERE transaction_id IS NOT NULL);

COLUMN "Debit Transactions"  FORMAT A20
COLUMN "Credit Transactions" FORMAT A20
COLUMN "All Transactions"    FORMAT A20
 
-- Check current contents of the model.
SELECT 'SELECT record counts' AS "Statement" FROM dual;
SELECT   LPAD(TO_CHAR(c1.transaction_count,'99,999'),19,' ') AS "Debit Transactions"
,        LPAD(TO_CHAR(c2.transaction_count,'99,999'),19,' ') AS "Credit Transactions"
,        LPAD(TO_CHAR(c3.transaction_count,'99,999'),19,' ') AS "All Transactions"
FROM    (SELECT COUNT(*) AS transaction_count FROM TRANSACTION WHERE transaction_account = '111-111-111-111') c1 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION WHERE transaction_account = '222-222-222-222') c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) c3;

COLUMN "Transaction" FORMAT A12
COLUMN "JAN" FORMAT A10
COLUMN "FEB" FORMAT A10
COLUMN "MAR" FORMAT A10
COLUMN "FQ1" FORMAT A10
COLUMN "APR" FORMAT A10
COLUMN "MAY" FORMAT A10
COLUMN "JUN" FORMAT A10
COLUMN "FQ2" FORMAT A10
COLUMN "JUL" FORMAT A10
COLUMN "AUG" FORMAT A10
COLUMN "SEP" FORMAT A10
COLUMN "FQ3" FORMAT A10
COLUMN "OCT" FORMAT A10
COLUMN "NOV" FORMAT A10
COLUMN "DEC" FORMAT A10
COLUMN "FQ4" FORMAT A10
COLUMN "YTD" FORMAT A10

SELECT  CASE
          WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
          WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
        END AS "Transaction"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Jan"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Feb"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Mar"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "FQ1"
,        LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Apr"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "May"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Jun"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (4, 5, 6) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "FQ2"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Jul"
,        LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Aug"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Sep"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (7, 8, 9) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "FQ3"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "OCT"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Nov"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "DEC"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (10, 11, 12) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "FQ4"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "YTD"
FROM     TRANSACTION t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE'
GROUP BY CASE
          WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
          WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
        END
UNION ALL
SELECT 'Total' as "Transaction"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Jan"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Feb"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Mar"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "FQ1"
,        LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Apr"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "May"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Jun"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (4, 5, 6) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "FQ2"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Jul"
,        LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Aug"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Sep"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (7, 8, 9) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "FQ3"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "OCT"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "Nov"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "DEC"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (10, 11, 12) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "FQ4"
,   LPAD(TO_CHAR
       (SUM(CASE
              WHEN EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),'99,999.00'),10,' ') AS "YTD"
FROM     TRANSACTION t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE';


SPOOL OFF

