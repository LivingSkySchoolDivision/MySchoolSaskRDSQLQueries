select skl.SKL_SCHOOL_NAME, std.STD_NAME_VIEW, pat.PAT_REASON_CODE, pat.PAT_DATE
from MSS_STUDENT_PERIOD_ATTENDANCE PAT
inner join MSS_STUDENT std on pat.PAT_STD_OID = std.STD_OID
inner join MSS_SCHOOL skl on pat.PAT_SKL_OID = skl.SKL_OID
where PAT_REASON_CODE = 'Counselling' and pat.PAT_DATE > '08-01-2022'
order by skl.SKL_SCHOOL_NAME


select skl.SKL_SCHOOL_NAME, std.STD_NAME_VIEW, pat.PAT_REASON_CODE, pat.PAT_DATE
from MSS_STUDENT_PERIOD_ATTENDANCE PAT
inner join MSS_STUDENT std on pat.PAT_STD_OID = std.STD_OID
inner join MSS_SCHOOL skl on pat.PAT_SKL_OID = skl.SKL_OID
where PAT_REASON_CODE = 'Unexcused' and pat.PAT_DATE > '08-01-2022'
order by skl.SKL_SCHOOL_NAME