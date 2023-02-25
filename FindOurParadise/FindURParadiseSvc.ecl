IMPORT $;
ParaIDX := $.File_Composite.IDX;

EXPORT FindURParadiseSvc() := FUNCTION
Parms := STORED($.iParadise);

RECORDOF(ParaIDX) CalcScore(ParaIDX Le) := TRANSFORM
 STR  := IF(Parms.Student_Teacher_Ratio,Le.StudentTeacherScore,0);
 PSC  := IF(Parms.Public_School_Count,  Le.PrvSchoolScore,0);
 PSC2 := IF(Parms.Private_School_Count, Le.PublicSchoolScore,0);
 VC   := IF(Parms.Violent_Crimes,       Le.ViolentScore,0);
 PC   := IF(Parms.Property_Crimes,      Le.PropCrimeScore,0);
 AD   := IF(Parms.Accident_Deaths,      Le.AccidentScore,0); // Health DS
 WE   := IF(Parms.Weather_Events,       Le.EvtScore,0);
 WI   := IF(Parms.Weather_Injuries,     Le.InjScore,0);
 WF   := IF(Parms.Weather_Fatalities,   Le.FatScore,0);
 UR   := IF(Parms.Unemployment_Rate,    Le.UnemploymentScore,0); // Unemployment SF
 SELF.ParadiseScore := STR + PSC + PSC2 + VC + PC + AD + WE + WI + WF + UR;
 SELF := Le                       
END;

ParaCustom := PROJECT(ParaIDX,CalcScore(LEFT));

Res := IF(Parms.I_Want_It_All = TRUE,
          SORT(ParaIDX,   -ParadiseScore),
          SORT(ParaCustom,-ParadiseScore));
   
RETURN Res;   
   
END;   