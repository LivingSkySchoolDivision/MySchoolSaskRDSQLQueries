/*
Staff Import (Email Key) v3	 	
 
This import collects staff information and creates / updates MSS staff records and user profiles.  The search key is based on the staff email address.  This import can be run multiple times to add additional security roles to the staff user profile (i.e. additive security).

Details of the comma-delimited import file include the following character string-based fields: staff employee number, educator certificate number, last name, first name, gender code (F, M, U), birthdate (yyyy-mm-dd), primary phone number (999-999-9999), cell phone number (999-999-9999), emergency phone number (999-999-9999), email, staff type (see below), status (Active, Inactive), home address 1, home address 2, home address 3, school name, school division name, login id, login status (see below), authentication type (see below), and staff role (see below).

Possible staff types: Administrator, Counsellor, SD Coordinator, SD Director, SD Superintendent, Secretary, Substitute, Support Staff, Teacher.

Possible login statuses (integer values):  0 = Enabled, 1 = Disabled, 3 = Disabled and locked.

Possible authentication types (integer values):  0 = Aspen, 1 = AD, 2 = CAC, 3 = SSO.

Allowed staff roles:  Teacher, Admin Assistant - Main Office Staff, School Administrator (Read Only), Conduct Add-on - School, Division Read Only, Admin Assistant - Attendance Entry, Counselor, Course Manager, Gradebook add-on.

*** ensure input file CSV does not have extraneous carriage returns after the input lines and before the end-of-file; a "delimeter error" will be raised.
*/
DECLARE 
	@SCHOOLYEARSTARTDATE AS DATETIME,
	@SCHOOLYEARENDDATE AS DATETIME 

SET @SCHOOLYEARSTARTDATE = '06-30-2023'
SET @SCHOOLYEARENDDATE = '08-01-2024'
DECLARE 
	@STAFFTYPE TABLE(VAL VARCHAR(1000))
INSERT INTO @STAFFTYPE VALUES 
('CASUAL SEC'),
('COMTECHS S'),
('COUNSELOR'),
('COUNSELORC'),
('INDIGADVOC'),
('MENHTHWRK'),
('PRINCIPAL'),
('PRINCASSOC'),
('RURALLIAS'),
('SCHSECR'),
('SCHLIAS'),
('STD COORD'),
('SUPPORTPRO'),
('TEACH'),
('Teacher'),
('TEACHFTV'),
('TEACHASSOC'),
('TEACHPREK'),
('TEACHVIRTU'),
('VICEPRIN')

