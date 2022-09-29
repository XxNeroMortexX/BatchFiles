 @echo off
Set hTime=%TIME:~0,2%
Set mTime=%TIME:~3,2%
Set sTime=%TIME:~6,2%
Set /a mTime=%mTime%+1

Set sTime=%hTime%:%mTime%:%sTime%
cls


:Load_Program
at %sTime% /interactive "%CD%\AscII.exe"
goto DONE

Pause
echo. Please Wait 1 Minute and your Application will load.
:DONE