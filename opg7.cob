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
           02 NAVN-ADR PIC X(100).

       FD  OUTPUT-FILE.
       01  KUNDE-ADR.
           02 NAVN-ADR PIC X(100).

       WORKING-STORAGE SECTION.
      *Loop control flag
       01  END-OF-FILE PIC X VALUE "N".
           88 END-OF-FILE VALUE "Y".
           88 MORE-TO-READ VALUE "N".

       01 FULDE-NAVN PIC X(100) VALUE SPACES.
       01 ADR-LINJE PIC X(100) VALUE SPACES.
       01 BY-LINJE PIC X(100) VALUE SPACES.
       01 KONTO-LINJE PIC X(100) VALUE SPACES.
       01 KONTAKT-LINJE PIC X(100) VALUE SPACES.

       PROCEDURE DIVISION.
       MAIN-PROGRAM.
      *Open files
           OPEN INPUT  INPUT-FILE.
           OPEN OUTPUT OUTPUT-FILE.

      *Process until EOF
           PERFORM UNTIL END-OF-FILE
      *Read next line
               READ INPUT-FILE
                   AT END
                       SET END-OF-FILE TO TRUE
                   NOT AT END
                       PERFORM BEHANDL-KUNDE
                   END-READ
               END-PERFORM
               CLOSE KUNDE-ADR
      *Copy input record to output record
                       DISPLAY "-------------------"
                       DISPLAY INPUT-RECORD
                       DISPLAY "-------------------"
                       MOVE INPUT-RECORD TO KUNDE-ADR
      *Write to output
                       WRITE KUNDE-ADR
      *Echo to console using qualified names
                       *>DISPLAY "Name: " NAVN-ADR OF KUNDE-ADR
               END-READ
           END-PERFORM.

      *Close files
           CLOSE INPUT-FILE.
           CLOSE OUTPUT-FILE.

      *End
           STOP RUN.
