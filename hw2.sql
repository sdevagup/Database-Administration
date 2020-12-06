// Browse the original init.ora in C:\app\YourID\admin\InstanceName\pfile.What’s the Memory_Target size in MB?//

S:\app\sdevagup\admin\sdevagupPDBA\pfile
compatible=11.2.0.0.0
db_unique_name=sdevagupDBA
diagnostic_dest=S:\app\sdevagup
memory_target=6818889728(6819MB)

//Copy C:\app\YourID\product\11.2.0\db_1\database\spfileInstanceName.ora to Word and then write down each memory
component size of SGA in MB (round up to a whole number)//

S:\app\sdevagup\product\11.2.0\dbhome_1\database\SPFILEsdevagupDBA.ora
sdevagupdba.__db_cache_size=3254779904(3255MB)
sdevagupdba.__java_pool_size=16777216(17MB)
sdevagupdba.__large_pool_size=16777216(17MB)
sdevagupdba.__oracle_base='S:\app\sdevagup'#ORACLE_BASE set from environment
sdevagupdba.__pga_aggregate_target=2734686208(2735MB)
sdevagupdba.__sga_target=4093640704(4094MB)
sdevagupdba.__shared_io_pool_size=0
sdevagupdba.__shared_pool_size=754974720(755MB)
sdevagupdba.__streams_pool_size=0
*._memory_broker_stat_interval=5
*._memory_management_tracing=31
*._PX_use_large_pool=TRUE
*.audit_file_dest='S:\app\sdevagupC C":. t\admin\sdevagupDBA\adump'
*.audit_trail='db'
*.compatible='11.2.0.0.0'
*.control_files='S:\app\sdevagup\oradata\sdevagupDBA\control01.ctl','S:\app\sdevagup\flash_recovery_are
a\sdevagupDBA\control02.ctl'
*.db_block_size=8192
*.db_domain=''
*.db_name='sdevagupDB'
*.db_recovery_file_dest='S:\app\sdevagup\flash_recovery_area'
*.db_recovery_file_dest_size=4102029312
*.db_unique_name='sdevagupDBA'
*.diagnostic_dest='S:\app\sdevagup'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=sdevagupDBAXDB)'
*.local_listener='LIC C" $. STENER_sdevagupDBA'
*.memory_target=419430400(419MB)
*.open_cursors=300
*.parallel_adaptive_multi_user=FALSE
*.parallel_execution_message_size=36864
*.parallel_max_servers=20
*.pga_aggregate_target=0
*.processes=100
*.remote_login_passwordfile='EXCLUSIVE'
*.sga_target=0
*.undo_tablespace='UNDOTBS1'

//  Start a SQL*Plus session as user SYS, display SGA and convert each memory component to MB//

SQL> SHOW SGA
Total System Global Area 6797832192 bytes(6798MB)
Fixed Size 2188648 bytes(2.2MB)
Variable Size 3523218072 bytes(3523MB)
Database Buffers 3254779904 bytes(3255MB)
Redo Buffers 17645568 bytes(17.6MB)

//Using SQL*PLUS, connect to the database as the SYS user. Run the following script to create a user and tablespaces. //

SQL> create tablespace tbsga datafile 'tbsga.dbf' size 20m reuse;
Tablespace created.
SQL> create temporary tablespace mytemp tempfile 'mytemp.dbf' size 40m reuse;
Tablespace created.
SQL> create user amm identified by amm default tablespace tbsga temporary tablespace mytemp;
User created.
SQL> grant connect,resource,dba to amm;
Grant succeeded.

//. In SQL*PLUS, connect as amm to run the following script and then log out//

SQL> conn amm
Enter password:
Connected.
SQL> create table tabsga(a number, b number) tablespace tbsga;
Table created.
SQL>
SQL> begin
 2 for i in 1..100000 loop
 3 insert into tabsga values (i, i);
 4 end loop;
 5 end;
 6 /
PL/SQL procedure successfully completed.
SQL> commit;
Commit complete.
SQL>
SQL> alter table tabsga parallel 16;
Table altered.
SQL>
SQL> create or replace procedure testpga( psize number ) as
 2 begin
 3 declare
 4 TYPE nAllotment_tabtyp IS TABLE OF char(2048) INDEX BY BINARY_INTEGER;
 5 myarray nAllotment_tabtyp;
 6 begin
 7 for i in 1..psize loop
 8 myarray(i) := to_char(i);
 9 end loop;
10 end;
11 end;

// Start a SQL*Plus session as user SYS and then run the following script to make sure parallel queries run during this
assignment are using large pool memory for better visualization later in Enterprise Manager.//

