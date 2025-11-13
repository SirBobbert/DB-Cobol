@echo off
REM Wrapper til GnuCOBOL på Windows
REM Sætter include- og lib-stier automatisk

set COBINC=C:\Users\Rober\AppData\Local\GnuCOBOL\include
set COBLIB=C:\Users\Rober\AppData\Local\GnuCOBOL\lib

REM Tilføj bin-mappen til PATH midlertidigt
set PATH=C:\Users\Rober\AppData\Local\GnuCOBOL\bin;%PATH%

REM Kald cobc med de rigtige flags
cobc -I"%COBINC%" -L"%COBLIB%" -x %*.cob -o %*.exe -lcob

%*

