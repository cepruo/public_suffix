prompt Creating user PSL (psl)
create user PSL identified by psl;
grant connect, resource to psl;
alter user psl quota 100M on users;
prompt user DONE

