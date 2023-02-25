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
    sourceyear := STD.Date.Year(STD.Date.FromStringtoDate(AllSchools.sourcedate[ ..10], '%Y/%m/%d')),
    // Care about when the data was sourced, the older the worse
    STRatio         := ROUND(AllSchools.enrollment / AllSchools.ft_teacher),
END;

// Build Dataset with important factors
AllSchoolFactors := TABLE(AllSchools, SchoolFactors); // Create a table using the important school factors

// Filter down based on Enrollment Count and Student Teacher Ratio
CleanAllSchoolFactors := AllSchoolFactors(enrollment > 100, STRatio >= 10); // Filter down using limits

// Create Table by State
SchoolByState   := TABLE(CleanAllSchoolFactors,
                                                {
                                                state,
                                                sourceyear,
                                                PublicCount      := COUNT(GROUP, Public = TRUE),
                                                PrivateCount     := COUNT(GROUP, Public = FALSE),
                                    DECIMAL5_2  PrivPubRatio     := 0,
                                                AVESTRatio       := ROUND(AVE(GROUP,STRatio), 2),
                                                MAX_YEAR         := MAX(GROUP, sourceyear),
                                                Year_Weight      := 0
                                                }
                                                ,state);


// Create Table by County - When the user only cares about Schools
// we can provide the specific counties instead of just the state
SchoolByCounty   := TABLE(CleanAllSchoolFactors,
                                                {
                                                state,
                                                county,
                                                sourceyear,
                                                PublicCount      := COUNT(GROUP, Public = TRUE),
                                                PrivateCount     := COUNT(GROUP, Public = FALSE),
                                    DECIMAL5_2  PrivPubRatio     := 0,
                                                AVESTRatio       := AVE(COUNT(GROUP), 2),
                                                MAX_YEAR         := MAX(GROUP, sourceyear),
                                                Year_Weight      := 0
                                                }
                                                ,county);


final_SchoolByState := PROJECT(SchoolByState, 
                                TRANSFORM(RECORDOF(SchoolByState),
                                         SELF.PrivPubRatio  := ((LEFT.PrivateCount / LEFT.PublicCount) * 100),
                                         SELF := LEFT
                                         ));


// Want to change to have the school ratio by county in a specific state
final_SchoolByCounty := PROJECT(SchoolByCounty, 
                                TRANSFORM(RECORDOF(SchoolByCounty),
                                         SELF.PrivPubRatio := ((LEFT.PrivateCount / LEFT.PublicCount) * 100),
                                         SELF := LEFT
                                         ));


OUTPUT(final_SchoolByState , NAMED('StateSchool'));
OUTPUT(final_SchoolByCounty, NAMED('CountySchool'));


OUTPUT(final_SchoolByState ,,'~FYP::Main::Hacks::TeamFriendshipSchoolState' , NAMED('TeamFriendshipStateCountsRatios'),OVERWRITE);
OUTPUT(final_SchoolByCounty,,'~FYP::Main::Hacks::TeamFriendshipSchoolCounty', NAMED('TeamFriendshipCountyCountsRatios'),OVERWRITE);