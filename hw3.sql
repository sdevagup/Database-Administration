// Create a permanent tablespace with the following name and storage - DATA01 (1MB) locally managed with uniform
sized extents. Ensure that every used extent size in the tablespace is a multiple of 100 KB //

SQL> CREATE TABLESPACE data01 DATAFILE 'S:\app\sdevagup\oradata\sdevagupDBA\data01.dbf' SIZE 1M EXTENT
MANAGEMENT LOCAL UNIFORM SIZE 100K;
Tablespace created.
SQL> COLUMN name FORMAT a50
SQL> SET LINESIZE 80
SQL> SET PAGESIZE 999
SQL> SELECT name, bytes, create_bytes FROM v$datafile;

NAME BYTES CREATE_BYTES
-------------------------------------------------- ---------- ------------
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\SYSTEM01.DBF 723517440 0
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\SYSAUX01.DBF 587202560 0
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\UNDOTBS01.DBF 57671680 0
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\USERS01.DBF 5242880 0
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\EXAMPLE01.DBF 104857600 104857600
S:\APP\SDEVAGUP\ORADATA\LAB454.HOLLYWOOD.DBF 5242880 5242880
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\DATA01.DBF 1048576 1048576
7 rows selected. 

//  Create a permanent tablespace with the following name and storage - INDEX02 (2MB) locally managed with uniform
sized extents of 40K. Enable automatic extension of 500 KB when more extents are required with a maximum size of 5 MB //

SQL> CREATE TABLESPACE index02 DATAFILE 'S:\app\sdevagup\oradata\sdevagupDBA\index02.dbf' SIZE 2M AUTOEXTEND ON
NEXT 500K MAXSIZE 5M
 2 EXTENT MANAGEMENT LOCAL UNIFORM SIZE 40K;
Tablespace created.
SQL> COLUMN name FORMAT a50
SQL> SET LINESIZE 80
SQL> SET PAGESIZE 999
SQL> SELECT name, bytes, create_bytes FROM v$datafile;
NAME BYTES CREATE_BYTES
-------------------------------------------------- ---------- ------------
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\SYSTEM01.DBF 723517440 0
S:\APP\SDEVGAUP\ORADATA\SDEVAGUPDBA\SYSAUX01.DBF 587202560 0
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\UNDOTBS01.DBF 57671680 0
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\USERS01.DBF 5242880 0
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\EXAMPLE01.DBF 104857600 104857600
S:\APP\SDEVAGUP\ORADATA\LAB454.HOLLYWOOD.DBF 5242880 5242880
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\DATA01.DBF 1048576 1048576
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\INDEX01.DBF 2097152 2097152
8 rows selected. 

// Create a permanent tablespace with the following name and storage – RONLY03 (3MB) for read-only tables with the
default storage. DO NOT make the tablespace read only at this time //

SQL> CREATE TABLESPACE ronly03 DATAFILE 'S:\app\sdevagup\oradata\sdevagupDBA\ronly03.dbf' SIZE 3M;
Tablespace created.
SQL> COLUMN name FORMAT a50
SQL> SET LINESIZE 80
SQL> SET PAGESIZE 999
SQL> SELECT name, bytes, create_bytes FROM v$datafile;
NAME BYTES CREATE_BYTES
-------------------------------------------------- ---------- ------------
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\SYSTEM01.DBF 723517440 0
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\SYSAUX01.DBF 587202560 0
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\UNDOTBS01.DBF 57671680 0
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\USERS01.DBF 5242880 0
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\EXAMPLE01.DBF 104857600 104857600
S:\APP\SDEVAGUP\ORADATA\LAB454.HOLLYWOOD.DBF 5242880 5242880
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\DATA01.DBF 1048576 1048576
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\INDEX01.DBF 2097152 2097152
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\RONLY03.DBF 3145728 3145728
9 rows selected. 

//Display the tablespace information from the data dictionary //

SQL> SELECT TABLESPACE_NAME "TABLESPACE",
 2 INITIAL_EXTENT "INITIAL_EXT",
 3 NEXT_EXTENT "NEXT_EXT",
 4 MIN_EXTENTS "MIN_EXT",
 5 MAX_EXTENTS "MAX_EXT",
 6 PCT_INCREASE
 7 FROM DBA_TABLESPACES;
TABLESPACE INITIAL_EXT NEXT_EXT MIN_EXT MAX_EXT
------------------------------ ----------- ---------- ---------- ----------
PCT_INCREASE
------------
SYSTEM 65536 1 2147483645
SYSAUX 65536 1 2147483645
UNDOTBS1 65536 1 2147483645
TEMP 1048576 1048576 1
 0
