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
--   sql> @apply_oracle_lab10.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab9/apply_oracle_lab9.sql

SPOOL apply_oracle_lab10.txt
 
-- Diagnostics to verify all previous steps were done correctly to this point.

SPOOL apply_oracle_lab10.txt

SELECT   DISTINCT c.contact_id
FROM     member m INNER JOIN transaction_upload tu
ON       m.account_number = tu.account_number INNER JOIN contact c
ON       m.member_id = c.member_id
WHERE    c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
ORDER BY c.contact_id;

UPDATE SET last_updated_by = SOURCE.last_updated_by
,          last_update_date = SOURCE.last_update_date


SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id;



SELECT   COUNT(*)
FROM     contact c INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name;

SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
AND      m.account_number = tu.account_number;


SELECT   COUNT(*) AS "Rental before count"
FROM     rental;

SET NULL '<Null>'
COLUMN rental_id        FORMAT 9999 HEADING "Rental|ID #"
COLUMN customer         FORMAT 9999 HEADING "Customer|ID #"
COLUMN check_out_date   FORMAT A9   HEADING "Check Out|Date"
COLUMN return_date      FORMAT A10  HEADING "Return|Date"
COLUMN created_by       FORMAT 9999 HEADING "Created|By"
COLUMN creation_date    FORMAT A10  HEADING "Creation|Date"
COLUMN last_updated_by  FORMAT 9999 HEADING "Last|Update|By"
COLUMN last_update_date FORMAT A10  HEADING "Last|Updated"
INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
SELECT 
  rental_s1.nextval
, contact_id
, check_out_date
, return_date
, 1
, sysdate
, 1
, sysdate
FROM ( SELECT DISTINCT
	  r.rental_id
	, c.contact_id as contact_id
	, tu.check_out_date as check_out_date
	, tu.return_date as return_date
	, 1
	, sysdate
	, 1
	, sysdate
	FROM  member m INNER JOIN contact c
	ON    m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON    tu.account_number = m.account_number
	AND   tu.first_name = c.first_name
	AND   NVL(tu.middle_name, 'x') = NVL(c.middle_name, 'x')
	AND   tu.last_name = c.last_name LEFT JOIN rental r
	ON    c.contact_id = r.customer_id
	AND   tu.check_out_date = r.check_out_date
	AND   tu.return_date = r.return_date);

SELECT   COUNT(*) AS "Rental after count"
FROM     rental;


-- 2---------------------------------------------------------------------------
SELECT   COUNT(*) AS "Rental Item Before Count"
FROM     rental_item;

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
SELECT rental_item_s1.nextval
,      r.rental_id
,      tu.item_id
,      trunc(r.return_date) - trunc(r.check_out_date) as rental_item_price
,      cl.common_lookup_id AS rental_item_type
,      1 AS created_by
,      trunc(SYSDATE) AS creation_date
,      1 AS last_updated_by
,      trunc(SYSDATE) AS last_update_date
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN transaction_upload tu
ON     tu.account_number = m.account_number
AND    tu.first_name = c.first_name
AND    NVL(tu.middle_name, 'x') = NVL(c.middle_name, 'x')
AND    tu.last_name = c.last_name LEFT JOIN rental r
ON     c.contact_id = r.customer_id
AND    tu.check_out_date = r.check_out_date
AND    tu.return_date = r.return_date INNER JOIN common_lookup cl
ON     tu.rental_item_type = cl.common_lookup_type
AND    cl.common_lookup_column = 'RENTAL_ITEM_TYPE' LEFT JOIN rental_item ri
ON     ri.rental_id = r.rental_id
AND    ri.item_id = tu.item_id;

SELECT   COUNT(*) AS "Rental Item after Count"
FROM     rental_item;

SELECT   COUNT(*) AS "Transaction before count"
FROM     transaction;

INSERT 
INTO    transaction
SELECT  transaction_s1.nextval
,       t.transaction_account
,       t.transaction_type
,       t.transaction_date
,       t.transaction_amount
,       t.rental_id
,       t.payment_method_type
,       t.payment_account_number
,       1 AS created_by
,       SYSDATE AS creation_date
,       1 AS last_updated_by
,       SYSDATE AS last_update_date
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
	AND    NVL(tu.middle_name, 'x') = NVL(c.middle_name, 'x')
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

SPOOL OFF
