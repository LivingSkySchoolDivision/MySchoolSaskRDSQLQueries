-- CHECK FOR CORRECT BUILD YEAR --
SELECT 
	SKL.SKL_SCHOOL_NAME AS 'School',
	CTX.CTX_CONTEXT_NAME AS 'Build Year'
FROM
	MSS_SCHOOL SKL
INNER JOIN 
	MSS_DISTRICT_SCHOOL_YEAR_CONTEXT CTX ON SKL.SKL_CTX_OID_BUILD = CTX.CTX_OID
WHERE
	CTX.CTX_CONTEXT_NAME != 'School Year: 2023-2024' AND SKL.SKL_INACTIVE_IND = 0
ORDER BY
	SKL.SKL_SCHOOL_NAME

-- STUDENT COUNTS FOR FEEDER/RECEIVING SCHOOLS --
SELECT 
	CSC.SKL_SCHOOL_NAME as 'Feeder School',
	SC.SKL_SCHOOL_NAME as 'Receiving School',
	COUNT(SC.SKL_SCHOOL_NAME) 'Number of Students'
FROM 
	MSS_STUDENT ST
LEFT OUTER JOIN 
	MSS_SCHOOL SC ON ST.STD_SKL_OID_NEXT = SC.SKL_OID
INNER JOIN
	MSS_SCHOOL CSC ON ST.STD_SKL_OID = CSC.SKL_OID
WHERE
	SC.SKL_INACTIVE_IND = 0
	AND ST.STD_ENROLLMENT_STATUS != 'Withdrawn'
GROUP BY 
	SC.SKL_SCHOOL_NAME,
	CSC.SKL_SCHOOL_NAME

-- NUMBER OF STUDENTS WITHOUT A NY SCHOOL PER SCHOOL --
SELECT 
	SC.SKL_SCHOOL_NAME as 'School',
	COUNT(SC.SKL_SCHOOL_NAME) 'Number of Students'
FROM 
	MSS_STUDENT ST
LEFT OUTER JOIN 
	MSS_SCHOOL SC ON ST.STD_SKL_OID = SC.SKL_OID
WHERE
	SC.SKL_INACTIVE_IND = 0
	AND ST.STD_ENROLLMENT_STATUS != 'Withdrawn'
	AND ST.STD_SKL_OID_NEXT IS NULL
	AND ST.STD_GRADE_LEVEL != '12'
GROUP BY 
	SC.SKL_SCHOOL_NAME


-- NEXT YEAR SCENARIO CREATED --
SELECT 
	SC.SKL_SCHOOL_NAME,
	MS.SCH_SCHEDULE_NAME,
	MS.SCH_TERMS,
	MS.SCH_TERM_VIEW,
	MS.SCH_DAYS,
	MS.SCH_PERIODS
FROM 
	MSS_SCHEDULE MS
INNER JOIN
	MSS_SCHOOL SC ON MS.SCH_SKL_OID = SC.SKL_OID
WHERE 
	SCH_START_DATE >= '2023-08-01'
	AND SCH_TERM_VIEW IS NOT NULL
ORDER BY
	SC.SKL_SCHOOL_NAME

-- SCHOOLS WITH NO SCENARIOS --
SELECT 
	SC.SKL_SCHOOL_NAME,
	MS.SCH_SCHEDULE_NAME,
	MS.SCH_TERMS,
	MS.SCH_TERM_VIEW,
	MS.SCH_DAYS,
	MS.SCH_PERIODS
FROM 
	MSS_SCHEDULE MS
INNER JOIN
	MSS_SCHOOL SC ON MS.SCH_SKL_OID = SC.SKL_OID
WHERE 
	SCH_START_DATE >= '2023-08-01'
	AND SCH_TERM_VIEW IS NULL
ORDER BY
	SC.SKL_SCHOOL_NAME

-- SECTION SETUP PROGRESS --
SELECT 
	SC.SKL_SCHOOL_NAME,
	BLM.BLM_DESCRIPTION,
	BLM.BLM_TERM_VIEW,
	BLM.BLM_SCHEDULE_DISPLAY
FROM 
	MSS_SCHEDULE_BUILD_MASTER BLM
INNER JOIN
	MSS_COURSE_SCHOOL SCH ON BLM_CSK_OID = SCH.CSK_OID
INNER JOIN
	MSS_SCHOOL SC ON SCH.CSK_SKL_OID = SC.SKL_OID
INNER JOIN
	MSS_SCHEDULE SCHE ON BLM.BLM_SCH_OID = SCHE.SCH_OID
WHERE
	BLM.BLM_SCHEDULE_DISPLAY IS NOT NULL AND SCHE.SCH_START_DATE >= '2023-08-01'

-- SECTION ENROLLMENT PROGRESS --
SELECT 
	SC.SKL_SCHOOL_NAME,
	COUNT (SC.SKL_SCHOOL_NAME)
FROM 
	MSS_SCHEDULE_BUILD_MASTER BLM
INNER JOIN
	MSS_COURSE_SCHOOL CSK ON BLM_CSK_OID = CSK.CSK_OID
INNER JOIN
	MSS_SCHOOL SC ON CSK.CSK_SKL_OID = SC.SKL_OID
INNER JOIN
	MSS_SCHEDULE SCH ON BLM.BLM_SCH_OID = SCH.SCH_OID
WHERE
	BLM.BLM_ENROLLMENT_TOTAL > 0 AND SCH.SCH_START_DATE >= '2023-08-01'
GROUP BY
	SC.SKL_SCHOOL_NAME

-- COURSE REQUESTS
SELECT DISTINCT
	SC.SKL_SCHOOL_NAME,
	ST.STD_GRADE_LEVEL,
	COUNT(ST.STD_NAME_VIEW) AS '# OF STUDENTS'
FROM 
	MSS_STUDENT_COURSE_REQUEST REQ
INNER JOIN
	MSS_COURSE_SCHOOL COSC ON REQ.REQ_CSK_OID = COSC.CSK_OID
INNER JOIN	
	MSS_SCHOOL SC ON COSC.CSK_SKL_OID = SC.SKL_OID
INNER JOIN
	MSS_STUDENT ST ON REQ.REQ_STD_OID = ST.STD_OID
GROUP BY
	SC.SKL_SCHOOL_NAME,
	ST.STD_GRADE_LEVEL,
	ST.STD_NAME_VIEW
ORDER BY 
	SC.SKL_SCHOOL_NAME,
	ST.STD_GRADE_LEVEL

-- COURSE REQUESTS
SELECT DISTINCT
	SC.SKL_SCHOOL_NAME,
	ST.STD_GRADE_LEVEL,
	COUNT(ST.STD_NAME_VIEW) AS '# OF STUDENTS'
FROM 
	MSS_STUDENT_COURSE_REQUEST REQ
INNER JOIN
	MSS_COURSE_SCHOOL COSC ON REQ.REQ_CSK_OID = COSC.CSK_OID
INNER JOIN	
	MSS_SCHOOL SC ON COSC.CSK_SKL_OID = SC.SKL_OID
INNER JOIN
	MSS_STUDENT ST ON REQ.REQ_STD_OID = ST.STD_OID
GROUP BY
	SC.SKL_SCHOOL_NAME,
	ST.STD_GRADE_LEVEL,
	ST.STD_NAME_VIEW
ORDER BY 
	SC.SKL_SCHOOL_NAME,
	ST.STD_GRADE_LEVEL