-- ACTIVE STAFF --
SELECT DISTINCT
	EM.No_ AS "Employee Number",
	CASE WHEN AI.[Text 1 Value] IS NULL THEN '' ELSE AI.[Text 1 Value] END AS "Educator Certificate Number",
	CASE WHEN EM.[Preferred Last Name] = '' THEN EM.[Last Name] ELSE EM.[Preferred Last Name] END AS "Last Name",
	CASE WHEN EM.[Preferred First Name] = '' THEN EM.[First Name] ELSE EM.[Preferred First Name] END AS "First Name",
	CASE WHEN Gender = 1 THEN 'F' ELSE 'M' END AS Gender_Code,
	FORMAT(EM.[Birth Date], 'yyyy-MM-dd') AS "Birth Date",
	EM.[Home Phone No_] AS "Primary Phone",
	EM.[Mobile Phone No_] AS "Cell Phone",
	EM.[Phone No_] AS "Emergency Phone",
	CASE WHEN EM.[Company E-Mail] ='' THEN LOWER(EM.[First Name]) + '.' + LOWER(EM.[Last Name]) + '@lskysd.ca' ELSE EM.[Company E-Mail] END AS Email,
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(EA.[Assignment Code],	
		'ADMIN', 'Secretary'),
		'CASUAL SEC' , 'Secretary'),
		'COMTECHS S' , ''),
		'COUNSELOR' , 'Counsellor'),
		'COUNSELORC' , 'Counsellor'),
		'INDIGADVOC' , 'Support Staff'),
		'MENHTHWRK' , 'Counsellor'),
		'PRINCIPAL' , 'Administrator'),
		'PRINCASSOC' , 'Administrator'),
		'RURALLIAS' , 'Support Staff'),
		'SCHLIAS', ''),
		'SCHSECR' , 'Secretary'),
		'SPEEC PATH' , 'Support Staff'),
		'STD COORD' , ''),
		'SUPPORTPRO' , 'SD Superintendent'),
		'TEACH' , 'Teacher'),
		'Teacher' , 'Teacher'),
		'TEACHASSOC' , 'Teacher'),
		'TEACHFTV' , 'Teacher'),
		'TEACHPREK' , 'Teacher'),
		'TEACHVIRTU' , 'Teacher'),
		'VICEPRIN' , 'Administrator')
	AS "Staff Type",
	'Active' AS Status,
	EA.[Effective Date] AS "Effective Date",
	EA.[End Date] AS "End Date",
	'' AS "IT Compare",
	CASE WHEN EM.No_ = 10509 -- Angie Moser (needs Home School)
		THEN 'Living Sky SD 202 Home School' ELSE REPLACE(REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (FA.Description, 
		'Battleford Central (K-06)','Battleford Central Elementary'),'Bready (K-08)','Bready Elementary'),'Cando Community (Prek-12)', 'Cando Community School'),'Connaught (Prek-08)','Connaught Elementary School'),'Cut Knife Community','Cut Knife Community School'),'Cut Knife Elem (K-06)','Cut Knife Community School'),
		'Hafford Central (K-12)','Hafford Central School'),'Hartley Clark (K-06)','Hartley Clark Elementary School'), 'Heritage Christian (K-12)','Heritage Christian School'),'Hillsvale Colony (K-09)','Hillsvale Colony School'),'Kerrobert Composite (K-12)','Kerrobert Composite School'),'Lakeview Colony (K-09)','Lakeview Colony School'),
		'Lawrence (K-08)','Lawrence Elementary School'), 		'Leoville Central (K-12)','Leoville Central School'),'Virtual School','LSSD Virtual'),'Luseland (K-12)','Luseland School'),'Macklin (K-12)','Macklin School'),'Maymont Central (K-12)','Maymont Central School'),'McKitrick (Prek-08)','McKitrick Community School'),
		'McLurg (07-12)','McLurg High School'),'Meadow Lake Christian Academy (K-9)','Meadow Lake Christian Academy'),'Medstead Central (K-12)','Medstead Central School'),'NBCHS (07-12)','North Battleford Comprehensive High School'),'Norman Carter (K-06)','Norman Carter Elementary School'),
		'Scott Colony (K-09)','Scott Colony  School'),'Spiritwood HS (07-12)','Spiritwood High School'),'St. Vital (K-08)','St. Vital Catholic School'),'Unity HS (07-12)','Unity Composite High School'),'Unity Public (K-06)','Unity Public School'),'All Schools', ''),'Central Office', '') 
	END AS School_Name,
	'Living Sky SD 202' AS "Division Name",
	CASE WHEN EM.[Company E-Mail] ='' THEN LOWER(EM.[First Name]) + '.' + LOWER(EM.[Last Name]) + '@lskysd.ca' ELSE EM.[Company E-Mail] END AS "MSS Login Name",
	'0' AS "Login Status",
	'3' AS "Authentication Type",
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(EA.[Assignment Code],		
		'ADMIN', 'Secretary'),
		'CASUAL SEC' , ''),
		'COMTECHS S' , 'Division Support (Level 1), Schedule Builder, SDS Audit, SDS OnDemand Assessments, SDS OnDemand Classes, SDS OnDemand Enrol'),
		'COUNSELOR' , 'School Support Roles'),
		'COUNSELORC' , 'School Support Roles'),
		'INDIGADVOC' , 'Support Staff'),
		'MENHTHWRK' , 'School Support Roles'),
		'PRINCIPAL' , 'School Administrator (Read Only)'),
		'PRINCASSOC' , 'School Administrator (Read Only)'),
		'RURALLIAS' , 'School Support Roles'),
		'SCHLIAS', ''),
		'SCHSECR' , 'Admin Assistant - Main Office Staff, Admin Assistant - SIS Admin (School Power User), SDS OnDemand Enrol'),
		'SPEEC PATH' , 'Division User (Read Only), School Support Roles'),
		'STD COORD' , ''),
		'SUPPORTPRO' , 'Division User (Read Only)'),
		'TEACH' , 'Teacher'),
		'Teacher' , 'Teacher'),
		'TEACHASSOC' , 'Teacher'),
		'TEACHFTV' , 'Teacher'),
		'TEACHPREK' , 'Teacher'),
		'TEACHVIRTU' , 'Teacher'),
		'VICEPRIN' , 'School Administrator (Read Only)')
	AS "Staff Role"
