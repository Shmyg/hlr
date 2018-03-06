/*
|| Comparison between pairs 'IMSI-MSISDN' on HLR and in BSCS
|| NOT FINISHED YET
|| $Log: compare_ports.sql,v $
|| Revision 1.1  2005/02/02 10:54:30  serge
|| *** empty log message ***
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

WITH	phone_ports AS (
	SELECT	dn.dn_num,
		pt.port_num
	FROM	directory_number	dn,
		contr_devices		cd,
		port			pt
	WHERE	cd.dn_id = dn.dn_id
	AND	pt.port_id = cd.port_id
	AND	cd.cd_deactiv_date IS NULL
	AND	dn.dn_status = 'a'
	)
SELECT	ndc || phone_num,
	hc.msin,
	SUBSTR( pp.port_num, 6, 10 )
FROM	hlr_customers	hc,
	phone_ports	pp
WHERE	pp.dn_num = hc.ndc || hc.phone_num
AND	SUBSTR(pp.port_num, 6, 10 ) != hc.msin
/

/*
SELECT	hd.msin,
	ndc || phone_num,
	pp.dn_num,
	pp.tmcode
FROM	hlr_customers	hd,
	phone_port	pp
WHERE	pp.dn_num != hd.ndc || hd.phone_num
AND	SUBSTR(pp.port_num, 6, 10 ) = hd.msin
/
*/

SPOOL OFF
