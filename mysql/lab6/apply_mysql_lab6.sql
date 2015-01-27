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
--   mysql> \. apply_mysql_lab6.sql
--
--  or, the more verbose syntax:
--
--   mysql> source apply_mysql_lab6.sql
--
-- ----------------------------------------------------------------------
use studentdb
-- Call the basic seeding scripts, this scripts TEE their own log
-- files. That means this script can only start a TEE after they run.
\. /home/student/Data/cit225/mysql/lib/cleanup.sql
\. /home/student/Data/cit225/mysql/lib/create_mysql_store_ri2.sql
\. /home/student/Data/cit225/mysql/lib/seed_mysql_store_ri2.sql

-- Add your lab here:
-- ----------------------------------------------------------------------

TEE apply_lab6_mysql.txt

-- 1. [2 points] Add the RENTAL_ITEM_PRICE and RENTAL_ITEM_TYPE columns to the RENTAL_ITEM table. Both columns should use a NUMBER data type in Oracle, and an int unsigned data type for MySQL.

ALTER TABLE rental_item
  ADD (rental_item_type INT UNSIGNED),
  ADD (rental_item_price INT UNSIGNED),
  ADD CONSTRAINT fk_rental_item_5 FOREIGN KEY (rental_item_type) REFERENCES common_lookup (common_lookup_id);

-- Diagnostic for 1.

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
 
-- 2. [3 points] Create the following PRICE table as per the specification, like the description below.

CREATE TABLE price
( price_id                    INT UNSIGNED     PRIMARY KEY AUTO_INCREMENT
, item_id                     INT UNSIGNED     NOT NULL
, price_type                  INT UNSIGNED       
, active_flag                 ENUM('Y','N')    NOT NULL
, start_date                  DATE             NOT NULL
, end_date                    DATE       
, amount                      DOUBLE(10,2)     NOT NULL    
, created_by                  INT UNSIGNED     NOT NULL  
, creation_date               DATE             NOT NULL  
, last_updated_by             INT UNSIGNED     NOT NULL    
, last_update_date            DATE             NOT NULL  
, CONSTRAINT fk_price_1       FOREIGN KEY(item_id) REFERENCES item(item_id)
, CONSTRAINT fk_price_2       FOREIGN KEY(price_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_price_3       FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_price_4       FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Diagnostic for CREATE TABLE

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'price'
ORDER BY 2;

-- 3. [10 points] A. Insert new data as follows:

ALTER TABLE item CHANGE item_release_date release_date DATE NOT NULL;

-- Diagnostic for column rename

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'item'
ORDER BY 2;

-- 3.B

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_rating_id
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000REE2VW'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Annabelle'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'R'
  AND      rating_agency = 'MPAA')
,'2014-10-24'
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_rating_id
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000REE3RZ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Interstellar'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2014-11-07'
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_rating_id
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000RER4SZ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Ouija'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'R'
  AND      rating_agency = 'MPAA')
,'2014-10-23'
, 1001, UTC_DATE(), 1001, UTC_DATE());

-- Diagnostic for 3-row insert:

SELECT   i.item_title
,        UTC_DATE() AS today
,        i.release_date
FROM     item i
WHERE    DATEDIFF(UTC_DATE(),i.release_date) < 31;

-- 3.C

INSERT INTO member
( account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
('B293-71446'
,'4332-8865-3884-2363'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 1001, UTC_DATE(), 1001, UTC_DATE());

SET @lv_member_id := last_insert_id();

INSERT INTO contact
( member_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
(@lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Harry','Potter'
, 1001, UTC_DATE(), 1001, UTC_DATE());

SET @lv_contact_id := last_insert_id();

INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','Utah','84601'
, 1001, UTC_DATE(), 1001, UTC_DATE());

SET @lv_address_id := last_insert_id();

INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_address_id
,'1100 N 500 S'
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,@lv_address_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','801','895-4577'
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO contact
( member_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
(@lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Ginny','Potter'
, 1001, UTC_DATE(), 1001, UTC_DATE());

SET @lv_contact_id := last_insert_id();

INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','Utah','84601'
, 1001, UTC_DATE(), 1001, UTC_DATE());

SET @lv_address_id := last_insert_id();

INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_address_id
,'1100 N 500 S'
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,@lv_address_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','801','895-4578'
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO contact
( member_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
(@lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Lily','Luna','Potter'
, 1001, UTC_DATE(), 1001, UTC_DATE());

SET @lv_contact_id := last_insert_id();

INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','Utah','84601'
, 1001, UTC_DATE(), 1001, UTC_DATE());

SET @lv_address_id := last_insert_id();

INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_address_id
,'1100 N 500 S'
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,@lv_address_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','801','895-4579'
, 1001, UTC_DATE(), 1001, UTC_DATE());

-- Diagnostic for 3.C

SELECT   m.member_id
,        c.contact_id
,        CONCAT(c.last_name,', ',c.first_name) AS full_name
,        a.city
,        a.state_province AS state
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';

