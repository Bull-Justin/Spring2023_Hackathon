IMPORT Visualizer, $;

WeatherDS  := $.File_Composite.WeatherScoreDS;
CrimeDS    := $.File_Composite.CrimeScoreDS;
EdDS       := $.File_Composite.EduScoreDS;
HealthDS   := $.File_Composite.HealthScoreDS;
UnempDS    := $.File_Composite.UnempDS;


// WEATHER
state := TABLE(WeatherDS, {state, evtscore}, FEW);
OUTPUT(state, NAMED('state_evt'));
Visualizer.Choropleth.USStates('StateWeather_EVT', , 'state_evt', , , DATASET([{'paletteID', 'Blues'}], Visualizer.KeyValueDef));

state := TABLE(WeatherDS, {state, injscore}, FEW);
OUTPUT(state, NAMED('state_inj'));
Visualizer.Choropleth.USStates('StateWeather_INJ', , 'state_inj', , , DATASET([{'paletteID', 'Blues'}], Visualizer.KeyValueDef));

state := TABLE(WeatherDS, {state, fatscore}, FEW);
OUTPUT(state, NAMED('state_fat'));
Visualizer.Choropleth.USStates('StateWeather_FAT', , 'state_fat', , , DATASET([{'paletteID', 'Blues'}], Visualizer.KeyValueDef));


// EDUCATION
state := TABLE(EdDS, {state, StudentTeacherScore}, FEW);
OUTPUT(state, NAMED('state_edRT'));
Visualizer.Choropleth.USStates('StateSchoolRatio', , 'state_edRT', , , DATASET([{'paletteID', 'Greens'}], Visualizer.KeyValueDef));

state := TABLE(EdDS, {state, PublicSchoolScore}, FEW);
OUTPUT(state, NAMED('state_edPUB'));
Visualizer.Choropleth.USStates('StateSchoolPub', , 'state_edPUB', , , DATASET([{'paletteID', 'Greens'}], Visualizer.KeyValueDef));

state := TABLE(EdDS, {state, PrivateSchoolScore}, FEW);
OUTPUT(state, NAMED('state_edPRIV'));
Visualizer.Choropleth.USStates('StateSchoolPriv', , 'state_edPRIV', , , DATASET([{'paletteID', 'Greens'}], Visualizer.KeyValueDef));


// CRIME
state := TABLE(CrimeDS, {state, ViolentScore}, FEW);
OUTPUT(state, NAMED('state_crime'));
Visualizer.Choropleth.USStates('StateCrime_VIO', , 'state_crime', , , DATASET([{'paletteID', 'Reds'}], Visualizer.KeyValueDef));

state := TABLE(CrimeDS, {state, PropCrimeScore}, FEW);
OUTPUT(state, NAMED('state_crime'));
Visualizer.Choropleth.USStates('StateCrime_PROP', , 'state_crime_non', , , DATASET([{'paletteID', 'Reds'}], Visualizer.KeyValueDef));


// HEALTH
state := TABLE(HealthDS, {state, AccidentScore}, FEW);
OUTPUT(state, NAMED('state_accident'));
Visualizer.Choropleth.USStates('StateCrime', , 'state_accident', , , DATASET([{'paletteID', 'Reds'}], Visualizer.KeyValueDef));


// UNEMPLOYMENT
state := TABLE(UnempDS, {state, UnemploymentScore}, FEW);
OUTPUT(state, NAMED('state_ump'));
Visualizer.Choropleth.USStates('StateUnemployment', , 'state_ump', , , DATASET([{'paletteID', 'Purples'}], Visualizer.KeyValueDef));