FROM 
	[Living Sky Live co_$Employee] EM
INNER JOIN
	[Living Sky Live co_$Employee Assignment] EA
ON
	EM.No_ = EA.[Employee No_]
INNER JOIN
	[Living Sky Live co_$Facility] FA
ON
	EA.[Facility Code] = FA.Code
LEFT OUTER JOIN
	[Living Sky Live co_$Employee Additional Info_] AI
ON
	EM.No_ = AI.[Employee No_] AND AI.[Additional Info_ Class Detail] ='CERT'
WHERE
-- STAFF ON LEAVES RETURNING IN THE SAME SCHOOL YEAR -- 
	(EM.No_ IN (SELECT [Employee No_] FROM [Living Sky Live co_$Employee Assignment] WHERE [End Date] > @SCHOOLYEARSTARTDATE AND [Cause of Absence Code] = '')
	AND EA.[Effective Date] > GETDATE() AND EA.[Effective Date] < @SCHOOLYEARENDDATE AND EA.[Cause of Absence Code] = '' 
	AND EA.[Assignment Code] IN (SELECT VAL FROM @STAFFTYPE)  
	)
	OR
-- CURRENT STAFF MEMBERS --
	( (EA.[End Date] = '1753-01-01 00:00:00.000' OR  EA.[End Date] >= GETDATE()) 
	AND EA.[Effective Date] < @SCHOOLYEARENDDATE
	AND EA.[Cause of Absence Code] = '' 
	AND EA.[Assignment Code] IN (SELECT VAL FROM @STAFFTYPE))

-- SPECIFIC DIVISION OFFICE STAFF TO INCLUDE --
	OR EM.No_ IN (
		 30053 -- Lonny Darroch
		,42332 -- Whitney Elder
		,40145 -- Christeena Fisher
		,10388 -- Cathy Richardson
		,41467 -- Doug Drover
		,10509 -- Angie Moser
		,42712 -- Kristy Sydoruk
	)
	AND (EA.[End Date] = '1753-01-01 00:00:00.000' OR  EA.[End Date] >= GETDATE()) 
	AND EA.[Effective Date] <= DATEADD(DD, +7, CAST(GETDATE() AS DATE))
	AND [Cause of Absence Code] = ''
	AND EA.[Position Code] NOT LIKE ('SUB')
UNION ALL

