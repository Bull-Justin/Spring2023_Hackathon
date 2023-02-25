#OPTION('obfuscateOutput', TRUE);

IMPORT Spring2023_Hackathon.FindOurParadise.Datasets, STD, $;

AllSchools := Datasets.File_AllSchools.File;

/**
* Things that we care about:
*   Enrollment >= 100           (Arbitrary, just want enough for a strong social aspect)s
*   Full Time Teachers
*   Ratio around 10:1           (Students : Teachers)
*   Public Schools              (Bool is public?)
*   State                       (Identifier)
*   County                      (Identifier)
*/


SchoolFactors := RECORD
    AllSchools.state,       // State Identifier
    AllSchools.county,      // County Identifier
    AllSchools.Public,      // isPublic?
    AllSchools.enrollment,  // Total Enrollment
    AllSchools.ft_teacher,  // Full Time Teachers
    STRatio         := ROUND(AllSchools.enrollment / AllSchools.ft_teacher),
END;

// Build Dataset with important factors
AllSchoolFactors := TABLE(AllSchools, SchoolFactors); // Create a table using the important school factors

// Filter down based on Enrollment Count and Student Teacher Ratio
CleanAllSchoolFactors := AllSchoolFactors(enrollment >= 100, STRatio <= 10); // Enrollment is at least 100, Full Time teacher to student is at least 
// OUTPUT(COUNT(CleanAllSchoolFactors), NAMED('FilteredSchoolCount'));

// Create Table by State
SchoolByState   := TABLE(CleanAllSchoolFactors,
                                                {
                                                State,
                                                StateCount       := COUNT(GROUP),
                                                PublicCount      := COUNT(GROUP, Public = TRUE),
                                                PrivateCount     := COUNT(GROUP, Public = FALSE),
                                                AVESTRatio       := ROUND(AVE(GROUP,STRatio), 2),
                                                }
                                                ,state);


// Create Table by County - When the user only cares about Schools
// we can provide the specific counties instead of just the state
SchoolByCounty   := TABLE(CleanAllSchoolFactors,
                                                {
                                                State,
                                                County,
                                                PublicCount      := COUNT(GROUP, Public = TRUE),
                                                PrivateCount     := COUNT(GROUP, Public = FALSE),
                                                AVESTRatio       := AVE(COUNT(GROUP), 2),
                                                }
                                                ,county);


OUTPUT(SchoolByState , NAMED('StateSchool'));
OUTPUT(SchoolByCounty, NAMED('CountySchool'));

OUTPUT(SchoolByState ,,'~FYP::Main::Hacks::TeamFriendshipSchoolState' , NAMED('TeamFriendshipStateCountsRatios'),OVERWRITE);
OUTPUT(SchoolByCounty,,'~FYP::Main::Hacks::TeamFriendshipSchoolCounty', NAMED('TeamFriendshipCountyCountsRatios'),OVERWRITE);