USERS 65536 1 2147483645
EXAMPLE 65536 1 2147483645
HOLLYWOOD 65536 1 2147483645
DATA01 106496 106496 1 2147483645
 0
INDEX02 40960 40960 1 2147483645 
3 | P a g e
 0

RONLY03 65536 1 2147483645
10 rows selected

// Allocate 500K more disk space to tablespace DATA01 and verify the result. (Hint: Query v$datafile)//

SQL> ALTER DATABASE DATAFILE 'S:\app\sdevagup\oradata\sdevagupDBA\data01.dbf' RESIZE 500K;
Database altered.
SQL> COLUMN name FORMAT a40
SQL> SELECT name, bytes, create_bytes FROM v$datafile WHERE name LIKE '%data01%';
no rows selected

// Create a new directory called U4 in C:\. Relocate tablespace INDEX02 to C:\U4. Verify relocation and status of INDEX02.//

SQL> ALTER TABLESPACE index02 OFFLINE;
Tablespace altered.
SQL> SELECT name, status FROM v$datafile;
NAME STATUS
---------------------------------------- -------
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\SYSTEM01 SYSTEM
.DBF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\SYSAUX01 ONLINE
.DBF
S:\APP\SDEVAGUP\ORADATA\SDEVGAUPDBA\UNDOTBS0 ONLINE
1.DBF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\USERS01. ONLINE
DBF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\EXAMPLE0 ONLINE
1.DBF
S:\APP\SDEVAGUP\ORADATA\LAB454.HOLLYWOOD.D ONLINE
BF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\DATA01.D ONLINE
BF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\INDEX01. OFFLINE
DBF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\RONLY03. ONLINE
DBF
9 rows selected.
SQL> HOST move S:\app\sdevagup\oradata\sdevagupDBA\index02.dbf S:\app\sdevagup\oradata\sdevagupDBA\U4\index02.dbf
1 file(s) moved.
SQL> ALTER TABLESPACE index02 RENAME DATAFILE 'S:\app\sdevagup\oradata\sdevagupDBA\index02.dbf' TO
'S:\app\sdevagup\oradata\sdevagupDBA\U4\index02.dbf';
Tablespace altered.
SQL> ALTER TABLESPACE index02 ONLINE; 
4 | P a g e
Tablespace altered.
SQL> SELECT name, status FROM v$datafile;
NAME STATUS
---------------------------------------- -------
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\SYSTEM01 SYSTEM
.DBF
S:\APP\SDEVAGUP\ORADATA\SDEAVGUPDBA\SYSAUX01 ONLINE
.DBF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\UNDOTBS0 ONLINE
1.DBF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\USERS01. ONLINE
DBF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\EXAMPLE0 ONLINE
1.DBF
S:\APP\SDEVAGUP\ORADATA\LAB454.HOLLYWOOD.D ONLINE
BF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\DATA01.D ONLINE
BF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\INDEX01. ONLINE
DBF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\RONLY03. ONLINE
DBF
9 rows selected

//Create a table with only one column in tablespace RONLY03. Make tablespace RONLY03 read-only. Run a query to verify it.//
SQL> CREATE TABLE table1 ( x CHAR(1)) TABLESPACE ronly03;
Table created.
SQL> ALTER TABLESPACE ronly03 READ ONLY;
Tablespace altered. 

//Attempt to create an additional table TABLE2 with only one column in RONLY03. Drop the first created table, TABLE1.
 What happens? //
SQL> CREATE TABLE table1 ( x CHAR(1)) TABLESPACE ronly03;
Table created.
SQL> SELECT name, enabled, status FROM v$datafile;
NAME ENABLED STATUS
---------------------------------------- ---------- -------
S:\APP\SDEVAGUP\ORADATA\SDEAVAGUPDBA\SYSTEM01 READ WRITE SYSTEM
.DBF
S:\APP\SDEAVAGUP\ORADATA\SDEVAGUPDBA\SYSAUX01 READ WRITE ONLINE
.DBF
S:\APP\SDEAVAGUP\ORADATA\SDEVAGUPDBA\UNDOTBS0 READ WRITE ONLINE
1.DBF 
5 | P a g e
S:\APP\SDEVAGUP\ORADATA\SDEAVAGUPDBA\USERS01. READ WRITE ONLINE
DBF
S:\APP\SDEVAGUP\ORADATA\SDEAVAGUPDBA\EXAMPLE0 READ WRITE ONLINE
1.DBF
S:\APP\SDEAVAGUP\ORADATA\LAB454.HOLLYWOOD.D READ WRITE ONLINE
BF
S:\APP\SDEAVAGUP\ORADATA\SDEAVAGUPDBA\DATA01.D READ WRITE ONLINE
BF
S:\APP\SDEVAGUP\ORADATA\SDEAVAGUPDBA\INDEX01. READ WRITE ONLINE
DBF
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\RONLY03. READ ONLY ONLINE
DBF
9 rows selected.
SQL> CREATE TABLE table2 ( y CHAR(1)) TABLESPACE ronly03;
Table created.
SQL> DROP TABLE table1;
Table dropped.

