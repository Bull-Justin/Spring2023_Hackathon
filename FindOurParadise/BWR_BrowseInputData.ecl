#OPTION('obfuscateOutput', TRUE);

IMPORT Spring2023_Hackathon.FindOurParadise.Datasets, $;
OUTPUT(Datasets.File_PublicSchools.File,NAMED('PublicSchools'));
OUTPUT(COUNT(Datasets.File_PublicSchools.File),NAMED('Cnt_Public'));

OUTPUT(Datasets.File_PrivateSchools.File,NAMED('PrivateSchools'));
OUTPUT(COUNT(Datasets.File_PrivateSchools.File),NAMED('CntPrivate'));

OUTPUT(Datasets.File_Crimes.File,NAMED('Crimes'));
OUTPUT(COUNT(Datasets.File_Crimes.File),NAMED('Cnt_AllCrimes'));

OUTPUT(Datasets.File_Crimes.File2,NAMED('VCrimes'));
OUTPUT(COUNT(Datasets.File_Crimes.File2),NAMED('Cnt_VCrimes'));

OUTPUT(Datasets.File_Mortality.File,NAMED('Mortality'));
OUTPUT(COUNT(Datasets.File_Mortality.File),NAMED('Cnt_Mortality'));

OUTPUT(Datasets.File_Mortality.File2,NAMED('Mortality_ByState'));
OUTPUT(COUNT(Datasets.File_Mortality.File2),NAMED('Cnt_Mortality_By_State'));

OUTPUT(Datasets.File_Weather.File,NAMED('Storms'));
OUTPUT(COUNT(Datasets.File_Weather.File),NAMED('Cnt_Storms'));

OUTPUT(Datasets.File_StateFIPS.File,NAMED('FIPSLookup'));
OUTPUT(COUNT(Datasets.File_StateFIPS.File),NAMED('Cnt_FIPS'));



