drop table mytable;

create table mytable
( mytable_id number
, mytable_text varchar2(20)
, mytable_date date);

insert into mytable values(1,'1','05-NOV-14');
insert into mytable values(2,'2','05-OCT-67');
insert into mytable values(3,'3','05-NOV-2067 11:12:13');
insert into mytable values(3,'3',to_date('05-NOV-2067 11:12:13', 'DD-MON-YYYY HH24:MI:SS'));
insert into mytable values(NULL, NULL, NULL);
insert into mytable values(NULL, NULL);
insert into mytable (mytable_id,mytable_date) values(5, trunc(sysdate));
insert into mytable (mytable_id,mytable_date) values(6, sysdate);

set NULL '<NULL>'
show feedback
set feedback on

select mytable_id
, mytable_text
, to_char(mytable_date, 'DD-MON-YYYY HH24:MI:SS')
from mytable;