// Drop tablespace RONLY03 and the associated datafile. Verify it//
SQL> DROP TABLESPACE ronly03 INCLUDING CONTENTS AND DATAFILES;
Tablespace dropped.
SQL> SELECT * FROM v$tablespace;
 TS# NAME INC BIG FLA ENC
---------- ---------------------------------------- --- --- --- ---
 0 SYSTEM YES NO YES
 1 SYSAUX YES NO YES
 2 UNDOTBS1 YES NO YES
 4 USERS YES NO YES
 3 TEMP NO NO YES
 6 EXAMPLE YES NO YES
 9 HOLLYWOOD YES NO YES
 10 DATA01 YES NO YES
 11 INDEX02 YES NO YES
9 rows selected

//  Let’s try to use OMF. Please set DB_CREATE_FILE_DEST to C:\U4 in memory only.
 Create tablespace DATA03 size 5M without specifying a file location.
 What’s the datafile name associate with DATA03 tablespace? .//
SQL> ALTER SYSTEM SET DB_CREATE_FILE_DEST='S:\app\sdevagup\oradata\sdevagupDBA\U4' SCOPE=MEMORY;
System altered.
SQL> CREATE TABLESPACE data03 DATAFILE SIZE 5M;
Tablespace created.
SQL> SELECT * FROM v$tablespace; 
6 | P a g e
 TS# NAME INC BIG FLA ENC
---------- ---------------------------------------- --- --- --- ---
 0 SYSTEM YES NO YES
 1 SYSAUX YES NO YES
 2 UNDOTBS1 YES NO YES
 4 USERS YES NO YES
 3 TEMP NO NO YES
 6 EXAMPLE YES NO YES
 9 HOLLYWOOD YES NO YES
 10 DATA01 YES NO YES
 11 INDEX02 YES NO YES
 13 DATA03 YES NO YES
10 rows selected.

//Where is the existing control file located and what is the name?//

SQL> COL name FORMAT a50
SQL> SELECT * FROM v$controlfile;
STATUS NAME IS_ BLOCK_SIZE
------- -------------------------------------------------- --- ----------
FILE_SIZE_BLKS
--------------
 S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\CONTROL01.CTL NO 16384
 594
 S:\APP\SDEAVAGUP\FLASH_RECOVERY_AREA\SDEAVAGUPDBA\CONTRO NO 16384
 L02.CTL
 594

// Try to start the database without any control files. Simulate this by changing one of the control file in the parameter
 file or deleting one of the control file. What happens in the startup? What are the error messages in the Alert log?//

SQL> delete S:\app\sdevagup\oradata\sdevagupDBA\CONTROL01.CTL
 2 connect sys/goldy as sysdba
 3
SQL> connect sys/goldy as sysdba
Connected to an idle instance.
SQL> startup
ORACLE instance started.
Total System Global Area 417546240 bytes
Fixed Size 2176328 bytes
Variable Size 251660984 bytes
Database Buffers 155189248 bytes
Redo Buffers 8519680 bytes
Database mounted.
Database opened. 

//. Restore Control01.CTL from your recycle bin and then restart Oracle//
SQL> shutdown immediate
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> connect sys/goldy as sysdba
Connected to an idle instance.
SQL> startup
ORACLE instance started.
Total System Global Area 417546240 bytes
Fixed Size 2176328 bytes
Variable Size 251660984 bytes
Database Buffers 155189248 bytes
Redo Buffers 8519680 bytes
Database mounted.
Database opened. 

// Multiplex the existing control file as follows.
a). Add a new control file CONTROL04.CTL in C:\U4.
b). Confirm that both control files are being used.//
SQL> conn sys as sysdba
Enter password:
Connected.
SQL> ALTER SYSTEM SET control_files = 'S:\app\sdevagup\oradata\sdevagupDBA\control01.ctl',
 2 'S:\app\sdevagup\oradata\sdevagupDBA\U4\control04.ctl' SCOPE=SPFILE;
