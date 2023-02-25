IMPORT $;
WeatherDS  := $.File_Composite.WeatherScoreDS;
CrimeDS    := $.File_Composite.CrimeScoreDS;
EdDS       := $.File_Composite.EduScoreDS;
UnempDS    := $.File_Composite.UnempDS;
HealthDS   := $.File_Composite.HealthScoreDS;

CombLayout := $.File_Composite.Layout;


MergeWeather := PROJECT(WeatherDS,TRANSFORM(CombLayout,SELF.StateName := $.DCT.MapST2Name(LEFT.State),SELF := LEFT,SELF := []));
OUTPUT(MergeWeather,NAMED('AddStateToWeather'));

// ViolentCompRat;
// PropCompRat;
// ViolentScore;
// PropCrimeScore;
MergeCrime := JOIN(MergeWeather,CrimeDS,
                   LEFT.State = Right.State,
                   TRANSFORM(CombLayout,
                             SELF.ViolentCompRat := RIGHT.ViolentCompRat,
                             SELF.PropCompRat    := RIGHT.PropCompRat,
                             SELF.ViolentScore   := RIGHT.ViolentScore,
                             SELF.PropCrimeScore := RIGHT.PropCrimeScore,
                             SELF := LEFT),LOOKUP);
OUTPUT(MergeCrime,NAMED('CrimeandWeather'));

// pubcnt;
// prvcnt;
// avestratio;
// StudentTeacherScore;
// PrvSchoolScore;
// PublicSchoolScore;
MergeEducation := JOIN(MergeCrime,EdDS,
                       LEFT.State = Right.State,
                       TRANSFORM(CombLayout,
                                 SELF.pubcnt              := RIGHT.pubcnt,
                                 SELF.prvcnt              := RIGHT.prvcnt,
                                 SELF.avestratio          := RIGHT.avestratio,
                                 SELF.StudentTeacherScore := RIGHT.StudentTeacherScore,
                                 SELF.PrvSchoolScore      := RIGHT.PrvSchoolScore,
                                 SELF.PublicSchoolScore   := RIGHT.PublicSchoolScore,
                                 SELF := LEFT),LOOKUP);
OUTPUT(MergeEducation,NAMED('CrimeWeatherEducation'));


MergeUnemployment := JOIN(MergeEducation,UnempDS,
                   LEFT.State = Right.State,
                   TRANSFORM(CombLayout,
                             SELF.Agg_rate_diff         := RIGHT.Agg_rate_diff,
                             SELF.UnemploymentScore     := RIGHT.UnemploymentScore,
                             SELF := LEFT),LOOKUP);

OUTPUT(MergeUnemployment,NAMED('CrimeWeatherEducationUnemployment'));


// AggAccidentRate
// AccidentScore
MergeAll := JOIN(MergeUnemployment,HealthDS,
                    LEFT.State = Right.State, // Where the states are the same
                    TRANSFORM(CombLayout,
                    SELF.AggAccidentRate    := RIGHT.AggAccidentRate,
                    SELF.AccidentScore      := RIGHT.AccidentScore,
                    SELF := LEFT),LOOKUP);

OUTPUT(MergeAll,NAMED('All'));
                    
CombLayout CompTotal(CombLayout Le) := TRANSFORM
// STRatio, Private Schools, Public Schools, Violent Crimes, Property Crimes, Accidental Deaths, Event, Injury, Fatality
 SELF.ParadiseScore := Le.StudentTeacherScore + Le.PrvSchoolScore + Le.PublicSchoolScore + Le.ViolentScore + Le.PropCrimeScore +
                       Le.AccidentScore + Le.EvtScore + Le.InjScore + Le.FatScore + Le.UnemploymentScore;
 SELF := Le;
END;              

ParadiseSummary := PROJECT(MergeAll,CompTotal(LEFT));

// Have the scores out of 100 instead of at a limit the user may not know
Max_Paradise_Score := MAX(ParadiseSummary, ParadiseScore);
CombLayout ScaleScore(CombLayout Le) := TRANSFORM
    SELF.ParadiseScore  := (Le.ParadiseScore / Max_Paradise_Score) * 100,
    SELF                := LE
END;

ScaledParadiseSummary := PROJECT(ParadiseSummary, ScaleScore(LEFT));

OUTPUT(ScaledParadiseSummary, NAMED('ScaledScores'));
OUTPUT(ParadiseSummary      ,,'~FYP::Main::Hacks::TeamFriendshipParadiseScores',NAMED('TF_Final_Output')       , OVERWRITE);
OUTPUT(ScaledParadiseSummary,,'~FYP::Main::Hacks::TeamFriendshipParadiseScaled',NAMED('TF_Scaled_Final_Output'), OVERWRITE);