SQL> alter system set "_PX_use_large_pool" = TRUE SCOPE=SPFILE;
System altered.
SQL> alter system set "_memory_broker_stat_interval" = 5 SCOPE=SPFILE;
System altered.
SQL> alter system set "_memory_management_tracing" = 31 SCOPE=SPFILE;
System altered.
SQL> alter system set "parallel_execution_message_size" = 36864 SCOPE=SPFILE;
System altered.
SQL> alter system set "parallel_adaptive_multi_user" = FALSE SCOPE=SPFILE;
System altered.
SQL> alter system set "parallel_max_servers" = 20 SCOPE=SPFILE;
System altered.
SQL> alter system set "processes" = 100 SCOPE=SPFILE;
System altered.
SQL> alter system set "pga_aggregate_target" = 0 SCOPE=SPFILE;
System altered.
SQL> alter system set "sga_target" = 0 SCOPE=SPFILE;
System altered.
SQL> alter system set "memory_target" = 400M SCOPE=SPFILE;
System altered

// . Shut down Oracle and then restart Oracle. Write down all memory components in MB.//

SQL> shutdown immediate
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> startup
ORACLE instance started.
Total System Global Area 417546240 bytes(418MB)
Fixed Size 2176328 bytes(2.18MB)
Variable Size 264243896 bytes(264MB)
Database Buffers 142606336 bytes(143MB)
Redo Buffers 8519680 bytes(8.5MB)
Database mounted.
Database opened.

//. From the same DOS SQL*PLUS session, connect as user amm (password amm), and execute the following
script. This script starts a parallel query with a degree of parallelism set to 12. Refresh OEM and take a screen print
of SGA Allocation History.//

SQL> select /*+ PARALLEL (s 12) */ count(*) from (select /*+ parallel(s 12) */ * from tabsga s group
by a);
 COUNT(*)
----------
 100000

//Take a 5 minute break. From the same session, execute another script as follows. This script starts the same parallel
query with a degree of parallelism set to 24. Refresh OEM and take a screen print of SGA Allocation History//

SQL> select /*+ PARALLEL(s 24) */ count(*) from (select /*+ parallel(s 24) */ * from tabsga s group
by a);
 COUNT(*)
----------
 100000

//From the same session, execute the following script. This script invokes a PL/SQL procedure that build a big array in
memory.//
SQL> create or replace procedure testpga( psize number ) as
 2 begin
 3 declare
 4 TYPE nAllotment_tabtyp IS TABLE OF char(2048) INDEX BY BINARY_INTEGER;
 5 myarray nAllotment_tabtyp;
 6 begin
 7 for i in 1..psize loop
 8 myarray(i) := to_char(i);
 9 end loop;
10 end;
11 end;
12 /
Procedure created.
SQL> Exec testpga(300000)
PL/SQL procedure successfully completed.

//4. Exit from your SQL*Plus session. Using SQL*PLUS, connect to the database as the SYS user.
 Execute the following script to clean up the environment. //

SQL> drop user amm cascade;
User dropped.
SQL> drop tablespace tbsga including contents and datafiles;
Tablespace dropped.
SQL> drop tablespace mytemp including contents and datafiles;
Tablespace dropped 

//Using SQL*PLUS, connect to the database as the SYS user to reconfigure Oracle memory components:
 a. Disable Automatic Memory Management.//

 Disable Automatic Memory Management.
 SQL>ALTER SYSTEM SET MEMORY_TARGET=0;
System altered.
b. Change sga_target to 480MB
SQL>ALTER SYSTEM SET SGA_TARGET= 400M;
System altered.
 c. Change Database buffer cache to 135 MB
 SQL>ALTER SYSTEM SET DB_CACHE_SIZE= 135M;
System altered.
d. Change Shared pool to 123 MB
SQL>ALTER SYSTEM SET SHARED_POOL_SIZE= 123M;
System altered.
e. Change Large pool to 15 MB
SQL>ALTER SYSTEM SET LARGE_POOL_SIZE= 15M;
System altered.
f. Change JAVA pool to 9 MB
SQL>ALTER SYSTEM SET JAVA_POOL_SIZE= 9M;
System altered.
g. Change pga_aggregate_target to 80 MB
SQL>ALTER SYSTEM SET PGA_AGGREGATE_TARGET= 80M;
System altered.

// . Shutdown and restart Oracle. //

SQL> shutdown immediate
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> startup mount
ORACLE instance started.
Total System Global Area 417546240 bytes
Fixed Size 2176328 bytes
Variable Size 163580600 bytes
Database Buffers 243269632 bytes
Redo Buffers 8519680 bytes
Database mounted.

//  Invoke SQL*PLUS to create a new PFILE from the SPFILE. Place the PFILE in the directory
C:\app\YourID\admin\InstanceName\pfile with the file name format initInstanceName.ora. You must specify the full
path of both parameters (PFILE and SPFILE).//