-- 3.D

INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Harry')
, UTC_DATE(), DATE_ADD(UTC_DATE(),INTERVAL 1 DAY)
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Ginny')
, UTC_DATE(), DATE_ADD(UTC_DATE(),INTERVAL 3 DAY)
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Lily')
, UTC_DATE(), DATE_ADD(UTC_DATE(),INTERVAL 5 DAY)
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Harry')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Annabelle'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Harry')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Ouija'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Ginny')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Interstellar'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Lily')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Annabelle'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001, UTC_DATE(), 1001, UTC_DATE());

-- Diagnostic for 3.D

SELECT   CONCAT(c.last_name,', ',c.first_name,' ',IFNULL(c.middle_name,'')) AS full_name
,        r.rental_id
,        DATEDIFF(r.return_date,r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE    DATEDIFF(UTC_DATE(),r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY CONCAT(c.last_name,', ',c.first_name,' ',c.middle_name)
,        r.rental_id
,        DATEDIFF(r.return_date,r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;

-- 4. [20 points] Modify the design of the COMMON_LOOKUP table, insert new data into the model, and update old non-compliant design data in the model.

-- 4.A Drop the COMMON_LOOKUP_U1 index.

DROP INDEX common_lookup_u1 ON common_lookup;

-- Diagnostic for 4.A

SELECT   table_name
,        constraint_name
,        constraint_type
FROM     information_schema.table_constraints
WHERE    table_name = 'common_lookup';

-- 4.B Add three new columns to the COMMON_LOOKUP table.

ALTER TABLE common_lookup
  ADD (common_lookup_table  VARCHAR(30)),
  ADD (common_lookup_column VARCHAR(30)),
  ADD (common_lookup_code   VARCHAR(30));

-- Diagnostic for 4.B

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'common_lookup'
ORDER BY 2;

-- 4.C Migrate data and populate (or seed) new columns with existing data.

UPDATE common_lookup
SET    common_lookup_table = common_lookup_context
WHERE  common_lookup_context != 'MULTIPLE';

UPDATE common_lookup
SET    common_lookup_table = 'ADDRESS'
WHERE  common_lookup_context = 'MULTIPLE';

UPDATE common_lookup
SET    common_lookup_column = CONCAT(common_lookup_context,'_TYPE')
WHERE  common_lookup_table = 'MEMBER'
AND    (common_lookup_type = 'INDIVIDUAL' OR common_lookup_type = 'GROUP');

UPDATE common_lookup
SET    common_lookup_column = 'CREDIT_CARD_TYPE'
WHERE  common_lookup_type = 'VISA_CARD'
OR     common_lookup_type = 'MASTER_CARD'
OR     common_lookup_type = 'DISCOVER_CARD';

UPDATE common_lookup
SET    common_lookup_column = 'ADDRESS_TYPE'
WHERE  common_lookup_context = 'MULTIPLE';

UPDATE common_lookup
SET    common_lookup_column = CONCAT(common_lookup_context,'_TYPE')
WHERE  common_lookup_context != 'MEMBER'
AND    common_lookup_context != 'MULTIPLE';

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column)
VALUES
('MULTIPLE','HOME','Home', 1001, UTC_DATE(), 1001, UTC_DATE(),'TELEPHONE','TELEPHONE_TYPE');

INSERT INTO common_lookup
( common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column)
VALUES
('MULTIPLE','WORK','Work', 1001, UTC_DATE(), 1001, UTC_DATE(),'TELEPHONE','TELEPHONE_TYPE');

UPDATE telephone
SET telephone_type = 
 (SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME'
  AND      common_lookup_table = 'TELEPHONE');

-- Diagnostics for 4.C

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'common_lookup'
ORDER BY 2;

SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;


SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;


-- 4.D Remove obsolete columns, apply not null constraints, and create a new unique index for the natural key of the COMMON_LOOKUP table.

ALTER TABLE common_lookup
  DROP COLUMN common_lookup_context;

ALTER TABLE common_lookup
  MODIFY common_lookup_table VARCHAR(30) NOT NULL,
  MODIFY common_lookup_column VARCHAR(30) NOT NULL;

CREATE UNIQUE INDEX nk_common_lookup
  ON common_lookup(common_lookup_table,common_lookup_column,common_lookup_type);

-- Diagnostics for 4.D

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'common_lookup'
ORDER BY 2;

SELECT   tc.table_name
,        tc.constraint_name
,        kcu.ordinal_position
,        kcu.column_name
,        tc.constraint_type
FROM     information_schema.table_constraints tc
JOIN     information_schema.key_column_usage kcu
ON       tc.table_schema = kcu.table_schema
AND      tc.table_name = kcu.table_name
AND      tc.constraint_name = kcu.constraint_name
WHERE    tc.table_name = 'common_lookup'
AND      tc.constraint_type = 'UNIQUE';


NOTEE
