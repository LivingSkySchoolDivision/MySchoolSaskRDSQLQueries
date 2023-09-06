SELECT DISTINCT
	CASE WHEN AI.[Text 1 Value] IS NULL THEN '' ELSE AI.[Text 1 Value] END AS "Educator Certificate Number",
	CASE WHEN EM.[Preferred Last Name] = '' THEN EM.[Last Name] ELSE EM.[Preferred Last Name] END AS "Last Name",
	CASE WHEN EM.[Preferred First Name] = '' THEN EM.[First Name] ELSE EM.[Preferred First Name] END AS "First Name",	
	FORMAT(EM.[Birth Date], 'yyyy-MM-dd') AS "Birth Date"
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
