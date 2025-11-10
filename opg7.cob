      *.\cobbuild.bat -x opg7.cob -o opg7.exe -lcob
      *.\opg7.exe
             IDENTIFICATION DIVISION.
       PROGRAM-ID. OPG7.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *Bind input file
           SELECT INPUT-FILE ASSIGN TO "opg6-datafile.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
      *Bind output file
           SELECT OUTPUT-FILE ASSIGN TO "opg7-outputfile.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-RECORD.
           05 NAME PIC X(5).
           05 AGE  PIC 99.

       FD  OUTPUT-FILE.
       01  OUTPUT-RECORD.
           05 NAME PIC X(5).
           05 AGE  PIC 99.

       WORKING-STORAGE SECTION.
      *Loop control flag
       01  END-OF-FILE PIC X VALUE "N".

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
      *Open files
           OPEN INPUT  INPUT-FILE.
           OPEN OUTPUT OUTPUT-FILE.

      *Process until EOF
           PERFORM UNTIL END-OF-FILE = "Y"
      *Read next line
               READ INPUT-FILE
                   AT END
                       MOVE "Y" TO END-OF-FILE
                   NOT AT END
      *Copy input record to output record
                       MOVE INPUT-RECORD TO OUTPUT-RECORD
      *Write to output
                       WRITE OUTPUT-RECORD
      *Echo to console using qualified names
                       DISPLAY "Name: " NAME OF OUTPUT-RECORD
                               ", Age: " AGE OF OUTPUT-RECORD
               END-READ
           END-PERFORM.

      *Close files
           CLOSE INPUT-FILE.
           CLOSE OUTPUT-FILE.

      *End
           STOP RUN.
