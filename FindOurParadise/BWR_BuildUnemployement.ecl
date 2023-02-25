IMPORT $, STD;

UnemployementRate := $.File_Unemployement.File;

UnemploymentRec := RECORD
    UnemployementRate.state_abrv,
    UnemployementRate.rate_diff
END;

UnemploymentTab := TABLE(UnemployementRate, UnemploymentRec);

AggUnemployementRate := TABLE(UnemploymentTab, 
                        {
                            state_abrv,
                            Agg_rate_diff := SUM(GROUP, (DECIMAL2_1)rate_diff)
                        }, state_abrv);

OUTPUT(AggUnemployementRate, NAMED('UnemRate'));
OUTPUT(AggUnemployementRate,,'~FYP::Main::Hacks::TeamFriendshipEmploymentData',NAMED('NewEmploymentData'),OVERWRITE);