-- INACTIVE STAFF WITHIN THE LAST 30 DAYS--
SELECT DISTINCT
	EM.No_,
	CASE WHEN AI.[Text 1 Value] IS NULL THEN '' ELSE AI.[Text 1 Value] END AS "Educator Certificate Number",
	CASE WHEN EM.[Preferred Last Name] = '' THEN EM.[Last Name] ELSE EM.[Preferred Last Name] END AS "Last Name",
	CASE WHEN EM.[Preferred First Name] = '' THEN EM.[First Name] ELSE EM.[Preferred First Name] END AS "First Name",
	CASE WHEN Gender = 1 THEN 'F' ELSE 'M' END AS Gender_Code,
	FORMAT(EM.[Birth Date], 'yyyy-MM-dd'),
	EM.[Home Phone No_],
	EM.[Mobile Phone No_],
	EM.[Phone No_],
	CASE WHEN EM.[Company E-Mail] ='' THEN LOWER(EM.[First Name]) + '.' + LOWER(EM.[Last Name]) + '@lskysd.ca' ELSE EM.[Company E-Mail] END AS Email,
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(EA.[Assignment Code],	
		'ADMIN', 'Secretary'),
		'CASUAL SEC' , 'Secretary'),
		'COMTECHS S' , ''),
		'COUNSELOR' , 'Counsellor'),
		'COUNSELORC' , 'Counsellor'),
		'INDIGADVOC' , 'Support Staff'),
		'MENHTHWRK' , 'Counsellor'),
		'PRINCIPAL' , 'Administrator'),
		'PRINCASSOC' , 'Administrator'),
		'RURALLIAS' , 'Support Staff'),
		'SCHLIAS', ''),
		'SCHSECR' , 'Secretary'),
		'SPEEC PATH' , 'Support Staff'),
		'STD COORD' , ''),
		'SUPPORTPRO' , 'SD Superintendent'),
		'TEACH' , 'Teacher'),
		'Teacher' , 'Teacher'),
		'TEACHASSOC' , 'Teacher'),
		'TEACHFTV' , 'Teacher'),
		'TEACHPREK' , 'Teacher'),
		'TEACHVIRTU' , 'Teacher'),
		'VICEPRIN' , 'Administrator') 
	AS "Staff Type",
	'Inactive' AS Status,
	EA.[Effective Date] AS "Effective Date",
	EA.[End Date] AS "End Date",
	'' AS "IT Compare",
	REPLACE(REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE(FA.Description, 'Battleford Central (K-06)','Battleford Central Elementary'),'Bready (K-08)','Bready Elementary'),'Cando Community (Prek-12)',
	'Cando Community School'),'Connaught (Prek-08)','Connaught Elementary School'),'Cut Knife Community','Cut Knife Community School'),'Cut Knife Elem (K-06)','Cut Knife Community School'),'Hafford Central (K-12)','Hafford Central School'),'Hartley Clark (K-06)','Hartley Clark Elementary School'),
	'Heritage Christian (K-12)','Heritage Christian School'),'Hillsvale Colony (K-09)','Hillsvale Colony School'),'Kerrobert Composite (K-12)','Kerrobert Composite School'),'Lakeview Colony (K-09)','Lakeview Colony School'),'Lawrence (K-08)','Lawrence Elementary School'),
	'Leoville Central (K-12)','Leoville Central School'),'Virtual School','LSSD Virtual'),'Luseland (K-12)','Luseland School'),'Macklin (K-12)','Macklin School'),'Maymont Central (K-12)','Maymont Central School'),'McKitrick (Prek-08)','McKitrick Community School'),
	'McLurg (07-12)','McLurg High School'),'Meadow Lake Christian Academy (K-9)','Meadow Lake Christian Academy'),'Medstead Central (K-12)','Medstead Central School'),'NBCHS (07-12)','North Battleford Comprehensive High School'),'Norman Carter (K-06)','Norman Carter Elementary School'),
	'Scott Colony (K-09)','Scott Colony  School'),'Spiritwood HS (07-12)','Spiritwood High School'),'St. Vital (K-08)','St. Vital Catholic School'),'Unity HS (07-12)','Unity Composite High School'),'Unity Public (K-06)','Unity Public School'),'All Schools', ''),'Central Office', '') AS School_Name,
	'Living Sky SD 202' AS "Division Name",
	CASE WHEN EM.[Company E-Mail] ='' THEN LOWER(EM.[First Name]) + '.' + LOWER(EM.[Last Name]) + '@lskysd.ca' ELSE EM.[Company E-Mail] END,
	'1' AS "Login Status",
	'0' AS "Authentication Type",
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(EA.[Assignment Code],	
		'ADMIN', 'Secretary'),
		'CASUAL SEC' , ''),
		'COMTECHS S' , 'Division Support (Level 1), Schedule Builder, SDS Audit, SDS OnDemand Assessments, SDS OnDemand Classes, SDS OnDemand Enrol'),
		'COUNSELOR' , 'School Support Roles'),
		'COUNSELORC' , 'School Support Roles'),
		'INDIGADVOC' , 'Support Staff'),
		'MENHTHWRK' , 'School Support Roles'),
		'PRINCIPAL' , 'School Administrator (Read Only)'),
		'PRINCASSOC' , 'School Administrator (Read Only)'),
		'RURALLIAS' , 'School Support Roles'),
		'SCHLIAS', ''),
		'SCHSECR' , 'Admin Assistant - Main Office Staff, Admin Assistant - SIS Admin (School Power User), SDS OnDemand Enrol'),
		'SPEEC PATH' , 'Division User (Read Only), School Support Roles'),
		'STD COORD' , ''),
		'SUPPORTPRO' , 'Division User (Read Only)'),
		'TEACH' , 'Teacher'),
		'Teacher' , 'Teacher'),
		'TEACHASSOC' , 'Teacher'),
		'TEACHFTV' , 'Teacher'),
		'TEACHPREK' , 'Teacher'),
		'TEACHVIRTU' , 'Teacher'),
		'VICEPRIN' , 'School Administrator (Read Only)')
	AS "Staff Role"
