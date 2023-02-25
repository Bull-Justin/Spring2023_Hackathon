#OPTION('obfuscateOutput', TRUE);

// Year, State, Rate, Deaths

IMPORT Spring2023_Hackathon.FindOurParadise.Datasets.File_NewHealth, STD;

AccidentalDeaths := File_NewHealth.File;

Min_Year := MIN(AccidentalDeaths, (INTEGER)Year)-1;
Max_Year := MAX(AccidentalDeaths, (INTEGER)Year);
OUTPUT(Min_Year, NAMED('MIN'));
OUTPUT(Max_Year, NAMED('MAX'));

DeathRates := RECORD
    AccidentalDeaths.State,
    AccidentalDeaths.Year,
    // Max year is 2020, Min Year is 2004. 
    // If data point year is 2014, 2014 - 2004 - 1 = 9, 
    // divide by 16 to get a weight to apply to the rate.
    REAL weighted_Rate := (INTEGER)(AccidentalDeaths.Rate) * (((INTEGER)AccidentalDeaths.Year - Min_Year) / (Max_Year - Min_Year))
END;

DeathTab := TABLE(AccidentalDeaths, DeathRates);
OUTPUT(SAMPLE(DeathTab, 5), NAMED('NewHealth'));

// AggregateHealth := RECORD
//     AccidentalDeaths.State,
//     TotalAccidentRate := SUM(GROUP, DeathTab.weighted_Rate),
// END;

// AggHealthTab := TABLE(DeathTab, AggregateHealth, State);

AggHealthTab := TABLE(DeathTab, {
                                 State,
                                 AggAccidentRate := (INTEGER)SUM(GROUP, weighted_Rate)
                                },
                                State);

OUTPUT(AggHealthTab, NAMED('SummedRates'));
OUTPUT(AggHealthTab,,'~FYP::Main::Hacks::TeamFriendshipHealthData',NAMED('NewHealthData'),OVERWRITE);