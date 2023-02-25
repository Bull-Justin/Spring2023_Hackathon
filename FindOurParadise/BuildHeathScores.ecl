#OPTION('obfuscateOutput', TRUE);

HealthRec := RECORD
    STRING2 State,
    INTEGER AggAccidentRate
END;

Health_DS := DATASET('~FYP::Main::Hacks::TeamFriendshipHealthData', HealthRec, FLAT);

OUTPUT(Health_DS, NAMED('test'));

HealthScoreRec := RECORD
    Health_DS.State,
    Health_DS.AggAccidentRate,
    UNSIGNED1 AccidentScore := 0
END;

Temp := TABLE(Health_DS, HealthScoreRec);

AccumulateAccidentScore := ITERATE(SORT(Temp, -AggAccidentRate), 
                                    TRANSFORM(HealthScoreRec,
                                        SELF.AccidentScore := IF(LEFT.AggAccidentRate = RIGHT.AggAccidentRate,
                                            LEFT.AccidentScore, LEFT.AccidentScore+1),
                                        SELF := RIGHT));

                     
OUTPUT(AccumulateAccidentScore, ,'~FYP::Main::Hacks::TeamFriendshipHealthScores', NAMED('TopHealth'), OVERWRITE);