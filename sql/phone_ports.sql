/*
|| Script to get pairs 'phone num - SIM' to re-create subscribers
|| $Log: phone_ports.sql,v $
|| Revision 1.1  2004/12/07 12:50:32  serge
|| Added files to re-create subscribers
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


SPOOL phone_ports_&&start_date..txt

SELECT	pd.phone_num,
	sm.sm_serialnum,
	sm.sm_status
FROM	storage_medium		sm,
	port			pt,
	phones_to_delete	pd,
	hlr_customers		hl
WHERE	pd.phone_num = hl.ndc || hl.phone_num
AND	hl.msin = SUBSTR( pt.port_num, 6, 10 )
AND	sm.sm_id = pt.sm_id
/

SPOOL OFF
