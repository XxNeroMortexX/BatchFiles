@echo off
setlocal
call :extract "Hello there this is a block: [C]Inside of Block[/C] Did you like it?"
echo Front  = "%Front%"
echo Inside = "%Inside%"
echo Back   = "%Back%"
pause
exit /b

:extract
set "Back=%~1"
set "Front=%Back:[C]="&:%
set "Back=%Back:*[C]=%"
set "Inside=%Back:[/C]="&:%
set "Back=%Back:*[/C]=%"
exit /b