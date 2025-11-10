      *.\cobbuild.bat -x opg3.cob -o opg3.exe -lcob
      *.\opg3.exe
       IDENTIFICATION DIVISION.
       PROGRAM-ID. OPG3.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  KUNDE-ID    PIC X(10).
       01  FORNAVN    PIC X(20).
       01  EFTERNAVN    PIC X(20).
       01  KONTONUMMER    PIC X(20).
       01  BALANCE    PIC 9(7)V99 VALUE ZERO.
       01  VALUTAKODE    PIC X(3).
       01  NAVN    PIC X(40).


      *Current index for FULL-NAME
       01  IX    PIC 9(3) VALUE 1.
      *Current index for OUTPUT-VAR
       01  IX2    PIC 9(3) VALUE 1.

      *Temp variables for character-control
       01  CURRENT-CHAR PIC X(1).
       01  PREVIOUS-CHAR PIC X(1).

      *Output var
       01  FULDE-NAVN PIC X(20).


       PROCEDURE DIVISION.
           MOVE 12345123 TO KUNDE-ID
           MOVE "Robert" TO FORNAVN
           MOVE "Pallesen" TO EFTERNAVN
           MOVE "DK125512421321" TO KONTONUMMER
           MOVE 2500.75 TO BALANCE
           MOVE "DKK" TO VALUTAKODE

           STRING FORNAVN DELIMITED BY SIZE " "
           DELIMITED BY SIZE EFTERNAVN
           DELIMITED BY SIZE
           INTO NAVN

      *Want to perform if in range of FULL-NAME
           PERFORM VARYING IX FROM 1 BY 1 UNTIL IX > LENGTH OF NAVN

      *Move current index of FULL-NAME to CURRENT-CHAR
               MOVE NAVN(IX:1) TO CURRENT-CHAR

      *Checks if CURRENT-CHAR or PREVIOUS-CHAR is NOT space
           IF CURRENT-CHAR NOT = SPACE OR PREVIOUS-CHAR NOT = SPACE

      *Move CURRENT-CHAR to OUTPUT-VAR
               MOVE CURRENT-CHAR TO FULDE-NAVN(IX2:1)
      *Increment IX2 with 1
               ADD 1 TO IX2

           END-IF

           MOVE CURRENT-CHAR TO PREVIOUS-CHAR

           END-PERFORM

       DISPLAY "----------------------------------------"
       DISPLAY "Kunde ID : " KUNDE-ID
       DISPLAY "Navn: " FULDE-NAVN
       DISPLAY "Kontonummer : " KONTONUMMER
       DISPLAY "Balance : " BALANCE " " VALUTAKODE
       DISPLAY "----------------------------------------"
       STOP RUN.
