#OPTION('obfuscateOutput', TRUE);

IMPORT Spring2023_Hackathon.FindOurParadise.Datasets, STD, $;

AllSchools := Datasets.File_AllSchools.File;

/**
* Things that we care about:
*   Enrollment >= 100           (Arbitrary, just want enough for a strong social aspect)s
*   Full Time Teachers >= 5     (Coming from Student:Teacher Ratio)
*   Ratio around 10:1           (Students : Teachers)
*   Public Schools            
*   Private Schools
*   State                       (Identifier)
*   County                      (Identifier)
*   Source_Date                 (How recent is the data?, Convert to a score based on most recent date and oldest date)
*/

SchoolFactors := RECORD
    AllSchools.state,       // State Identifier
    AllSchools.county,      // County Identifier
    AllSchools.Public,      // isPublic?
    AllSchools.enrollment,  // Total Enrollment
    AllSchools.ft_teacher,  // Full Time Teachers
    // Care about when the data was sourced, the older the worse
    Source_Date := STD.Date.FromStringToDate(AllSchools.sourcedate[..10], '%Y%m%d'), // Get the Year/Month/Day, ignore time
    STRatio     := ROUND(AllSchools.enrollment / AllSchools.ft_teacher),
END;

// Build Dataset with important factors
AllSchoolFactors := TABLE(AllSchools, SchoolFactors); // Create a table using the important school factors

// Filter down based on Enrollment Count and Student Teacher Ratio
CleanAllSchoolFactors := AllSchoolFactors(enrollment > 100, STRatio >= 10); // Filter down using limits

// Create Table by State
SchoolByState   := TABLE(CleanAllSchoolFactors,
                                                {
                                                state,
                                                state_enrollment := COUNT(GROUP),
                                                PublicCount      := COUNT(GROUP, Public = TRUE),
                                                PrivateCount     := COUNT(GROUP, Public = FALSE),
                                                AVESTRatio       := AVE(COUNT(GROUP), 2)
                                                }
                                                ,state);

// Create Table by County - When the user only cares about Schools 
// we can provide the specific counties instead of just the state
SchoolByCounty   := TABLE(CleanAllSchoolFactors,
                                                {
                                                state,
                                                county,
                                                state_enrollment := COUNT(GROUP),
                                                PublicCount      := COUNT(GROUP, Public = TRUE),
                                                PrivateCount     := COUNT(GROUP, Public = FALSE),
                                                AVESTRatio       := AVE(COUNT(GROUP), 2)
                                                }
                                                ,county);


OUTPUT(SAMPLE(SchoolByState, 5) , NAMED('StateSchoolSample'));
OUTPUT(SAMPLE(SchoolByCounty, 5), NAMED('CountySchoolSample'));