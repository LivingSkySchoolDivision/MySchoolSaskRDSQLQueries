/*
Login Status: 0 = Enabled, 1 = Disabled but allow re-enable, 2 = Disabled and locked.
Authentication Type: 0 = Aspen, 1 = Active Directory, 2 = CAC, 3 = SSO.
*/
-- Active Students
SELECT 
	ST.STD_ID_LOCAL AS MSS_PUPIL_ID,
	SC.SKL_SCHOOL_NAME AS School_Name,
	'Living Sky SD 202' AS Division_Name,
	PER.PSN_EMAIL_01 AS Login_Name,
	'' AS Password,
	'0' AS Login_Status,
	'3' AS Authentication_Type
FROM
	MSS_STUDENT ST
INNER JOIN
	MSS_SCHOOL SC ON ST.STD_SKL_OID_NEXT = SC.SKL_OID
INNER JOIN
	MSS_PERSON_STD PER ON ST.STD_PSN_OID = PER.PSN_OID
WHERE
	ST.STD_GRADE_LEVEL = '09' -- ADJUST GRADE LEVEL AS NEEDED --
	AND ST.STD_ENROLLMENT_STATUS like '%Active%'
	AND SC.SKL_SCHOOL_NAME IN (
	'North Battleford Comprehensive High School'
	)

UNION ALL

-- Inactive Students
SELECT 
	ST.STD_ID_LOCAL AS MSS_PUPIL_ID,
	SC.SKL_SCHOOL_NAME AS School_Name,
	'Living Sky SD 202' AS Division_Name,
	PER.PSN_EMAIL_01 AS Login_Name,
	'' AS Password,
	'2' AS Login_Status,
	'0' AS Authentication_Type
FROM
	MSS_STUDENT ST
INNER JOIN
	MSS_SCHOOL SC ON ST.STD_SKL_OID_NEXT = SC.SKL_OID
INNER JOIN
	MSS_PERSON_STD PER ON ST.STD_PSN_OID = PER.PSN_OID
WHERE	
	ST.STD_GRADE_LEVEL = '09' -- ADJUST GRADE LEVEL AS NEEDED --
	AND ST.STD_ENROLLMENT_STATUS NOT LIKE '%Active%'
	AND SC.SKL_SCHOOL_NAME IN (
	'North Battleford Comprehensive High School'
	)