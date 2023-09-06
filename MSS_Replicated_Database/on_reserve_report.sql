SELECT 
	SKL.SKL_SCHOOL_NAME AS 'School',
	STD.STD_GRADE_LEVEL AS 'Grade',
	STD.STD_NAME_VIEW AS 'Student',
	PSN.PSN_DOB AS 'Birthdate',
	PSN.PSN_GENDER_CODE AS 'Gender',
	PSN.PSN_FIELDA_012 AS 'Status Number',
	PSN.PSN_FIELDC_004 AS 'Band Affiliation', 
	REF.RCD_DESCRIPTION AS 'Reserve of Residence',
	ADR.ADR_ADDRESS_LINE_01 AS 'Address',
	ADR.ADR_ADDRESS_LINE_02 AS 'Mailing',
	ADR.ADR_ADDRESS_LINE_03 AS 'City Prov Pc'
	--CNT.CNT_NAME_VIEW AS '1st Contact',
	--CTJ.CTJ_RELATIONSHIP_CODE AS 'Relationship'
FROM
	MSS_STUDENT STD
--INNER JOIN
	--MSS_STUDENT_CONTACT CTJ ON STD.STD_OID = CTJ.CTJ_STD_OID
--INNER JOIN 
	--MSS_CONTACT CNT ON CTJ.CTJ_CNT_OID = CNT.CNT_OID
INNER JOIN
	MSS_SCHOOL SKL ON STD.STD_SKL_OID = SKL.SKL_OID
INNER JOIN
	MSS_PERSON_STD PSN ON STD.STD_PSN_OID = PSN.PSN_OID
INNER JOIN
	MSS_PERSON_ADDRESS_STD ADR ON PSN.PSN_ADR_OID_PHYSICAL = ADR.ADR_OID
INNER JOIN
	MSS_REF_CODE REF ON PSN.PSN_FIELDC_005 = REF.RCD_CODE
WHERE
	STD.STD_ENROLLMENT_STATUS LIKE ('Act%') AND PSN.PSN_FIELDC_005 != 'Off-Reserve' AND PSN.PSN_FIELDC_005 IS NOT NULL --AND CTJ.CTJ_EMERGENCY_PRIORITY = 1
ORDER BY
	SKL.SKL_SCHOOL_NAME,
	STD.STD_NAME_VIEW