System altered. 
8 | P a g e
SQL> shutdown immediate
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> S:\app\sdevagup\product\11.2.0\dbhome_1\BIN>copy S:\app\sdevagup\oradata\sdevagupDBA\Control01.ctl
S:\app\sdevagup\oradata\sdevagupDBA\U4\Control04.ctl
 1 file(s) copied.
SQL> STARTUP
ORACLE instance started.
Total System Global Area 417546240 bytes
Fixed Size 2176328 bytes
Variable Size 251660984 bytes
Database Buffers 155189248 bytes
Redo Buffers 8519680 bytes
Database mounted.
Database opened.
SQL> SELECT name FROM v$controlfile;
NAME
--------------------------------------------------
copy S:\app\sdevagup\oradata\sdevagupDBA\CONTROL01.CTL
S:\app\sdevagup\oradata\sdevagupDBA\U4\CONTROL04.CTL 

//What is the initial sizing of the data file section in your control file?//

SQL> select * from v$controlfile_record_section;
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
DATABASE 316 1 1 0
 0 0
CKPT PROGRESS 8180 11 0 0
 0 0
REDO THREAD 256 8 1 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
REDO LOG 72 16 3 0
 0 3
DATAFILE 520 100 9 0
 0 43
FILENAME 524 2298 13 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
TABLESPACE 68 100 10 0
 0 30
TEMPORARY FILENAME 56 100 2 0
 0 15 
9 | P a g e
RMAN CONFIGURATION 1108 50 0 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
LOG HISTORY 56 292 33 1
 33 33
OFFLINE RANGE 200 163 0 0
 0 0
ARCHIVED LOG 584 28 0 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
BACKUP SET 40 409 0 0
 0 0
BACKUP PIECE 736 200 0 0
 0 0
BACKUP DATAFILE 200 245 0 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
BACKUP REDOLOG 76 215 0 0
 0 0
DATAFILE COPY 736 200 1 1
 1 1
BACKUP CORRUPTION 44 371 0 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
COPY CORRUPTION 40 409 0 0
 0 0
DELETED OBJECT 20 818 1 1
 1 1
PROXY COPY 928 246 0 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
BACKUP SPFILE 124 131 0 0
 0 0 
10 | P a g e
DATABASE INCARNATION 56 292 2 1
 2 2
FLASHBACK LOG 84 2048 0 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
RECOVERY DESTINATION 180 1 1 0
 0 0
INSTANCE SPACE RESERVATION 28 1055 1 0
 0 0
REMOVABLE RECOVERY FILES 32 1000 0 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
RMAN STATUS 116 141 0 0
 0 0
THREAD INSTANCE NAME MAPPING 80 8 8 0
 0 0
MTTR 100 8 1 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
DATAFILE HISTORY 568 57 0 0
 0 0
STANDBY DATABASE MATRIX 400 31 31 0
 0 0
GUARANTEED RESTORE POINT 212 2048 0 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID
---------- ----------
RESTORE POINT 212 2083 0 0
 0 0
DATABASE BLOCK CORRUPTION 80 8384 0 0
 0 0
ACM OPERATION 104 64 6 0
 0 0
TYPE RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX
---------------------------- ----------- ------------- ------------ -----------
LAST_INDEX LAST_RECID 
11 | P a g e
---------- ----------
FOREIGN ARCHIVED LOG 604 1002 0 0
 0 0
37 rows selected. 

//List the number and location of existing log files and display the number of redo log file groups and members
 your database has. //

SQL> SELECT member FROM v$logfile;
MEMBER
--------------------------------------------------------------------------------
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\REDO03.LOG
S:\APP\SDEVAGUP\ORADATA\SSEVAGUPDBA\REDO02.LOG
S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\REDO01.LOG
SQL> SELECT group#, members FROM v$log;
 GROUP# MEMBERS
---------- ----------
 1 1
 3 1
 2 1 

//Add a redo log member to each group in your database located on C:\u4, using the following naming conventions:
 Add member to Group 1: redo01b.log
 Add member to Group 2: redo02b.log
 Add member to Group 3: redo03b.log
 Verify the result. //

SQL> ALTER DATABASE ADD LOGFILE MEMBER
 2 'S:\app\sdevagup\oradata\sdevagupDBA\U4\NEWWORLD\REDO01B.LOG' to Group 1,
 3 'S:\app\sdevagup\oradata\sdevagupDBA\U4\NEWWORLD\REDO02B.LOG' to Group 2,
 4 'S:\app\sdevagup\oradata\sdevagupDBA\U4\NEWWORLD\REDO03B.LOG' to Group 3;
