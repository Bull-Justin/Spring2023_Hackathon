#OPTION('obfuscateOutput', TRUE);

STSchoolScoresRec := RECORD
    STRING2     State,
    INTEGER8    StateCount,
    INTEGER8    PublicCount,
    INTEGER8    PrivateCount,
    REAL8       AVESTRatio
END;
CTSchoolScoresRec := RECORD
    STRING2     State,
    STRING      County,
    INTEGER8    StateCount,
    INTEGER8    PublicCount,
    INTEGER8    PrivateCount,
    REAL8       AVESTRatio
END;

EdScoreStateDS  := DATASET('~FYP::Main::Hacks::TeamFriendshipSchoolState', STSchoolScoresRec, THOR);
EdScoreCountyDS := DATASET('~FYP::Main::Hacks::TeamFriendshipSchoolCounty', CTSchoolScoresRec, THOR);

ScoreTbl_State := RECORD
    EdScoreStateDS.State,
    EdScoreStateDS.PublicCount,
    EdScoreStateDS.PrivateCount,
    EdScoreStateDS.AVESTRatio,
    UNSIGNED1 STScore := 0,
    UNSIGNED1 PrivSchoolScore := 0,
    UNSIGNED1 PubSchoolScore := 0
END;

// ScoreTbl_County
ScoreTbl_County:= RECORD
    EdScoreCountyDS.State,
    EDScoreCountyDS.County,
    EdScoreCountyDS.PublicCount,
    EdScoreCountyDS.PrivateCount,
    EdScoreCountyDS.AVESTRatio,
    UNSIGNED1 STScore := 0,
    UNSIGNED1 PrivSchoolScore := 0,
    UNSIGNED1 PubSchoolScore := 0
END;

temp_State  := TABLE(EdScoreStateDS, ScoreTbl_State);

temp_County := TABLE(EdScoreCountyDS, ScoreTbl_County);


AddSTScore  := ITERATE(SORT(temp_State,-AVESTRatio),
                            TRANSFORM(ScoreTbl_State,
                                      SELF.STScore := IF(LEFT.AVESTRatio = RIGHT.AVESTRatio,
                                                    LEFT.STScore,LEFT.STScore+1),
                                      SELF := RIGHT));
AddPrvScore := ITERATE(SORT(AddSTScore, PrivateCount), 
                        TRANSFORM(ScoreTbl_State,
                          SELF.PrivSchoolScore := IF(LEFT.PrivateCount = RIGHT.PrivateCount,
                                            LEFT.PrivSchoolScore,LEFT.PrivSchoolScore+1),
                                            SELF := RIGHT));
AddPubScore := ITERATE(SORT(AddPrvScore, PublicCount),
                        TRANSFORM(ScoreTbl_State,
                          SELF.PubSchoolScore := IF(LEFT.PublicCount = RIGHT.PublicCount,
                                                        LEFT.PubSchoolScore,
                                                        LEFT.PubSchoolScore+1),
                          SELF := RIGHT));


OUTPUT(AddPubScore,,'~FYP::Main::Hacks::TeamFriendshipStateEducationScores', NAMED('StateScores'), OVERWRITE);

AddCTScore  := ITERATE(SORT(temp_County,-AVESTRatio),
                            TRANSFORM(ScoreTbl_County,
                                      SELF.STScore := IF(LEFT.AVESTRatio = RIGHT.AVESTRatio,
                                                    LEFT.STScore,LEFT.STScore+1),
                                      SELF := RIGHT));
AddCTPrvScore := ITERATE(SORT(AddCTScore, PrivateCount), 
                        TRANSFORM(ScoreTbl_County,
                          SELF.PrivSchoolScore := IF(LEFT.PrivateCount = RIGHT.PrivateCount,
                                            LEFT.PrivSchoolScore,LEFT.PrivSchoolScore+1),
                                            SELF := RIGHT));
AddCTPubScore := ITERATE(SORT(AddCTPrvScore, PublicCount),
                        TRANSFORM(ScoreTbl_County,
                          SELF.PubSchoolScore := IF(LEFT.PublicCount = RIGHT.PublicCount,
                                                        LEFT.PubSchoolScore,
                                                        LEFT.PubSchoolScore+1),
                          SELF := RIGHT));

OUTPUT(AddCTPubScore,,'~FYP::Main::Hacks::TeamFriendshipCountyEducationScores', NAMED('CountyScores'), OVERWRITE);