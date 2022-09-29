cls
@echo off
echo.
echo.
set hdd=C

goto CDRIVE

:CDRIVE
echo y | DEL %hdd%:\DOCUME~1\%username%\LOCALS~1\Temp\*.* /S /Q

echo y | RD %hdd%:\DOCUME~1\%username%\LOCALS~1\Temp /S /Q

echo y | MD %hdd%:\DOCUME~1\%username%\LOCALS~1\Temp

echo y | DEL %hdd%:\DOCUME~1\%username%\LOCALS~1\tempor~1\Content.IE5\*.* /S /Q

echo y | RD %hdd%:\DOCUME~1\%username%\LOCALS~1\tempor~1\Content.IE5 /S /Q

echo y | DEL %hdd%:\DOCUME~1\%username%\LOCALS~1\tempor~1\*.* /S /Q

echo y | RD %hdd%:\DOCUME~1\%username%\LOCALS~1\tempor~1 /S /Q
cls
echo.
echo.
@echo Done.

cls
@echo off
echo.
echo.
set hdd=D

goto CDRIVE

:CDRIVE
echo y | DEL %hdd%:\DOCUME~1\%username%\LOCALS~1\Temp\*.* /S /Q

echo y | RD %hdd%:\DOCUME~1\%username%\LOCALS~1\Temp /S /Q

echo y | MD %hdd%:\DOCUME~1\%username%\LOCALS~1\Temp

echo y | DEL %hdd%:\DOCUME~1\%username%\LOCALS~1\tempor~1\Content.IE5\*.* /S /Q

echo y | RD %hdd%:\DOCUME~1\%username%\LOCALS~1\tempor~1\Content.IE5 /S /Q

echo y | DEL %hdd%:\DOCUME~1\%username%\LOCALS~1\tempor~1\*.* /S /Q

echo y | RD %hdd%:\DOCUME~1\%username%\LOCALS~1\tempor~1 /S /Q
cls
echo.
echo.
@echo Done.

Exit