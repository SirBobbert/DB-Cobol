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
      *Bind output file
           SELECT OUTPUT-FILE ASSIGN TO "opg7-outputfile.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

      *Input file record layout
       FD  INPUT-FILE.
       01  INPUT-RECORD.
           COPY "KUNDER.cpy".

      *Output file record layout
       FD  OUTPUT-FILE.
       01  OUTPUT-RECORD.
           02 NAVN-ADR PIC X(100).

       WORKING-STORAGE SECTION.
      *Loop control flag
       01  EOF-FLAG PIC X VALUE "N".
           88 END-OF-FILE VALUE "Y".
           88 MORE-TO-READ VALUE "N".

      *Formatted output lines
       01 FULDT-NAVN    PIC X(40)  VALUE SPACES.
       01 ADR-LINJE     PIC X(100) VALUE SPACES.
       01 BY-LINJE      PIC X(60)  VALUE SPACES.
       01 KONTO-LINJE   PIC X(50)  VALUE SPACES.
       01 KONTAKT-LINJE PIC X(80)  VALUE SPACES.

       PROCEDURE DIVISION.

      *Main program entry
       MAIN-PROCEDURE.
      *Open input file
           OPEN INPUT  INPUT-FILE
      *Open output file
           OPEN OUTPUT OUTPUT-FILE

      *Process until end of file
           PERFORM UNTIL END-OF-FILE
      *Read next customer record
               READ INPUT-FILE
                   AT END
      *Set EOF flag when no more records
                       SET END-OF-FILE TO TRUE
                   NOT AT END
      *Handle one customer record
                       PERFORM BEHANDL-KUNDE
               END-READ
           END-PERFORM

      *Close input file
           CLOSE INPUT-FILE
      *Close output file
           CLOSE OUTPUT-FILE

      *Display finished message
           DISPLAY "Process done."

      *End program
           STOP RUN.

      *Handle one customer: format and write all lines
       BEHANDL-KUNDE.
      *Format full name line
           PERFORM FORMAT-NAVN
      *Format address line
           PERFORM FORMAT-ADR
      *Format city line
           PERFORM FORMAT-BY
      *Format account line
           PERFORM FORMAT-KONTO
      *Format contact line
           PERFORM FORMAT-KONTAKT
      *Write all formatted lines to output file
           PERFORM SKRIV-KUNDE
           .

      *Build "Fornavn Efternavn"
       FORMAT-NAVN.
      *Clear full name line
           MOVE SPACES TO FULDT-NAVN
      *Concatenate first name and last name
           STRING
               FORNAVN   DELIMITED BY SPACE
               " "       DELIMITED BY SIZE
               EFTERNAVN DELIMITED BY SPACE
               INTO FULDT-NAVN
           END-STRING
           .

      *Build "Vejnavn Husnr Etage Side"
       FORMAT-ADR.
      *Clear address line
           MOVE SPACES TO ADR-LINJE
      *Concatenate street, house number, floor and side
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
           .

      *Build "Postnr Byl Lande-kode"
       FORMAT-BY.
      *Clear city line
           MOVE SPACES TO BY-LINJE
      *Concatenate postal code, city and country code
           STRING
               POSTNR     DELIMITED BY SPACE
               " "        DELIMITED BY SIZE
               BYL        DELIMITED BY SPACE
               " "        DELIMITED BY SIZE
               LANDE-KODE DELIMITED BY SPACE
               INTO BY-LINJE
           END-STRING
           .

      *Build "Konto: <nr> Saldo: <beløb> <valuta>"
       FORMAT-KONTO.
      *Clear account line
           MOVE SPACES TO KONTO-LINJE
      *Concatenate account number, balance and currency
           STRING
               "Konto: "   DELIMITED BY SIZE
               KONTONUMMER DELIMITED BY SPACE
               " Saldo: "  DELIMITED BY SIZE
               BALANCE     DELIMITED BY SIZE
               " "         DELIMITED BY SIZE
               VALUTAKODE  DELIMITED BY SPACE
               INTO KONTO-LINJE
           END-STRING
           .

      *Build "Tlf: <nr> Email: <adresse>"
       FORMAT-KONTAKT.
      *Clear contact line
           MOVE SPACES TO KONTAKT-LINJE
      *Concatenate phone and email
           STRING
               "Tlf: "   DELIMITED BY SIZE
               TELEFON   DELIMITED BY SPACE
               " Email: " DELIMITED BY SIZE
               EMAIL     DELIMITED BY SPACE
               INTO KONTAKT-LINJE
           END-STRING
           .

      *Write all formatted lines for one customer
       SKRIV-KUNDE.
      *Write full name line
           MOVE FULDT-NAVN    TO NAVN-ADR
           WRITE OUTPUT-RECORD
      *Write address line
           MOVE ADR-LINJE     TO NAVN-ADR
           WRITE OUTPUT-RECORD
      *Write city line
           MOVE BY-LINJE      TO NAVN-ADR
           WRITE OUTPUT-RECORD
      *Write account line
           MOVE KONTO-LINJE   TO NAVN-ADR
           WRITE OUTPUT-RECORD
      *Write contact line
           MOVE KONTAKT-LINJE TO NAVN-ADR
           WRITE OUTPUT-RECORD
      *Write blank line between customers
           MOVE SPACES        TO NAVN-ADR
           WRITE OUTPUT-RECORD
           .
