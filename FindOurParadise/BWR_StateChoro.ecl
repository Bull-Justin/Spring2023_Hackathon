IMPORT Visualizer, $;

WeatherDS  := $.File_Composite.WeatherScoreDS;
CrimeDS    := $.File_Composite.CrimeScoreDS;
EdDS       := $.File_Composite.EduScoreDS;
HealthDS   := $.File_Composite.HealthScoreDS;
UnempDS    := $.File_Composite.UnempDS;



state := TABLE(HealthDS, {state, Weatherscore}, FEW);
OUTPUT(state, NAMED('state_ad'));
Visualizer.Choropleth.USStates('StateWeather', , 'state_ad', , , DATASET([{'paletteID', 'Blues'}], Visualizer.KeyValueDef));

state := TABLE(UnempDS, {state, Mortalityscore}, FEW);
OUTPUT(state, NAMED('state_ump'));
Visualizer.Choropleth.USStates('StateWeather', , 'state_ump', , , DATASET([{'paletteID', 'Purples'}], Visualizer.KeyValueDef));

state := TABLE(EdDS, {state, Mortalityscore}, FEW);
OUTPUT(state, NAMED('state_ed'));
Visualizer.Choropleth.USStates('StateWeather', , 'state_ed', , , DATASET([{'paletteID', 'Greens'}], Visualizer.KeyValueDef));

state := TABLE(CrimeDS, {state, Mortalityscore}, FEW);
OUTPUT(state, NAMED('state_crime'));
Visualizer.Choropleth.USStates('StateWeather', , 'state_crime', , , DATASET([{'paletteID', 'Reds'}], Visualizer.KeyValueDef));

state := TABLE(WeatherDS, {state, Mortalityscore}, FEW);
OUTPUT(state, NAMED('state_weather'));
Visualizer.Choropleth.USStates('StateWeather', , 'state_weather', , , DATASET([{'paletteID', 'Yellows'}], Visualizer.KeyValueDef));