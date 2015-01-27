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
--   mysql> \. apply_mysql_lab10.sql
--
--  or, the more verbose syntax:
--
--   mysql> source apply_mysql_lab10.sql
--
-- ----------------------------------------------------------------------

-- Call the basic seeding scripts, this scripts TEE their own log
-- files. That means this script can only start a TEE after they run.
\. /home/student/Data/cit225/mysql/lab9/apply_mysql_lab9.sql

-- Add your lab here:
-- ----------------------------------------------------------------------

TEE apply_mysql_lab10.txt
 
SELECT   COUNT(*) AS "Empty String Columns"
FROM     transaction_upload
WHERE    middle_name = '';

UPDATE transaction_upload
SET    middle_name = null
WHERE  middle_name = '';

SELECT   COUNT(*) AS "Empty String Columns"
FROM     transaction_upload
WHERE    middle_name = '';

SELECT   DISTINCT
         c.contact_id
,        c.last_name
FROM     member m INNER JOIN transaction_upload tu
ON       m.account_number = tu.account_number INNER JOIN contact c
ON       m.member_id = c.member_id
WHERE    c.first_name = tu.first_name
AND      IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
ORDER BY 1;

SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id;

SELECT   COUNT(*)
FROM     contact c INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
AND      c.last_name = tu.last_name;

SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
AND      m.account_number = tu.account_number;	

SELECT   COUNT(*) AS "Rental before count"
FROM     rental;

INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
SELECT 
  il.contact_id
, il.check_out_date
, il.return_date
, 1001 AS created_by
, UTC_DATE() AS creation_date
, 1001 AS last_updated_by
, UTC_DATE() AS last_update_date
FROM (SELECT DISTINCT
	      c.contact_id AS contact_id
	,     tu.check_out_date AS check_out_date
	,     tu.return_date AS return_date
	FROM  member m INNER JOIN contact c
	ON    m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON    tu.account_number = m.account_number
	AND   tu.first_name = c.first_name
	AND   IFNULL(tu.middle_name, 'x') = IFNULL(c.middle_name, 'x')
	AND   tu.last_name = c.last_name LEFT JOIN rental r
	ON    c.contact_id = r.customer_id
	AND   tu.check_out_date = r.check_out_date
	AND   tu.return_date = r.return_date) il;


SELECT   COUNT(*) AS "Rental after count"
FROM     rental;

SELECT   COUNT(*) AS "Rental_Item before count"
FROM     rental_item;

INSERT INTO rental_item
( rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
SELECT r.rental_id
,      tu.item_id
,      DATEDIFF(r.return_date,r.check_out_date) AS rental_item_price
,      cl.common_lookup_id AS rental_item_type
,      1001 AS created_by
,      UTC_DATE() AS creation_date
,      1001 AS last_updated_by
,      UTC_DATE() AS last_update_date
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN transaction_upload tu
ON     tu.account_number = m.account_number
AND    tu.first_name = c.first_name
AND    IFNULL(tu.middle_name, 'x') = IFNULL(c.middle_name, 'x')
AND    tu.last_name = c.last_name LEFT JOIN rental r
ON     c.contact_id = r.customer_id
AND    tu.check_out_date = r.check_out_date
AND    tu.return_date = r.return_date INNER JOIN common_lookup cl
ON     tu.rental_item_type = cl.common_lookup_type
AND    cl.common_lookup_column = 'RENTAL_ITEM_TYPE' LEFT JOIN rental_item ri
ON     ri.rental_id = r.rental_id
AND    ri.item_id = tu.item_id;

SELECT   COUNT(*) AS "Rental after count"
FROM     rental_item;

SELECT   COUNT(*) AS "Transaction before count"
FROM     transaction;

INSERT 
INTO    transaction
( transaction_account
, transaction_type
, transaction_date
, transaction_amount
, rental_id
, payment_method_type
, payment_account_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
SELECT  t.transaction_account
,       t.transaction_type
,       t.transaction_date
,       t.transaction_amount
,       t.rental_id
,       t.payment_method_type
,       t.payment_account_number
,       1001 AS created_by
,       UTC_DATE() AS creation_date
,       1001 AS last_updated_by
,       UTC_DATE() AS last_update_date
FROM   (SELECT t.transaction_id
	,      tu.payment_account_number AS transaction_account
	,      cl1.common_lookup_id AS transaction_type
	,      tu.transaction_date AS transaction_date
	,      SUM(tu.transaction_amount) AS transaction_amount
	,      r.rental_id AS rental_id
	,      cl2.common_lookup_id AS payment_method_type
	,      m.credit_card_number AS payment_account_number
	FROM   member m INNER JOIN contact c
	ON     m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON     tu.account_number = m.account_number
	AND    tu.first_name = c.first_name
	AND    IFNULL(tu.middle_name, 'x') = IFNULL(c.middle_name, 'x')
	AND    tu.last_name = c.last_name INNER JOIN rental r
	ON     c.contact_id = r.customer_id
	AND    tu.check_out_date = r.check_out_date
	AND    tu.return_date = r.return_date INNER JOIN common_lookup cl1
	ON     cl1.common_lookup_table = 'TRANSACTION'
	AND    cl1.common_lookup_column = 'TRANSACTION_TYPE'
	AND    cl1.common_lookup_type = tu.transaction_type INNER JOIN common_lookup cl2
	ON     cl2.common_lookup_table = 'TRANSACTION'
	AND    cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
	AND    cl2.common_lookup_type = tu.payment_method_type LEFT JOIN transaction t
	ON     t.transaction_account = tu.payment_account_number
	AND    t.transaction_type = cl1.common_lookup_id
	AND    t.transaction_date = tu.transaction_date
	AND    t.transaction_amount = tu.transaction_amount
	AND    t.payment_method_type = cl2.common_lookup_id
	AND    t.payment_account_number = m.credit_card_number
	GROUP BY
	  t.transaction_id
	, tu.payment_account_number
	, cl1.common_lookup_id
	, tu.transaction_date
	, tu.transaction_amount
	, r.rental_id
	, cl2.common_lookup_id
	, m.credit_card_number) t;

SELECT   COUNT(*) AS "Transaction after count"
FROM     transaction;
 
NOTEE
