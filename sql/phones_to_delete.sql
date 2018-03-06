/*
|| Script to create MSC command file to delete subscribers
|| Phone numbers to delete are taken from PHONES_TO_DELETE table
|| that is joined with HLR_CUSTOMERS table to get ports
||
|| $Log: phones_to_delete.sql,v $
|| Revision 1.1  2004/12/07 12:50:32  serge
|| Added files to re-create subscribers
||
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


SPOOL phones_to_delete_&&start_date..txt

SELECT	'<CMDFILE;' || CHR(10) || 
	'<SETCFOPT:ACKCFS=ERROR,ACKREQ=POS,DANCMD=POS;'
FROM	DUAL
/

SELECT	'<CANMSUB:MSIN=' || hc.msin || ';'
FROM	hlr_customers		hc,
	phones_to_delete	pd
WHERE	pd.phone_num = hc.ndc || hc.phone_num
/

SELECT	'<RESETCFOPT;' || CHR(10) || '<ENDFILE;'
FROM	DUAL
/

SPOOL OFF
