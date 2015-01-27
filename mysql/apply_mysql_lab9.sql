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
--   mysql> \. apply_mysql_lab9.sql
--
--  or, the more verbose syntax:
--
--   mysql> source apply_mysql_lab9.sql
--
-- ----------------------------------------------------------------------

-- Call the basic seeding scripts, this scripts TEE their own log
-- files. That means this script can only start a TEE after they run.
\. /home/student/Data/cit225/mysql/lab8/apply_mysql_lab8.sql

-- Add your lab here:
-- ----------------------------------------------------------------------
TEE apply_mysql_lab9.txt

CREATE TABLE transaction
( transaction_id              INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, transaction_account         VARCHAR(15)  NOT NULL
, transaction_type            INT UNSIGNED NOT NULL
, transaction_date            DATE         NOT NULL
, transaction_amount          FLOAT        NOT NULL
, rental_id                   INT UNSIGNED NOT NULL
, payment_method_type         INT UNSIGNED NOT NULL
, payment_account_number      VARCHAR(20)  NOT NULL
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, CONSTRAINT fk_transaction_1 FOREIGN KEY(transaction_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_transaction_2 FOREIGN KEY(rental_id) REFERENCES rental(rental_id)
, CONSTRAINT fk_transaction_3 FOREIGN KEY(payment_method_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_transaction_4 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_transaction_5 FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS constraints
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'transaction'
ORDER BY ordinal_position;

CREATE UNIQUE INDEX natural_key ON transaction 
( rental_id
, transaction_type
, transaction_date
, payment_method_type
, payment_account_number
, transaction_account);

SELECT   tc.table_name
,        tc.constraint_name
,        kcu.ordinal_position
,        kcu.column_name 
FROM     information_schema.table_constraints tc INNER JOIN
         information_schema.key_column_usage kcu
ON       tc.table_name = kcu.table_name
AND      tc.constraint_name = kcu.constraint_name
AND      tc.constraint_type = 'UNIQUE'
AND      tc.table_name = 'transaction';

INSERT INTO common_lookup 
( common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES 
( 'CREDIT'
, 'Credit'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE()
, 'TRANSACTION'
, 'TRANSACTION_TYPE'
, 'CR' );

INSERT INTO common_lookup 
( common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES 
( 'DEBIT'
, 'Debit'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE()
, 'TRANSACTION'
, 'TRANSACTION_TYPE'
, 'DR' );

INSERT INTO common_lookup 
( common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column)
VALUES 
( 'DISCOVER_CARD'
, 'Discover Card'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE()
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE');

INSERT INTO common_lookup 
( common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column)
VALUES 
( 'VISA_CARD'
, 'Visa Card'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE()
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE');

INSERT INTO common_lookup 
( common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column)
VALUES 
( 'MASTER_CARD'
, 'Master Card'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE()
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE');

INSERT INTO common_lookup 
( common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column)
VALUES 
( 'CASH'
, 'Cash'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE()
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE');

SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
FROM     common_lookup cl
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column IN ('TRANSACTION_TYPE','PAYMENT_METHOD_TYPE')
ORDER BY 1, 2, 3 DESC;

CREATE TABLE airport
( airport_id           INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, airport_code         VARCHAR(3)   NOT NULL
, airport_city         VARCHAR(30)  NOT NULL 
, city                 VARCHAR(30)  NOT NULL
, state_province       VARCHAR(30)  NOT NULL
, created_by           INT UNSIGNED NOT NULL
, creation_date        DATE         NOT NULL
, last_updated_by      INT UNSIGNED NOT NULL
, last_update_date     DATE         NOT NULL
, CONSTRAINT fk_airport_2 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_airport_3 FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS constraints
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'airport'
ORDER BY ordinal_position;

CREATE UNIQUE INDEX nk_airport ON airport
( airport_code, airport_city, city, state_province );

SELECT   tc.table_name
,        tc.constraint_name
,        kcu.ordinal_position
,        kcu.column_name 
FROM     information_schema.table_constraints tc INNER JOIN
         information_schema.key_column_usage kcu
ON       tc.table_name = kcu.table_name
AND      tc.constraint_name = kcu.constraint_name
AND      tc.constraint_type = 'UNIQUE'
AND      tc.table_name = 'airport';

INSERT INTO airport 
( airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date) 
VALUES 
( 'LAX'
, 'Los Angeles'
, 'Los Angeles'
, 'California'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE());

INSERT INTO airport 
( airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date) 
VALUES 
( 'SLC'
, 'Salt Lake City'
, 'Provo'
, 'Utah'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE());

INSERT INTO airport 
( airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date) 
VALUES 
( 'SLC'
, 'Salt Lake City'
, 'Spanish Fork'
, 'Utah'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE());

INSERT INTO airport 
( airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date) 
VALUES 
( 'SFO'
, 'San Fransisco'
, 'San Fransisco'
, 'California'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE());

INSERT INTO airport 
( airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date) 
VALUES 
( 'SJC'
, 'San Jose'
, 'San Jose'
, 'California'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE());


INSERT INTO airport 
( airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date) 
VALUES 
( 'SJC'
, 'San Jose'
, 'San Carlos'
, 'California'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE());

SELECT   airport_code
,        airport_city
,        city
,        state_province
FROM     airport;

CREATE TABLE account_list
( account_list_id      INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, account_number       VARCHAR(10)  NOT NULL
, consumed_date        DATE 
, consumed_by          INT UNSIGNED      
, created_by           INT UNSIGNED NOT NULL
, creation_date        DATE         NOT NULL
, last_updated_by      INT UNSIGNED NOT NULL
, last_update_date     DATE         NOT NULL
, CONSTRAINT fk_account_list_1 FOREIGN KEY(consumed_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_account_list_2 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_account_list_3 FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS constraints
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'account_list'
ORDER BY ordinal_position;

-- Conditionally drop the procedure.
SELECT 'DROP PROCEDURE seed_account_list' AS "Statement";
DROP PROCEDURE IF EXISTS seed_account_list;
 
-- Create procedure to insert automatic numbered rows.
SELECT 'CREATE PROCEDURE seed_account_list' AS "Statement";
 
-- Reset delimiter to write a procedure.
DELIMITER $$
 
CREATE PROCEDURE seed_account_list() MODIFIES SQL DATA
BEGIN
 
  /* Declare local variable for call parameters. */
  DECLARE lv_key CHAR(3);
 
  /* Declare local control loop variables. */
  DECLARE lv_key_min  INT DEFAULT 0;
  DECLARE lv_key_max  INT DEFAULT 50;
 
  /* Declare a local variable for a subsequent handler. */
  DECLARE duplicate_key INT DEFAULT 0;
  DECLARE fetched INT DEFAULT 0;
 
  /* Declare a SQL cursor fabricated from local variables. */  
  DECLARE parameter_cursor CURSOR FOR
    SELECT DISTINCT airport_code FROM airport;
 
  /* Declare a duplicate key handler */
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;
 
  /* Declare a not found record handler to close a cursor loop. */
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;
 
  /* Start transaction context. */
  START TRANSACTION;
 
  /* Set savepoint. */  
  SAVEPOINT all_or_none;
 
  /* Open a local cursor. */  
  OPEN parameter_cursor;
  cursor_parameter: LOOP
 
    FETCH parameter_cursor
    INTO  lv_key;
 
    /* Place the catch handler for no more rows found
       immediately after the fetch operation.          */
    IF fetched = 1 THEN LEAVE cursor_parameter; END IF;
 
    seed: WHILE (lv_key_min < lv_key_max) DO
      SET lv_key_min = lv_key_min + 1;
 
      INSERT INTO account_list
      VALUES
      ( null
      , CONCAT(lv_key,'-',LPAD(lv_key_min,6,'0'))
      , null
      , null
      , 2
      , UTC_DATE()
      , 2
      , UTC_DATE());
    END WHILE;
 
    /* Reset nested low range variable. */
    SET lv_key_min = 0;
 
  END LOOP cursor_parameter;
  CLOSE parameter_cursor;
 
    /* This acts as an exception handling block. */  
  IF duplicate_key = 1 THEN
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
 
  END IF;
 
  /* Commit the writes as a group. */
  COMMIT;
 
END;
$$
 
-- Reset delimiter to the default.
DELIMITER ;

CALL seed_account_list();

SELECT   r.routine_schema
,        r.routine_name
FROM     information_schema.routines r
WHERE    r.routine_name = 'seed_account_list';

SELECT   SUBSTR(account_number,1,3) AS "Airport"
,        COUNT(*) AS "# Accounts"
FROM     account_list
WHERE    consumed_date IS NULL
GROUP BY airport
ORDER BY 1;

UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';


-- Conditionally drop the procedure.
SELECT 'DROP PROCEDURE update_member_account' AS "Statement";
DROP PROCEDURE IF EXISTS update_member_account;

-- Create procedure to insert automatic numbered rows.
SELECT 'CREATE PROCEDURE update_member_account' AS "Statement";

-- Reset delimiter to write a procedure.
DELIMITER $$

SELECT 'DROP PROCEDURE update_member_account' AS "Statement";
DROP PROCEDURE IF EXISTS update_member_account;
 
CREATE PROCEDURE update_member_account() MODIFIES SQL DATA
BEGIN
 
  /* Declare local variable for call parameters. */
  DECLARE lv_member_id      INT UNSIGNED;
  DECLARE lv_city           CHAR(30);
  DECLARE lv_state_province CHAR(30);
  DECLARE lv_account_number CHAR(10);
 
  /* Declare a local variable for a subsequent handler. */
  DECLARE duplicate_key INT DEFAULT 0;
  DECLARE fetched INT DEFAULT 0;
 
  /* Declare a SQL cursor fabricated from local variables. */  
  DECLARE member_cursor CURSOR FOR
    SELECT   DISTINCT
             m.member_id
    ,        a.city
    ,        a.state_province
    FROM     member m INNER JOIN contact c
    ON       m.member_id = c.member_id INNER JOIN address a
    ON       c.contact_id = a.contact_id
    ORDER BY m.member_id;
 
  /* Declare a duplicate key handler */
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;
 
  /* Declare a not found record handler to close a cursor loop. */
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;
 
  /* Start transaction context. */
  START TRANSACTION;
 
  /* Set savepoint. */  
  SAVEPOINT all_or_none;
 
  /* Open a local cursor. */  
  OPEN member_cursor;
  cursor_member: LOOP
 
    FETCH member_cursor
    INTO  lv_member_id
    ,     lv_city
    ,     lv_state_province;
 
    /* Place the catch handler for no more rows found
       immediately after the fetch operation.          */
    IF fetched = 1 THEN LEAVE cursor_member; END IF;
 
      /* Secure a unique account number as theyre consumed from the list. */
      SELECT al.account_number
      INTO   lv_account_number
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTRING(al.account_number,1,3) = ap.airport_code
      WHERE  ap.city = lv_city
      AND    ap.state_province = lv_state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL LIMIT 1;
 
      /* Update a member with a unique account number linked to their nearest airport. */
      UPDATE member
      SET    account_number = lv_account_number
      WHERE  member_id = lv_member_id;
 
      /* Mark consumed the last used account number. */      
      UPDATE account_list
      SET    consumed_by = 2
      ,      consumed_date = UTC_DATE()
      WHERE  account_number = lv_account_number;
 
  END LOOP cursor_member;
  CLOSE member_cursor;
 
    /* This acts as an exception handling block. */  
  IF duplicate_key = 1 THEN
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
 
  END IF;
 
  /* Commit the writes as a group. */
  COMMIT;
 
END;
$$
 
-- Reset delimiter to the default.
DELIMITER ;

CALL update_member_account();

SELECT   r.routine_schema
,        r.routine_name
FROM     information_schema.routines r
WHERE    r.routine_name = 'update_member_account';

SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city
,        a.state_province
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id
ORDER BY 1;

CREATE TABLE transaction_upload
( account_number         VARCHAR(10)
, first_name             VARCHAR(20)
, middle_name            VARCHAR(20)
, last_name              VARCHAR(20)
, check_out_date         DATE
, return_date            DATE
, rental_item_type       VARCHAR(12)
, transaction_type       VARCHAR(14)
, transaction_amount     FLOAT
, transaction_date       DATE
, item_id                INT UNSIGNED
, payment_method_type    VARCHAR(14)
, payment_account_number VARCHAR(19)
) ENGINE=MEMORY;

LOAD DATA LOCAL INFILE '/u01/app/mysql/upload/transaction_upload_mysql.csv'
INTO TABLE transaction_upload
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

SELECT   COUNT(*) AS "External Rows"
FROM     transaction_upload;


 
NOTEE