FROM 
	[Living Sky Live co_$Employee] EM
INNER JOIN
	[Living Sky Live co_$Employee Assignment] EA
ON
	EM.No_ = EA.[Employee No_]
INNER JOIN
	[Living Sky Live co_$Facility] FA
ON
	EA.[Facility Code] = FA.Code
LEFT OUTER JOIN
	[Living Sky Live co_$Employee Additional Info_] AI
ON
	EM.No_ = AI.[Employee No_] AND AI.[Additional Info_ Class Detail] ='CERT'
WHERE
	EA.[Assignment Code] IN ( SELECT VAL FROM @STAFFTYPE )	
	AND EA.[Position Code] NOT LIKE ('SUB')
	AND EA.[End Date] <= GETDATE()
	AND EA.[End Date] >= GETDATE()-30
	AND EM.No_ NOT IN 
	(
		-- ACTIVE STAFF --
		SELECT DISTINCT
			EM.No_ AS Employee_Number
		FROM 
			[Living Sky Live co_$Employee] EM
		INNER JOIN
			[Living Sky Live co_$Employee Assignment] EA
		ON
			EM.No_ = EA.[Employee No_]
		INNER JOIN
			[Living Sky Live co_$Facility] FA
		ON
			EA.[Facility Code] = FA.Code
		LEFT OUTER JOIN
			[Living Sky Live co_$Employee Additional Info_] AI
		ON
			EM.No_ = AI.[Employee No_] AND AI.[Additional Info_ Class Detail] ='CERT'
		WHERE
			-- CURRENT STAFF MEMBERS --
			((EA.[End Date] = '1753-01-01 00:00:00.000' OR  EA.[End Date] >= GETDATE()
			AND EA.[Effective Date] <=  GETDATE()
			AND EA.[Position Code] NOT LIKE ('SUB')
			AND EM.[Company E-Mail] != ''))
			OR			
			-- STAFF ON LEAVES RETURNING IN THE SAME SCHOOL YEAR -- 
			(EM.No_ IN (SELECT [Employee No_] FROM [Living Sky Live co_$Employee Assignment] WHERE [End Date] > @SCHOOLYEARSTARTDATE AND [Cause of Absence Code] = '')
			AND EA.[Effective Date] > GETDATE() AND EA.[Effective Date] < @SCHOOLYEARENDDATE AND EA.[Cause of Absence Code] = '' )
			AND EA.[Assignment Code] IN ( SELECT VAL FROM @STAFFTYPE )
			AND EA.[Position Code] NOT LIKE ('SUB')
	)
ORDER BY
	"Last Name",
	"First Name"