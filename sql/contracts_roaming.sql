/*
||
|| $Log: contracts_roaming.sql,v $
|| Revision 1.1  2005/05/31 14:36:56  serge
|| Added script to extract all the contracts having roaming barred
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
SET RECSEP OFF

COLUMN begin_date new_val start_date
SELECT  TO_CHAR( SYSDATE, 'YYYYMMDDHH24MI' ) begin_date
FROM    DUAL; 


SPOOL contracts_roaming_&&start_date..txt

SELECT	co.customer_id,
	co.co_id,
	dn.dn_num,
	pt.port_num,
	pr.status,
	pr.valid_from_date
FROM	contract_all	co,
	(
	SELECT	*
	FROM	(
		SELECT	co_id,
			status,
			valid_from_date,
			ROW_NUMBER() OVER (PARTITION BY co_id ORDER BY valid_from_date DESC) AS rn
		FROM	pr_serv_status_hist
		WHERE	valid_from_date <= TRUNC( SYSDATE )
		AND	sncode = 42 
		)
	WHERE	rn = 1
	)		pr,
	contr_services_cap	cs,
	port			pt,
	contr_devices		cd,
	directory_number	dn
WHERE	co.co_id = pr.co_id(+)
AND	cs.co_id = co.co_id
AND	pt.port_id = cd.port_id
AND	cs.dn_id = dn.dn_id
AND	cd.co_id = co.co_id
AND	cd.cd_deactiv_date IS NULL
AND	cs.cs_deactiv_date IS NULL
AND	co.tmcode NOT IN (9, 28)
AND	NOT EXISTS
	(
	SELECT	*
	FROM	contract_history
	WHERE	co_id = co.co_id
	AND	ch_status = 'd'
	)
/
	

SPOOL OFF

SET PAGESIZE 50
SET TERMOUT ON
