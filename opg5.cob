      *.\cobbuild.bat -x opg5.cob -o opg5.exe -lcob
      *.\opg5.exe
       IDENTIFICATION DIVISION.
       PROGRAM-ID. OPG5.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 KUNDEOPL-01.
           COPY "KUNDER.cpy".
       01 KUNDEOPL-02.
           COPY "KUNDER.cpy".

       PROCEDURE DIVISION.
           MOVE "1" TO KUNDE-ID OF KUNDEOPL-01
           MOVE "2" TO KUNDE-ID OF KUNDEOPL-02

       DISPLAY KUNDE-ID OF KUNDEOPL-01.
       DISPLAY KUNDE-ID OF KUNDEOPL-02.

       STOP RUN.
