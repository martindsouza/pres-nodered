select distinct year
from name_lov
order by year_count desc
;

select count(*)
from name_lov;

truncate table name_lov;

drop table name_lov;

create table name_lov (
  name_lov_id number generated by default as identity,
  fname varchar2(255) not null,
  sex varchar2(1) not null,
  file_year number not null,
  year_count number not null,
  created_on date default sysdate not null,
	created_by varchar2(255 byte) default
    coalesce(
      sys_context('APEX$SESSION','app_user'),
      regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*'),
      sys_context('userenv','session_user')
    )
    not null
    ,
	last_updated_on date,
	last_updated_by varchar2(255 byte)
);



