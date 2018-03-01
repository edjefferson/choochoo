In theory this can translate the Timetable Data from http://data.atoc.org/data-download into something comprehensible.

It might not actually work for anyone who isn't me.

There's an Import class which processes the raw data into CSVs and then the BasicSchedule model can import that into a Postgres database.
