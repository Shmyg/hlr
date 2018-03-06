/*
|| Comparison between phones active on HLR and in BSCS
|| $Log: compare_phones.sql,v $
|| Revision 1.3  2008/05/15 09:36:49  shmyg
|| *** empty log message ***
||
|| Revision 1.2  2004-12-07 12:50:32  serge
|| Added files to re-create subscribers
||
|| Revision 1.1.1.1  2004/11/10 09:59:25  serge
||
||
|| Revision 1.1  2004/11/02 10:06:05  serge
|| Added sql report to get data
||
*/

SET PAGESIZE 0
SET TRIMSPOOL ON
SET LINESIZE 32767
SET TAB OFF
SET FEEDBACK OFF
SET ECHO OFF
SET VERIFY OFF
SET TERMOUT OFF

COLUMN begin_date new_val start_date
SELECT  TO_CHAR( SYSDATE, 'YYYYMMDDHH24MI' ) begin_date
FROM    DUAL; 


SPOOL phones_&&start_date..txt

SELECT	'Non-existing in BSCS'
FROM	DUAL
/

SELECT	ndc || phone_num
FROM	hlr_customers
WHERE	pop_customer = 'X'
MINUS
SELECT	dn_num
FROM	directory_number
WHERE	dn_status = 'a'
/

/*

SELECT	'Non-existing in HLR'
FROM	DUAL
/

SELECT	dn_num
FROM	directory_number
WHERE	dn_status = 'a'
MINUS
SELECT	ndc || phone_num
FROM	hlr_customers
/

*/

SPOOL OFF
