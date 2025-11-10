      *.\cobbuild.bat -x opg6.cob -o opg6.exe -lcob
      *.\opg6.exe
             IDENTIFICATION DIVISION.
       PROGRAM-ID. OPG6.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *Bind input file
           SELECT INPUT-FILE ASSIGN TO "opg6-datafile.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-RECORD.
           05 NAME PIC X(5).
           05 AGE  PIC 99.

       WORKING-STORAGE SECTION.
      *Loop control flag
       01  END-OF-FILE PIC X VALUE "N".

       PROCEDURE DIVISION.
      *Open files
           OPEN INPUT  INPUT-FILE.

      *Process until EOF   
           PERFORM UNTIL END-OF-FILE = "Y"
      *Read next line
               READ INPUT-FILE
                   AT END
                       MOVE "Y" TO END-OF-FILE
                   NOT AT END
                       DISPLAY "Name: " NAME OF INPUT-RECORD
                               ", Age: " AGE OF INPUT-RECORD
               END-READ
           END-PERFORM.

      *Close files
           CLOSE INPUT-FILE.

      *End
           STOP RUN.
