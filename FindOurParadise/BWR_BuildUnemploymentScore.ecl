IMPORT $, STD;

RateRec := RECORD
    STRING2     State,
    DECIMAL2_1  Agg_rate_diff
END;

EmploymentDS := DATASET('~FYP::Main::Hacks::TeamFriendshipEmploymentData', RateRec, FLAT);

OUTPUT(EmploymentDS, NAMED('Test'));

UnemploymentScoreRec := RECORD
    EmploymentDS.State,
    EmploymentDS.Agg_rate_diff,
    UNSIGNED1 UnemploymentScore := 0 // The lower the value the better
END;

Temp := TABLE(EmploymentDS, UnemploymentScoreRec);

AccumulateUnemploymentScore := ITERATE(SORT(Temp, -Agg_rate_diff), 
                                    TRANSFORM(UnemploymentScoreRec,
                                        SELF.UnemploymentScore := IF(LEFT.Agg_rate_diff = RIGHT.Agg_rate_diff,
                                            LEFT.UnemploymentScore, LEFT.UnemploymentScore+1),
                                        SELF := RIGHT));

OUTPUT(AccumulateUnemploymentScore, ,'~FYP::Main::Hacks::TeamFriendshipEmploymentScores', NAMED('EmploymentHealth'), OVERWRITE); 

