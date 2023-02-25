IMPORT $, STD;

UnemployementRate := $.File_Unemployement.File;

UnemploymentRec := RECORD
    STRING2 State := UnemployementRate.state_abrv,
    UnemployementRate.rate_diff
END;

UnemploymentTab := TABLE(UnemployementRate, UnemploymentRec);

AggUnemployementRate := TABLE(UnemploymentTab, 
                        {
                            State,
                            Agg_rate_diff := SUM(GROUP, (DECIMAL2_1)rate_diff)
                        }, State);

OUTPUT(AggUnemployementRate, NAMED('UnemRate'));
OUTPUT(AggUnemployementRate,,'~FYP::Main::Hacks::TeamFriendshipEmploymentData',NAMED('NewEmploymentData'),OVERWRITE);
