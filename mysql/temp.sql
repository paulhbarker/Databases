-- Conditionally drop the procedure.
DROP PROCEDURE IF EXISTS transaction_upload;
 
-- Reset the execution delimiter to create a stored program.
DELIMITER $$
 
-- The parentheses after the procedure name must be there or the MODIFIES SQL DATA raises an compile time exception.
CREATE PROCEDURE transaction_upload() MODIFIES SQL DATA
 
BEGIN
 
  /* Declare a handler variables. */
  DECLARE duplicate_key INT DEFAULT 0;
  DECLARE foreign_key   INT DEFAULT 0;
 
  /* Declare a duplicate key handler */
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;
  DECLARE CONTINUE HANDLER FOR 1216 SET foreign_key = 1;
 
  /* ---------------------------------------------------------------------- */
 
  /* Start transaction context. */
  START TRANSACTION;
 
  /* Set savepoint. */  
  SAVEPOINT both_or_none;
 
  /* Replace into rental table. */  
REPLACE INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
SELECT
  il.rental_id 
, il.contact_id
, il.check_out_date
, il.return_date
, 1001 AS created_by
, UTC_DATE() AS creation_date
, 1001 AS last_updated_by
, UTC_DATE() AS last_update_date
FROM (SELECT DISTINCT 
              r.rental_id
	,     c.contact_id AS contact_id
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
 
  /* Replace into rental_item table. */  
REPLACE INTO rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
SELECT ri.rental_item_id AS rental_item_id
,      r.rental_id AS rental_id
,      tu.item_id AS item_id
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
 
REPLACE INTO transaction
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
 
  /* ---------------------------------------------------------------------- */
 
  /* This acts as an exception handling block. */  
  IF duplicate_key = 1 OR foreign_key = 1 THEN
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT both_or_none;
 
  ELSE
 
    /* This commits the writes. */
    COMMIT;
 
  END IF;
 
END;
$$
 
-- Reset the delimiter to the default.
DELIMITER ;

CALL transaction_upload();

SELECT   c1.rental_count
,        c2.rental_item_count
,        c3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) c1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction) c3;

CALL transaction_upload();

SELECT   c1.rental_count
,        c2.rental_item_count
,        c3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) c1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction) c3;
