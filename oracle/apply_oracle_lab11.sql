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
@/home/student/Data/cit225/oracle/lab9/apply_oracle_lab9.sql

SPOOL apply_oracle_lab11.txt
-- Create a procedure to wrap the transaction.
CREATE OR REPLACE PROCEDURE upload_transaction IS 
BEGIN
  -- Set save point for an all or nothing transaction.
  SAVEPOINT starting_point;
 
  -- Merge into RENTAL table.
  MERGE INTO rental target
  USING ( SELECT DISTINCT
    	    r.rental_id
    	  , c.contact_id AS customer_id
  	  , tu.check_out_date AS check_out_date
  	  , tu.return_date AS return_date
  	  , 1 AS created_by
  	  , SYSDATE AS creation_date
  	  , 1 AS last_updated_by
  	  , SYSDATE last_update_date
	  FROM  member m INNER JOIN contact c
	  ON    m.member_id = c.member_id INNER JOIN transaction_upload tu
	  ON    tu.account_number = m.account_number
	  AND   tu.first_name = c.first_name
	  AND   NVL(tu.middle_name, 'x') = NVL(c.middle_name, 'x')
	  AND   tu.last_name = c.last_name LEFT JOIN rental r
	  ON    c.contact_id = r.customer_id
	  AND   tu.check_out_date = r.check_out_date
	  AND   tu.return_date = r.return_date) source
  ON (target.rental_id = source.rental_id)
  WHEN MATCHED THEN
  UPDATE SET target.last_updated_by = source.last_updated_by
  ,          target.last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_s1.nextval
  , source.customer_id
  , source.check_out_date
  , source.return_date
  , source.created_by
  , source.creation_date
  , source.last_updated_by
  , source.last_update_date);
 
  -- Merge into RENTAL_ITEM table.
  MERGE INTO rental_item target
  USING ( SELECT ri.rental_item_id
	  ,      r.rental_id AS rental_id
	  ,      tu.item_id AS item_id
	  ,      trunc(r.return_date) - trunc(r.check_out_date) as rental_item_price
	  ,      cl.common_lookup_id AS rental_item_type
	  ,      1 AS created_by
	  ,      SYSDATE AS creation_date
	  ,      1 AS last_updated_by
	  ,      SYSDATE AS last_update_date
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
	  AND    ri.item_id = tu.item_id) source
  ON (target.rental_item_id = source.rental_item_id)
  WHEN MATCHED THEN
  UPDATE SET target.last_updated_by = source.last_updated_by
  ,          target.last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_item_s1.nextval
  , source.rental_id
  , source.item_id
  , source.created_by
  , source.creation_date
  , source.last_updated_by
  , source.last_update_date
  , source.rental_item_type
  , source.rental_item_price);
 
  -- Merge into TRANSACTION table.
  MERGE INTO transaction target
  USING ( SELECT t.transaction_id
	  ,      tu.payment_account_number AS transaction_account
	  ,      cl1.common_lookup_id AS transaction_type
	  ,      tu.transaction_date AS transaction_date
	  ,      SUM(tu.transaction_amount) AS transaction_amount
	  ,      r.rental_id AS rental_id
	  ,      cl2.common_lookup_id AS payment_method_type
	  ,      m.credit_card_number AS payment_account_number
	  ,      1 AS created_by
	  ,      SYSDATE AS creation_date
	  ,      1 AS last_updated_by
	  ,      SYSDATE AS last_update_date
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
	  , m.credit_card_number) source
  ON (target.transaction_id = source.transaction_id)
  WHEN MATCHED THEN
  UPDATE SET target.last_updated_by = source.last_updated_by
  ,          target.last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( transaction_s1.nextval
  , source.transaction_account
  , source.transaction_type
  , source.transaction_date
  , source.transaction_amount
  , source.rental_id
  , source.payment_method_type
  , source.payment_account_number
  , source.created_by
  , source.creation_date
  , source.last_updated_by
  , source.last_update_date);
 
  -- Save the changes.
  COMMIT;
 
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END;
/
 
EXECUTE upload_transaction;

COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;

EXECUTE upload_transaction;

COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;

SELECT MAX(to_char(transaction_date, 'MON-YYYY')) AS month
,      to_char(SUM(transaction_amount),'$9,999.99') AS base_revenue
,      to_char(SUM(transaction_amount)*1.1,'$9,999.99') AS "10_plus"
,      to_char(SUM(transaction_amount)*1.2,'$9,999.99') AS "20_plus"
,      to_char(SUM(transaction_amount)*1.1 - SUM(transaction_amount),'$9,999.99') AS "10_plus_less_b"
,      to_char(SUM(transaction_amount)*1.2 - SUM(transaction_amount),'$9,999.99') AS "20_plus_less_b"
FROM transaction
WHERE extract(year FROM transaction_date) = 2009
GROUP BY extract(month FROM transaction_date)
,        extract(year FROM transaction_date)
ORDER BY extract(month FROM transaction_date);


 
SPOOL OFF
