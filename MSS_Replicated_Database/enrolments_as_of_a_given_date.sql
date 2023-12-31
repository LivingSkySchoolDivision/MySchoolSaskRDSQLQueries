DECLARE 
	@STARTDATE AS DATETIME

SET 
	@STARTDATE = '2021-09-15'
SELECT
	E.ENR_STD_OID,
	SC.SKL_SCHOOL_NAME AS School,
	PR.PSN_NAME_FIRST AS LegalFirstName,
	PR.PSN_NAME_LAST AS LegalLastName,
	ST.STD_ID_STATE AS LearningID,
	PR.PSN_DOB AS DateOfBirth,
	PR.PSN_GENDER_CODE AS Gender,
	ST.STD_GRADE_LEVEL AS Grade,
	ST.STD_HOMEROOM AS Homeroom,
	ST.STD_HR_TEACHER_VIEW AS HomeroomTeacher,
	PR.PSN_FIELDB_002 AS IndigenousDeclaration,
	ST.STD_ENROLLMENT_STATUS as CurrentEnrollmentStatus,
	FORMAT(E.ENR_ENROLLMENT_DATE, 'MMM.dd, yyyy') AS LatestEnrollmentDate,
	FORMAT(W.ENR_ENROLLMENT_DATE, 'MMM.dd, yyyy') AS LatestWithdrawalDate
FROM 
	MSS_STUDENT ST
INNER JOIN
	MSS_SCHOOL SC ON ST.STD_SKL_OID = SC.SKL_OID
INNER JOIN
	MSS_PERSON_STD PR ON ST.STD_PSN_OID = PR.PSN_OID
INNER JOIN
(SELECT 
	TOP 1 WITH TIES
	ENR_STD_OID,
	ENR_ENROLLMENT_DATE,
	ENR_ENROLLMENT_TYPE,
	ENR_TIMESTAMP
FROM	
	MSS_STUDENT_ENROLLMENT
WHERE 
	ENR_ENROLLMENT_TYPE = 'E'
ORDER BY 
	ROW_NUMBER() OVER (PARTITION BY ENR_STD_OID ORDER BY ENR_ENROLLMENT_DATE DESC)
) E
ON ST.STD_OID = E.ENR_STD_OID
LEFT JOIN
(SELECT 
	TOP 1 WITH TIES
	ENR_STD_OID,
	ENR_ENROLLMENT_DATE,
	ENR_ENROLLMENT_TYPE,
	ENR_TIMESTAMP
FROM	
	MSS_STUDENT_ENROLLMENT
WHERE 
	ENR_ENROLLMENT_TYPE = 'W'
ORDER BY 
	ROW_NUMBER() OVER (PARTITION BY ENR_STD_OID ORDER BY ENR_ENROLLMENT_DATE DESC)
) W
ON ST.STD_OID = W.ENR_STD_OID
WHERE 
	(W.ENR_TIMESTAMP IS NULL OR E.ENR_TIMESTAMP > W.ENR_TIMESTAMP)
	AND
	ST.STD_GRADE_LEVEL NOT IN ('0K','PK') AND ST.STD_GRADE_LEVEL IN ('01','02','03','04','05','06')
ORDER BY
	SC.SKL_SCHOOL_NAME,
	ST.STD_GRADE_LEVEL,
	ST.STD_NAME_VIEW

