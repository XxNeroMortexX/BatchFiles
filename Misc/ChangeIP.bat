:Change IP Batch File
:Written by NeroMorte

COLOR 0C

@ECHO off
:Below are the choices.

set PcK1=Yes
set PcK2=No

:Gobal Settings
SET TEMP1=IP.txt
SET TEMP2=MAC.txt

:Choices
cls
ECHO.Change IP Batch File
ECHO.Batch File Coded by NeroMorte
ECHO.


ECHO.
ECHO.
ECHO.Please select Yes / No from the following:
ECHO.
ECHO. 1. %PcK1%
ECHO. 2. %PcK2%

ECHO.
set /p PcKs=Pick Number or Type Yes To Continue or No to Exit?


ECHO.
ECHO.

REM ##########################################################
REM NOT : perform the command if the condition is false. 
REM ==  : perform the command if the two strings are equal. 
REM /I  : Do a case Insensitive string comparison.
REM EQU : equal
REM NEQ : not equal
REM LSS : less than <
REM LEQ : less than or equal <=
REM GTR : greater than >
REM GEQ : greater than or equal >=
REM ##########################################################

IF NOT '%PcKs%' EQU '' set TheChoice=%PcKs%

IF %PcKs% EQU Yes set TheChoice=%PcKs%
IF %PcKs% EQU No set TheChoice=%PcKs%
IF %PcKs% EQU 1 set TheChoice=%PcKs%
IF %PcKs% EQU 2 set TheChoice=%PcKs%

IF %TheChoice% EQU Yes GOTO One
IF %TheChoice% EQU No GOTO Two
IF %TheChoice% EQU 1 GOTO One
IF %TheChoice% EQU 2 GOTO Two

ECHO "%PcKs%" is not valid Entry please try again.
ECHO.
Pause
GOTO Choices


:One
ECHO YOU HAVE PICKED NUMBER ONE
ECHO.
@ECHO off 

:: Get the current IP address
@IPCONFIG /ALL | FIND /I "IP Address" > %TEMP1%
@FOR /F "tokens=1-6 delims=,:. " %%i in (%TEMP1%) do (

@SET IP=%%k %%l %%m %%n

)

:: Get MAC Address
@IPCONFIG /ALL | FIND /I "Physical Address" > %TEMP2%
@FOR /F "tokens=1-6 delims=,:. " %%o in (%TEMP2%) do (

@SET MAC=%%q

)

@cls
GOTO ChangeIP
:END

:ChangeIP
ECHO.
ECHO. Username: %username% 
ECHO. IP Address: %IP%
ECHO. MAC Address: %MAC%
ECHO. PC Name: %Computername%
ECHO. Time/Date Requested IP Change: %TIME%/%Date%
ECHO.
ECHO.
ECHO. ... Changing IP Please Wait ...
ECHO.
Pause

:END

:Error
ECHO Please Try again!
GOTO Choices
:END

:Two
ECHO YOU HAVE PICKED NUMBER TWO PRESS ANY KEY TO EXIT.
Pause
@cls
EXIT
:END

:Error
ECHO Please Try again!
GOTO Choices
:END

:ExitBatch
Echo Exiting Thanks for Using NeroMorte IP Changer!
@pause
::EXIT
:END
