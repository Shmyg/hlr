LOAD	DATA
INTO	TABLE phones_to_delete
TRUNCATE
FIELDS	TERMINATED BY ';'
TRAILING NULLCOLS
	(
	phone_num
	)

