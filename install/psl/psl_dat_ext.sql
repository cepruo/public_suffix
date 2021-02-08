prompt creating table psl_dat_ext
create table psl_dat_ext (
    rule varchar2(4000)
) organization external 
    (type oracle_loader
    default directory psl_dir 
    access parameters 
    (    
         records delimited by '\n'
         logfile psl_dir : 'psl_load.log'
         fields terminated by '\n'
         missing field values are null
    ) location ( 'public_suffix_list.dat' ));
prompt creating table psl_dat_ext done
