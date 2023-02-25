EXPORT File_NewHealth := MODULE
    EXPORT Layout := RECORD
    STRING YEAR;
    STRING STATE;
    STRING RATE;
    STRING DEATHS;
    STRING URL;
    END;

    EXPORT File := DATASET('~accidental_deaths.csv', Layout, CSV(HEADING(1)));
END;
