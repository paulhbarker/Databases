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
--   mysql> \. apply_mysql_lab7.sql
--
--  or, the more verbose syntax:
--
--   mysql> source apply_mysql_lab7.sql
--
-- ----------------------------------------------------------------------
use studentdb
-- Call the basic seeding scripts, this scripts TEE their own log
-- files. That means this script can only start a TEE after they run.
\. /home/student/Data/cit225/mysql/lab6/apply_mysql_lab6.sql

-- Add your lab here:
-- ----------------------------------------------------------------------

TEE apply_lab7_mysql.txt
 
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
('YES'
,'Yes'
, 1001, UTC_DATE(), 1001, UTC_DATE()
,'PRICE'
,'ACTIVE_FLAG'
, 'Y');

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
('NO'
,'No'
, 1001, UTC_DATE(), 1001, UTC_DATE()
,'PRICE'
,'ACTIVE_FLAG'
, 'N');

SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'PRICE'
AND      common_lookup_column = 'ACTIVE_FLAG'
ORDER BY 1, 2, 3 DESC;

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
('1-DAY RENTAL'
,'1-Day Rental'
, 1001, UTC_DATE(), 1001, UTC_DATE()
,'PRICE'
,'PRICE_TYPE'
, '1');

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
('3-DAY RENTAL'
,'3-Day Rental'
, 1001, UTC_DATE(), 1001, UTC_DATE()
,'PRICE'
,'PRICE_TYPE'
, '3');

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
('5-DAY RENTAL'
,'5-Day Rental'
, 1001, UTC_DATE(), 1001, UTC_DATE()
,'PRICE'
,'PRICE_TYPE'
, '5');

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
('1-DAY RENTAL'
,'1-Day Rental'
, 1001, UTC_DATE(), 1001, UTC_DATE()
,'RENTAL_ITEM'
,'RENTAL_ITEM_TYPE'
, '1');

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
('3-DAY RENTAL'
,'3-Day Rental'
, 1001, UTC_DATE(), 1001, UTC_DATE()
,'RENTAL_ITEM'
,'RENTAL_ITEM_TYPE'
, '3');

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
('5-DAY RENTAL'
,'5-Day Rental'
, 1001, UTC_DATE(), 1001, UTC_DATE()
,'RENTAL_ITEM'
,'RENTAL_ITEM_TYPE'
, '5');

SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN ('PRICE','RENTAL_ITEM')
AND      common_lookup_column IN ('PRICE_TYPE','RENTAL_ITEM_TYPE')
ORDER BY 1, 2, 3;

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'rental_item'
ORDER BY 2;

UPDATE   rental_item ri
SET      rental_item_type =
        (SELECT   cl.common_lookup_id
         FROM     common_lookup cl
         WHERE    cl.common_lookup_code =
                 (SELECT   DATEDIFF(r.return_date,r.check_out_date)
                  FROM     rental r
                  WHERE    r.rental_id = ri.rental_id)
         AND      cl.common_lookup_table = 'RENTAL_ITEM'
         AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE');

SELECT   row_count
,        col_count
FROM    (SELECT   COUNT(*) AS row_count
         FROM     rental_item) rc CROSS JOIN
        (SELECT   COUNT(rental_item_type) AS col_count
         FROM     rental_item
         WHERE    rental_item_type IS NOT NULL) cc;

ALTER TABLE rental_item
  MODIFY rental_item_type INT UNSIGNED NOT NULL;

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'rental_item'
AND      column_name = 'rental_item_type';

SELECT   CONCAT(tc.table_schema,'.',tc.table_name,'.',tc.constraint_name) AS "Constraint"
,        CONCAT(kcu.table_schema,'.',kcu.table_name,'.',kcu.column_name) AS "Foreign Key"
,        CONCAT(kcu.referenced_table_schema,'.',kcu.referenced_table_name,'.',kcu.referenced_column_name) AS "Primary Key"
FROM     information_schema.table_constraints tc JOIN information_schema.key_column_usage kcu
ON       tc.constraint_name = kcu.constraint_name
WHERE    tc.table_name = 'rental_item'
AND      kcu.column_name = 'rental_item_type'
AND      tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name
,        kcu.column_name\G


SELECT     i.item_id
,	   af.active_flag
,	   cl.common_lookup_id AS price_type
,          CASE
             WHEN DATEDIFF(UTC_DATE(),i.release_date) > 30
             AND af.active_flag = 'Y' 
             THEN DATE_ADD(i.release_date, INTERVAL 31 DAY)
             ELSE i.release_date
           END AS start_date
,          CASE 
             WHEN DATEDIFF(UTC_DATE(),i.release_date) > 30 
	     AND af.active_flag = 'N'
             THEN DATE_ADD(i.release_date, INTERVAL 30 DAY)
           END AS end_date
,          CASE
             WHEN af.active_flag = 'N' 
             OR DATEDIFF(UTC_DATE(), i.release_date) < 31 THEN
             CASE 
		WHEN dr.rental_days = '1' THEN '3'
                WHEN dr.rental_days = '3' THEN '10'
                WHEN dr.rental_days = '5' THEN '15'
             END
             ELSE dr.rental_days
           END AS amount
FROM       item i CROSS JOIN
          (SELECT 'Y' AS active_flag FROM dual
           UNION ALL
           SELECT 'N' AS active_flag FROM dual) af CROSS JOIN
          (SELECT '1' AS rental_days FROM dual
           UNION ALL
           SELECT '3' AS rental_days FROM dual
           UNION ALL
           SELECT '5' AS rental_days FROM dual) dr 
INNER JOIN common_lookup cl ON dr.rental_days = SUBSTR(cl.common_lookup_type,1,1)
WHERE      cl.common_lookup_table = 'PRICE'
AND        cl.common_lookup_column = 'PRICE_TYPE'
AND NOT    (DATEDIFF(UTC_DATE(),i.release_date) < 31 AND af.active_flag = 'N')
ORDER BY   1, 2, 3;
 
NOTEE
