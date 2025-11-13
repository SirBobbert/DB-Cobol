      *.\cobbuild.bat -x opg7.cob -o opg7.exe -lcob
      *.\opg7.exe
             IDENTIFICATION DIVISION.
       PROGRAM-ID. OPG7.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *Bind input file
           SELECT INPUT-FILE ASSIGN TO "opg7-datafile.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUTPUT-FILE ASSIGN TO "opg7-outputfile.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  INPUT-FILE.
       01  INPUT-RECORD.
           COPY "KUNDER.cpy".

       FD OUTPUT-FILE.
       01 OUTPUT-RECORD.
           02 NAVN-ADR PIC X(100).

       WORKING-STORAGE SECTION.
      *Loop control flag
       01  EOF-FLAG PIC X VALUE "N".
           88 END-OF-FILE VALUE "Y".
           88 MORE-TO-READ VALUE "N".


       01 FULDT-NAVN    PIC X(40) VALUE SPACES.
       01 ADR-LINJE     PIC X(100) VALUE SPACES.
       01 BY-LINJE      PIC X(60) VALUE SPACES.
       01 KONTO-LINJE   PIC X(50) VALUE SPACES.
       01 KONTAKT-LINJE PIC X(80) VALUE SPACES.

       PROCEDURE DIVISION.

      *Open files
           OPEN INPUT  INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE

      *Process until EOF
           PERFORM UNTIL END-OF-FILE
      *Read next line
               READ INPUT-FILE
                   AT END
                       SET END-OF-FILE TO TRUE
                   NOT AT END

      *Byg linjer ud fra den nye struktur i KUNDER.cpy

      *Fuldt navn: "Fornavn Efternavn"
                       MOVE SPACES TO FULDT-NAVN
                       STRING
                           FORNAVN DELIMITED BY SPACE
                           " "     DELIMITED BY SIZE
                           EFTERNAVN DELIMITED BY SPACE
                           INTO FULDT-NAVN
                       END-STRING

      *Adresse-linje: "Vejnavn Husnr Etage Side"
                       MOVE SPACES TO ADR-LINJE
                       STRING
                           VEJNAVN DELIMITED BY SPACE
                           " "     DELIMITED BY SIZE
                           HUSNR   DELIMITED BY SPACE
                           " "     DELIMITED BY SIZE
                           ETAGE   DELIMITED BY SPACE
                           " "     DELIMITED BY SIZE
                           SIDE    DELIMITED BY SPACE
                           INTO ADR-LINJE
                       END-STRING

      *By-linje: "Postnr Byl"
                       MOVE SPACES TO BY-LINJE
                       STRING
                           POSTNR DELIMITED BY SPACE
                           " "    DELIMITED BY SIZE
                           BYL    DELIMITED BY SPACE
                           INTO BY-LINJE
                       END-STRING

      *Konto-linje
                       MOVE SPACES TO KONTO-LINJE
                       STRING
                           "Konto: "      DELIMITED BY SIZE
                           KONTONUMMER    DELIMITED BY SPACE
                           " Saldo: "     DELIMITED BY SIZE
                           BALANCE        DELIMITED BY SIZE
                           " "            DELIMITED BY SIZE
                           VALUTAKODE     DELIMITED BY SPACE
                           INTO KONTO-LINJE
                       END-STRING

      *Kontakt-linje
                       MOVE SPACES TO KONTAKT-LINJE
                       STRING
                           "Tlf: "  DELIMITED BY SIZE
                           TELEFON  DELIMITED BY SPACE
                           " Email: " DELIMITED BY SIZE
                           EMAIL    DELIMITED BY SPACE
                           INTO KONTAKT-LINJE
                       END-STRING

      *Og så skriver du dem i output-filen
                       MOVE FULDT-NAVN    TO NAVN-ADR
                       WRITE OUTPUT-RECORD

                       MOVE ADR-LINJE     TO NAVN-ADR
                       WRITE OUTPUT-RECORD

                       MOVE BY-LINJE      TO NAVN-ADR
                       WRITE OUTPUT-RECORD

                       MOVE KONTO-LINJE   TO NAVN-ADR
                       WRITE OUTPUT-RECORD

                       MOVE KONTAKT-LINJE TO NAVN-ADR
                       WRITE OUTPUT-RECORD

      *Evt. tom linje mellem kunder
                       MOVE SPACES TO NAVN-ADR
                       WRITE OUTPUT-RECORD
                   END-READ
           END-PERFORM

      *Close files
           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE

           DISPLAY "Process done."
           STOP RUN.
