-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   mysql -ustudent -pstudent
--
--  or, you can fully qualify the port with this syntax:
--
--   mysql -ustudent -pstudent -P3306
--
-- Then, you call this script with the following syntax:
--
--   mysql> \. apply_mysql_lab12.sql
--
--  or, the more verbose syntax:
--
--   mysql> source apply_mysql_lab12.sql
--
-- ----------------------------------------------------------------------

-- Call the basic seeding scripts, this scripts TEE their own log
-- files. That means this script can only start a TEE after they run.
\. /home/student/Data/cit225/mysql/lab11/apply_mysql_lab11.sql

-- Add your lab here:
-- ----------------------------------------------------------------------
TEE apply_mysql_lab12.txt

SELECT 'CALENDAR' AS "Drop Table";
DROP TABLE IF EXISTS calendar;

SELECT 'CALENDAR' AS "Create Table";
CREATE TABLE calendar
( calendar_id    	INT UNSIGNED    PRIMARY KEY AUTO_INCREMENT
, calendar_name  	VARCHAR(10) 	NOT NULL
, calendar_short_name 	VARCHAR(3) 	NOT NULL
, start_date    	DATE 		NOT NULL
, end_date    		DATE 		NOT NULL
, created_by    	INT UNSIGNED 	NOT NULL
, creation_date  	DATE 		NOT NULL
, last_updated_by  	INT UNSIGNED	NOT NULL
, last_update_date 	DATE 		NOT NULL
, CONSTRAINT fk_calendar_1 FOREIGN KEY (created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_calendar_2 FOREIGN KEY (last_updated_by) REFERENCES system_user(system_user_id)
);

-- STEP #2
-- Note: Dates in MySQL need to be in the format of YYYY-MM-DD
INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'January'
, 'JAN'
, STR_TO_DATE('01-01-2009', '%d-%m-%Y')
, STR_TO_DATE('31-01-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'February'
, 'FEB'
, STR_TO_DATE('01-02-2009', '%d-%m-%Y')
, STR_TO_DATE('28-02-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'March'
, 'MAR'
, STR_TO_DATE('01-03-2009', '%d-%m-%Y')
, STR_TO_DATE('31-03-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'April'
, 'APR'
, STR_TO_DATE('01-04-2009', '%d-%m-%Y')
, STR_TO_DATE('30-04-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'May'
, 'MAY'
, STR_TO_DATE('01-05-2009', '%d-%m-%Y')
, STR_TO_DATE('31-05-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'June'
, 'JUN'
, STR_TO_DATE('01-06-2009', '%d-%m-%Y')
, STR_TO_DATE('30-06-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'July'
, 'JUL'
, STR_TO_DATE('01-07-2009', '%d-%m-%Y')
, STR_TO_DATE('31-07-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'August'
, 'AUG'
, STR_TO_DATE('01-08-2009', '%d-%m-%Y')
, STR_TO_DATE('31-08-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'September'
, 'SEP'
, STR_TO_DATE('01-09-2009', '%d-%m-%Y')
, STR_TO_DATE('30-09-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'October'
, 'OCT'
, STR_TO_DATE('01-10-2009', '%d-%m-%Y')
, STR_TO_DATE('31-10-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'November'
, 'NOV'
, STR_TO_DATE('01-11-2009', '%d-%m-%Y')
, STR_TO_DATE('30-11-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

INSERT INTO calendar
( calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
( 'December'
, 'DEC'
, STR_TO_DATE('01-12-2009', '%d-%m-%Y')
, STR_TO_DATE('31-12-2009', '%d-%m-%Y')
, 1002, UTC_DATE(), 1002, UTC_DATE());

-- STEP #3
-- Conditionally drop objects.
SELECT 'TRANSACTION_REVERSAL' AS "Drop Table";
DROP TABLE IF EXISTS transaction_reversal;

-- Create a table with a unique name from another table
CREATE TABLE transaction_reversal
AS SELECT * FROM transaction;

TRUNCATE TABLE transaction_reversal;

ALTER TABLE transaction_reversal ENGINE=MEMORY;

LOAD DATA LOCAL INFILE '/u01/app/mysql/upload/transaction_upload2_mysql.csv'
INTO TABLE transaction_reversal
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

INSERT INTO transaction
( SELECT NULL
, tr.transaction_account
, tr.transaction_type
, tr.transaction_date
, tr.transaction_amount
, tr.rental_id
, tr.payment_method_type
, tr.payment_account_number
, tr.created_by
, tr.creation_date
, tr.last_updated_by
, tr.last_update_date
FROM transaction_reversal tr
);

-- Check current contents of the model.
SELECT 'SELECT record counts' AS "Statement";
SELECT   LPAD(FORMAT(c1.transaction_count,0),19,' ') AS "Debit Transactions"
,        LPAD(FORMAT(c2.transaction_count,0),19,' ') AS "Credit Transactions"
,        LPAD(FORMAT(c3.transaction_count,0),19,' ') AS "All Transactions"
FROM    (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '111-111-111-111') c1 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '222-222-222-222') c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction) c3;

-- Step 4 ---------------

UPDATE transaction
SET transaction_type = 1028
WHERE transaction_account = '222-222-222-222';

SELECT   CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
         END AS "Transaction"
,        CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 1
           WHEN t.transaction_account = '222-222-222-222' THEN 2
         END AS "Sortkey"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "Jan"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "Feb"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "Mar"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "F1Q"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "Apr"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "May"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "Jun"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (4, 5, 6) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "F2Q"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "Jul"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "Aug"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "Sep"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (7, 8, 9) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "F3Q"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "Oct"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "Nov"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "Dec"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (10, 11, 12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "F4Q"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "YTD"
FROM     transaction t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id 
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE' 
GROUP BY CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
         END
UNION ALL
SELECT 'Total' as "Transaction"
,   3 AS "Sortkey"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "Jan"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "Feb"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "Mar"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "FQ1"
,        LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "Apr"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "May"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "Jun"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (4, 5, 6) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "FQ2"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "Jul"
,        LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "Aug"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "Sep"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (7, 8, 9) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "FQ3"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "Oct"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "Nov"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "Dec"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(MONTH FROM transaction_date) IN (10, 11, 12) AND
                   EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "FQ4"
,   LPAD(FORMAT
       (SUM(CASE
              WHEN EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                CASE
                  WHEN cl.common_lookup_type = 'DEBIT'
                  THEN t.transaction_amount
                  ELSE t.transaction_amount * -1
                END
            END),2),10,' ') AS "YTD"
FROM     transaction t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE'
ORDER BY 2;



NOTEE
