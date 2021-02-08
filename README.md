# public_suffix
Just for exercise. Implementation of public suffix list processing using PL/SQL for Oracle 19c
Use totally at your own risk. 
Based on https://publicsuffix.org/list/ spec

## What is done and what is not
Done - realization of processing psl with unicode
package public_suffix with methods

* loading_function (file_location String) - 
This function will load the updated list of suffixes from https://publicsuffix.org/list/public_suffix_list.dat 

* check_public_suffix (input String, assert_output String)
This function would return True if the public suffix extracted using the tool is equivalent to the asserted output. 

* extract_domain (input String) - This function will extract the domain from an e-mail or a full URL and "trim" it to the apex domain.

what is not here  - realization with Punycode (maybe later... )

--

## How to use
1. Ensure that you carefully read this readme
2. Ensure that you have properly installed oracle database software 19 on linux
3. Ensure that you have properly granted rights on /home/oracle directory
4. Be aware that installation scripts will create directory in your /oracle/home
5. Ensure that you have rights to create fully functional user scheme and directory in your target DB
6. Ensure that you cant acccess https://publicsuffix.org/list/public_suffix_list.dat from target server

After saving this in your preferable directory 

7. Run dba_pre_install.sql under your DBA account (attention to steps 1-5, user and directory must be created)
8. Run psl_install.sql
9. Run psl_post_install.sql (attention to step 6, the files will be loaded from web and to table)
10. Now you probably can carefully use package psl.public_suffix and run test scripts (step 11)
11. Run test.sh to check the correctness of realization (result must be shown on screen and test WILL NOT change any data)


## What is in the package:

install directory - contains scheme\user\object installation files

install/dba - contains files that requires DBA rights on target DB

install/psl - contains files with psl scheme objects

post_install - contains post installation script (command for loading public suffix list)

sh - contains bash scripts for loading public suffix list (from https://publicsuffix.org/list/public_suffix_list.dat) 
     and tests (from https://raw.githubusercontent.com/publicsuffix/list/master/tests/test_psl.txt)
     
tests - contains files with runnable tests over public_suffix realization

dba_pre_install.sql:
  creates user psl (pass psl) with necessary grants
  creates directory /home/oracle/psl
  creates same directory on Oracle DB
  grants rights on this directory to psl user

psl_install.sql
  creates objects for psl user

psl_post_install.sql
  loads list from urls shown above and prepares table loadings
  
psl_uninstal.sql
  makes cascade deletion of psl scheme

public_suffix_list.dat 
  Itself

test.sh
  runs tests via sqlplus over this relization of public suffix list processing
  

