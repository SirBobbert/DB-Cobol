       IDENTIFICATION DIVISION.
       PROGRAM-ID. OPGAVE8.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      * Bind customer file
           SELECT KUNDEFIL ASSIGN TO "Kundeoplysninger.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
      * Bind account file
           SELECT KONTOFIL ASSIGN TO "KontoOpl.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
      * Bind output file
           SELECT OUT-FIL ASSIGN TO "KUNDEKONTO_OPG9.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

      * Customer file record layout
       FD  KUNDEFIL.
       01  KUNDE-REKORD.
           COPY "KUNDEOPL.cpy".

      * Account file record layout
       FD  KONTOFIL.
       01  KONTO-REKORD.
           COPY "KONTOOPL.cpy".

      * Output file record layout
       FD  OUT-FIL.
       01  OUT-REKORD.
           02 OUTPUT-TEXT PIC X(150).

       WORKING-STORAGE SECTION.

      * End-of-file flag for customer file
       01  EOF-KUNDE          PIC X VALUE "N".
           88 END-KUNDE       VALUE "Y".
           88 MORE-KUNDE      VALUE "N".

      * End-of-file flag for account file
       01  EOF-KONTI          PIC X VALUE "N".
           88 END-KONTI       VALUE "Y".
           88 MORE-KONTI      VALUE "N".

      * Formatted customer name
       01  FULDT-NAVN         PIC X(40) VALUE SPACES.
      * Formatted address line 1
       01  ADR-LINJE1         PIC X(60) VALUE SPACES.
      * Formatted address line 2
       01  ADR-LINJE2         PIC X(40) VALUE SPACES.

      * Account array: 50 account records in memory
       01  KONTO-ARRAY OCCURS 50 TIMES.
           COPY "KONTOOPL.cpy".

      * Counter for number of accounts read
       01  KONTO-COUNT  PIC 9(3) VALUE 0.
      * Index when looping over accounts
       01  IX-KONTI     PIC 9(3) VALUE 1.

       PROCEDURE DIVISION.
       MAIN-PROGRAM.

      * First: read all accounts into KONTO-ARRAY
           OPEN INPUT KONTOFIL
           MOVE 1 TO KONTO-COUNT
           MOVE "N" TO EOF-KONTI

           PERFORM UNTIL END-KONTI
               READ KONTOFIL
                   AT END
                       SET END-KONTI TO TRUE
                   NOT AT END
                       MOVE KONTO-REKORD
                         TO KONTO-ARRAY(KONTO-COUNT)
                       ADD 1 TO KONTO-COUNT
               END-READ
           END-PERFORM

           CLOSE KONTOFIL

      * Then: open customer + output files
           OPEN INPUT  KUNDEFIL
                OUTPUT OUT-FIL

      * Process all customers
           PERFORM UNTIL END-KUNDE

      * Read next customer record
               READ KUNDEFIL
                   AT END
      * Set EOF flag when there are no more customers
                       SET END-KUNDE TO TRUE
                   NOT AT END
      * Format customer data
                       PERFORM FORMAT-NAVN
                       PERFORM FORMAT-VEJ
                       PERFORM FORMAT-BY
      * Write customer header and address
                       PERFORM SKRIV-KUNDE
      * Read and write all accounts for this customer
                       PERFORM MATCH-KONTI
      * Write a blank line between customers
                       MOVE SPACES TO OUTPUT-TEXT
                       WRITE OUT-REKORD
               END-READ
           END-PERFORM

      * Close files
           CLOSE KUNDEFIL
                 OUT-FIL

      * End program
           STOP RUN.

      * -------------------------------------------------
      * Format full name "Fornavn Efternavn"
       FORMAT-NAVN.
      * Clear name line
           MOVE SPACES TO FULDT-NAVN
      * Build full name
           STRING
               FORNAVN   OF KUNDE-REKORD DELIMITED BY SPACE
               " "                       DELIMITED BY SIZE
               EFTERNAVN OF KUNDE-REKORD DELIMITED BY SPACE
               INTO FULDT-NAVN
           END-STRING
           EXIT.

      * -------------------------------------------------
      * Format street address "Vejnavn Husnr Etage Side"
       FORMAT-VEJ.
      * Clear address line 1
           MOVE SPACES TO ADR-LINJE1
      * Build first address line
           STRING
               VEJNAVN OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SPACE
               " "                          DELIMITED BY SIZE
               HUSNR   OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SPACE
               " "                          DELIMITED BY SIZE
               ETAGE   OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SPACE
               " "                          DELIMITED BY SIZE
               SIDE    OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SPACE
               INTO ADR-LINJE1
           END-STRING
           EXIT.

      * -------------------------------------------------
      * Format city/postcode "Postnr By"
       FORMAT-BY.
      * Clear address line 2
           MOVE SPACES TO ADR-LINJE2
      * Build second address line
           STRING
               POSTNR OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
               " "                       DELIMITED BY SIZE
               BY-X  OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
               INTO ADR-LINJE2
           END-STRING
           EXIT.

      * -------------------------------------------------
      * Write customer information (id, name, address, contact)
       SKRIV-KUNDE.
      * Write "Kunde-ID" and name
           MOVE SPACES TO OUTPUT-TEXT
           STRING
               "Kunde-ID: "                DELIMITED BY SIZE
               KUNDE-ID OF KUNDE-REKORD    DELIMITED BY SIZE
               " | Navn: "                 DELIMITED BY SIZE
               FULDT-NAVN                  DELIMITED BY SIZE
               INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD

      * Write address line
           MOVE SPACES TO OUTPUT-TEXT
           STRING
               "Adresse: "                 DELIMITED BY SIZE
               ADR-LINJE1                  DELIMITED BY SPACE
               ", "                        DELIMITED BY SIZE
               ADR-LINJE2                  DELIMITED BY SIZE
               INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD

      * Write contact info line
           MOVE SPACES TO OUTPUT-TEXT
           STRING
               "Tlf: "                         DELIMITED BY SIZE
               TELEFON OF KONTAKTINFO
                        OF KUNDE-REKORD        DELIMITED BY SIZE
               " | Email: "                    DELIMITED BY SIZE
               EMAIL   OF KONTAKTINFO
                        OF KUNDE-REKORD        DELIMITED BY SIZE
               INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD
           EXIT.

      *> cobol-lint CL002 match-konti
       MATCH-KONTI.
           PERFORM VARYING IX-KONTI FROM 1 BY 1 UNTIL IX-KONTI
               >= KONTO-COUNT
                   IF KUNDE-ID OF KONTO-ARRAY(IX-KONTI) = KUNDE-ID
               OF KUNDE-REKORD
    
                   MOVE SPACES TO OUTPUT-TEXT
    
                   STRING "     KONTO-ID: " KONTO-ID OF 
                   KONTO-ARRAY(IX-KONTI) DELIMITED BY SIZE
                   " | TYPE: " KONTO-TYPE OF 
                    KONTO-ARRAY(IX-KONTI) DELIMITED BY SIZE
                    " | BALANCE: " BALANCE OF
                    KONTO-ARRAY(IX-KONTI) DELIMITED BY SIZE
                    " " VALUTA-KD OF
                    KONTO-ARRAY(IX-KONTI) DELIMITED BY SIZE
                   INTO OUTPUT-TEXT
                   END-STRING
               WRITE OUT-REKORD
           END-IF 
           END-PERFORM

           DISPLAY OUT-REKORD
               

           EXIT.
