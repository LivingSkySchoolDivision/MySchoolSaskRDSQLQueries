-- PRIMARY ENROLLMENTS --
SELECT 
	SKL.SKL_SCHOOL_NAME AS 'School',
	COUNT (STD.STD_SKL_OID) AS 'Enrolled'
FROM 
	MSS_STUDENT STD
INNER JOIN 
	MSS_SCHOOL SKL ON STD.STD_SKL_OID = SKL.SKL_OID
WHERE  
	STD.STD_ENROLLMENT_STATUS NOT IN ('Comp Sch', 'Withdrawn')
GROUP BY
	SKL.SKL_SCHOOL_NAME
ORDER BY 
	SKL.SKL_SCHOOL_NAME

-- SECONDARY ENROLLMENTS --
SELECT SKL.SKL_SCHOOL_NAME, 
	COUNT (STS.SSK_SKL_OID)
FROM MSS_STUDENT_SCHOOL sts
INNER JOIN 
	MSS_STUDENT std on sts.SSK_STD_OID = std.STD_OID
INNER JOIN 
	MSS_SCHOOL SKL ON STS.SSK_SKL_OID = SKL.SKL_OID
WHERE 
	SSK_END_DATE > GETDATE() AND STS.SSK_ASSOCIATION_TYPE = 1
GROUP BY 
	SKL.SKL_SCHOOL_NAME
ORDER BY 
	SKL.SKL_SCHOOL_NAME