SQL> CREATE PFILE=’S:\app\sdevagup\admin\sdevagupDBA\pfile\initsdevagupDBA.ora’ FROM
SPFILE=’S:\app\sdevagup\product\11.2.0\dbhome_1\database\SPFILEsdevagupDBA.ora’;
File created. 

// . Use Word to view the new PFILE you created (C:\app\YourID\admin\InstanceName\pfile\initInstanceName.ora).
Please write down db_cache_size, java_pool_size, large_pool_size, and shared_pool_size in MB. //

sdevagupdba.__db_cache_size=222298112(222MB)
sdevagupdba.__java_pool_size=12582912(12.5MB)
sdevagupdba.__large_pool_size=16777216(17MB)
sdevagupdba.__oracle_base='S:\app\Suchit'#ORACLE_BASE set from environment
sdevagupdba.__pga_aggregate_target=83886080(84MB)
sdevagupdba.__sga_target=419430400(419MB)
sdevagupdba.__shared_io_pool_size=0
sdevagupdba.__shared_pool_size=150994944(151MB)
sdevagupdba.__streams_pool_size=4194304
*._memory_broker_stat_interval=5
*._memory_management_tracing=31
*._PX_use_large_pool=TRUE
*.audit_file_dest='S:\app\sdevagup\admin\sdevagupDBA\adump'
*.audit_trail='db'
*.compatible='11.2.0.0.0'
*.control_files='S:\app\sdevagup\oradata\sdevagupDBA\control01.ctl','S:\app\sdevagup\flash_recovery_are
a\sdevagupDBA\control02.ctl'
*.db_block_size=8192
*.db_cache_size=142606336(143MB)
*.db_domain=''
*.db_name='sdevagupDB'
*.db_recovery_file_dest='S:\app\sdevagup\flash_recovery_area'
*.db_recovery_file_dest_size=4102029312
*.db_unique_name='sdevagupDBA'
*.diagnostic_dest='S:\app\sdevagup'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=sdevagupDBAXDB)'
*.java_pool_size=12582912(13MB)
*.large_pool_size=16777216(17MB)
*.local_listener='LISTENER_sdevagupDBA'
*.memory_target=0
*.open_cursors=300
*.parallel_adaptive_multi_user=FALSE
*.parallel_execution_message_size=36864
*.parallel_max_servers=20
*.pga_aggregate_target=83886080(84MB)
*.processes=100
*.remote_login_passwordfile='EXCLUSIVE'
*.sga_target=419430400(419MB)
*.shared_pool_size=130023424(130MB)
*.undo_tablespace='UNDOTBS1

// Shut down the database and then restart Oracle Instance with open it in read-only mode.//

SQL> shutdown immediate
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> startup mount
ORACLE instance started.
Total System Global Area 417546240 bytes
Fixed Size 2176328 bytes
Variable Size 184552120 bytes
Database Buffers 222298112 bytes
Redo Buffers 8519680 bytes
Database mounted.
SQL> ALTER DATABASE OPEN READ ONLY;
Database altered.

// . Note: Please make sure you completed Lab#1B, which unlocked user Scott and set up a password.
From the existing Windows SQL*Plus session, connect as user Scott password Tiger. Browse the DEPT
 table and then insert a row into the DEPT table as follows:
INSERT INTO DEPT VALUES (50, ‘Leagal’,’Seattle’); What happens? //

SQL> connect scott
Enter password:
Connected.
SQL> SELECT * FROM DEPT;
 DEPTNO DNAME LOC
---------- -------------- -------------
 10 ACCOUNTING NEW YORK
 20 RESEARCH DALLAS
 30 SALES CHICAGO
 40 OPERATIONS BOSTON
SQL> INSERT INTO DEPT VALUES (50, ‘Leagal’,’Seattle’);
ERROR:
ORA-01756: quoted string not properly terminated

// Put the database back in read-write mode//

 SQL> connect sys as sysdba
Enter password:
Connected.
SQL> shutdown immediate
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> startup
ORACLE instance started.
Total System Global Area 417546240 bytes
Fixed Size 2176328 bytes
Variable Size 188746424 bytes
Database Buffers 218103808 bytes
Redo Buffers 8519680 bytes
Database mounted.
Database opened.

//Connect user Scott and insert the following row into the DEPT table//

INSERT INTO DEPT VALUES (50, 'Legal', 'Seattle');
 Query the DEPT table to list all the records.
SQL> connect scott
Enter password:
Connected.
SQL> INSERT INTO DEPT VALUES (50, 'Legal', 'Seattle');
1 row created.
SQL> SELECT * FROM DEPT;
 DEPTNO DNAME LOC
---------- -------------- -------------
 50 Legal Seattle
 10 ACCOUNTING NEW YORK
 20 RESEARCH DALLAS
 30 SALES CHICAGO
 40 OPERATIONS BOSTON