Database altered.
SQL> COLUMN GROUP# FORMAT 99
SQL> COLUMN MEMBER FORMAT a40
SQL> SELECT * FROM v$logfile;
GROUP# STATUS TYPE MEMBER IS_
------ ------- ------- ---------------------------------------- ---
 3 ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\REDO03.L NO
 OG
 2 ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\REDO02.L NO
 OG
 1 ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\REDO01.L NO
 OG
 1 INVALID ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\U4\NEWWO NO
 RLD\REDO01B.LOG
GROUP# STATUS TYPE MEMBER IS_
------ ------- ------- ---------------------------------------- ---
 2 INVALID ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\U4\NEWWO NO
 RLD\REDO02B.LOG 
12 | P a g e
 3 INVALID ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\U4\NEWWO NO
 RLD\REDO03B.LOG
6 rows selected.

//. Add a new redo log group with two members located on C:\APP\oradata\INST1 and C:\U4 using the following
 naming conventions and verify the result.
 Add Group 4: redo04.log and redo04b.log //
SQL> ALTER DATABASE ADD LOGFILE GROUP 4
('S:\app\sdevagup\oradata\sdevagupDBA\U4\NEWWORLD\REDO04.LOG','S:\app\sdevagup\oradata\sdevagupDBA\U4\NEWW
ORLD\REDO04B.LOG') SIZE 9M;
Database altered.
SQL> COLUMN GROUP# FORMAT 99
SQL> COLUMN MEMBER FORMAT a40
SQL> SELECT * FROM v$logfile;
GROUP# STATUS TYPE MEMBER IS_
------ ------- ------- ---------------------------------------- ---
 3 ONLINE S:\APP\SSDEVAGUP\ORADATA\SDEVAGUPDBA\REDO03.L NO
 OG
 2 ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\REDO02.L NO
 OG
 1 ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\REDO01.L NO
 OG
 1 INVALID ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\U4\NEWWO NO
 RLD\REDO01B.LOG
GROUP# STATUS TYPE MEMBER IS_
------ ------- ------- ---------------------------------------- ---
 2 INVALID ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\U4\NEWWO NO
 RLD\REDO02B.LOG
 3 INVALID ONLINE S:\APP\SDEVGUP\ORADATA\SDEVAGUPDBA\U4\NEWWO NO
 RLD\REDO03B.LOG
 4 ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\U4\NEWWO NO
 RLD\REDO04.LOG
 4 ONLINE S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\U4\NEWWO NO
GROUP# STATUS TYPE MEMBER IS_
------ ------- ------- ---------------------------------------- ---
 RLD\REDO04B.LOG
8 rows selected.
SQL> SELECT group#, members FROM v$log;
GROUP# MEMBERS
------ ----------
 1 2
 4 2
 3 2
 2 2 

//Remove the redo log group created in the previous step.//
SQL> ALTER SYSTEM SWITCH LOGFILE;
System altered.
SQL> ALTER SYSTEM SWITCH LOGFILE;
System altered.
SQL> ALTER SYSTEM SWITCH LOGFILE;
System altered.
SQL> SELECT group#, members FROM v$log;
GROUP# MEMBERS
------ ----------
 1 2
 4 2
 3 2
 2 2
SQL> ALTER DATABASE DROP LOGFILE GROUP 4;
Database altered.

//Resize all online redo log files to 5 MB.//

 Resize all online redo log files to 5 MB.
SQL> ALTER DATABASE ADD LOGFILE
 2 GROUP 5('S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA \log05a.rdo',
 3 'S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\log05b.rdo'
 4 ) SIZE 5M,
 5 GROUP 6('S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\log06a.rdo',
 6 'S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\log06b.rdo'
 7 ) SIZE 5M,
 8 GROUP 7('S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\log07a.rdo',
 9 'S:\APP\SDEVAGUP\ORADATA\SDEVAGUPDBA\log07b.rdo'
 10 ) SIZE 5M;
Database altered.
SQL> ALTER DATABASE DROP LOGFILE GROUP 1;
Database altered.
SQL> ALTER DATABASE DROP LOGFILE GROUP 2;
Database altered.
SQL> ALTER DATABASE DROP LOGFILE GROUP 3;
Database altered.
SQL> SELECT group#, bytes FROM v$log;
GROUP# BYTES
------ ----------
 5 5242880
 6 5242880
 7 5242880 



 

