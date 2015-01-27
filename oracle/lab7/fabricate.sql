DROP TABLE doughnut;

CREATE TABLE doughnut
( doughnut_id integer
, doughnut_name varchar(30));

INSERT INTO doughnut
VALUES (1, 'Glazed');

INSERT INTO doughnut
VALUES (2, 'Old Fashioned');

INSERT INTO doughnut
VALUES (3, 'Chocolate Cake Plain');

INSERT INTO doughnut
VALUES (4, 'White Cake Plain');

INSERT INTO doughnut
VALUES (5, 'Chocolate Old Fashioned');

INSERT INTO doughnut
VALUES (6, 'Glazed with Sprinkles');

SELECT * FROM doughnut;

SELECT d.doughnut_name
,      f.quantity
FROM   doughnut d CROSS JOIN (SELECT 2 AS quantity FROM dual) f;

-- Glazed are .60
-- Old Fasioned are .75
-- All others are .80

DROP TABLE doughnut_price;

CREATE TABLE doughnut_price
( doughnut_price_id integer
, doughnut_id integer
, price float);

DROP   SEQUENCE doughnut_price_s;
CREATE SEQUENCE doughnut_price_s;

SELECT d.doughnut_id
,      d.doughnut_name
,      dp.doughnut_price
FROM   doughnut d INNER JOIN
      (SELECT 'Glazed' AS doughnut_type
      ,       .60 AS doughnut_price FROM dual
       UNION ALL
       SELECT 'Old Fashioned' AS doughnut_type
      ,       .75 AS doughnut_price FROM dual
       UNION ALL
       SELECT 'cake' AS doughnut_type
      ,       .80 AS doughnut_price FROM dual) dp
ON    regexp_like(d.doughnut_name,dp.doughnut_type,'i');





INSERT INTO doughnut_price
( SELECT doughnut_price_s.nextval
, fdp.doughnut_id
, fdp.doughnut_price
FROM (SELECT d.doughnut_id
,      d.doughnut_name
,      dp.doughnut_price
FROM   doughnut d INNER JOIN
      (SELECT 'Glazed' AS doughnut_type
      ,       .60 AS doughnut_price FROM dual
       UNION ALL
       SELECT 'Old Fashioned' AS doughnut_type
      ,       .75 AS doughnut_price FROM dual
       UNION ALL
       SELECT 'cake' AS doughnut_type
      ,       .80 AS doughnut_price FROM dual) dp
ON    regexp_like(d.doughnut_name,dp.doughnut_type,'i')) fdp);

SELECT * FROM doughnut_price;

SELECT d.doughnut_name, dp.price
FROM   doughnut d INNER JOIN doughnut_price dp USING (doughnut_id);

