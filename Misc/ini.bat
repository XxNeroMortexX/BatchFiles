@ECHO OFF
setlocal enabledelayedexpansion
cls

:: Echo Directory = %~dp0
:: Echo Object Name With Quotations=%0
:: Echo Object Name Without Quotes=%~0
:: Echo Bat File Drive = %~d0
:: Echo Full File Name = %~n0%~x0
:: Echo File Name Without Extension = %~n0
:: Echo File Extension = %~x0


:: Sub Record System Environment Variables
:Record_SYS_Variables

	set "oldfile=oldfile.txt"
	set "newfile=newfile.txt"
	
	IF EXIST "!oldfile!" del !oldfile! >nul 2>nul
	IF EXIST "!newfile!" del !newfile! >nul 2>nul
	FOR /f %%a IN ('SET') DO ECHO %%a>>!oldfile!

EXIT /B
::Return

	CALL :ReadINI "Example.ini" "SectionName4"

:: Sub Batch File Set Variables
:Report_New_Variables

	ECHO -------[%~nx0 Local Variables]-------
	@ECHO.
	
	FOR /f %%a IN ('SET') DO ECHO %%a>>%newfile%
		FOR /f %%a IN (%newfile%) DO (
			find "%%a" %oldfile% >NUL 2>NUL
			IF !errorlevel! NEQ 0 (
				SET "string=%%a"
				ECHO !string!
			)
		)
		
	IF EXIST "!oldfile!" del !oldfile! >nul 2>nul
	IF EXIST "!newfile!" del !newfile! >nul 2>nul

EXIT /B
::Return

::SUB
:ReadINI (INIFile,  INISection, eReport)
	:: setlocal & endlocal
	SET INIFile="%~dp0%~1"
	SET "INISection=%~2"
	IF NOT DEFINED INISection SET "INISection=ALL"
	SET "eReport=%~3"
	SET "FLAG="
	
	IF /I "!eReport!" EQU True (
		ECHO INIFile: [%INIFile%] Section: [%INISection%]
		@Echo.
	)
	
	FOR /f "tokens=1,* eol=| delims==" %%c IN ('find /v "" %INIFile% ^| find /v "---"') DO ( 
		SET "INILine=%%c"
		IF "!INILine:~0,1!" NEQ "-" (
			SET /A "INICount=!INICount!+1"
		)
	)
	
	FOR /f "usebackq tokens=1,* eol=| delims==" %%a IN (%INIFile%) DO (
		SET "INILine=%%a"
		SET "KEY=%%a"
		SET "VALUE=%%b"

		IF "!VALUE!"=="" (
			
			REM NO = so must be [SECTION]
			IF /I "!INISection!" NEQ "ALL" (			
				IF /I "!KEY!" EQU "[%INISection%]" (
					IF /I "!eReport!" EQU True ( Echo Found Correct Section [%INISection%] )
					SET "FLAG=Y"
				) ELSE IF /I "!KEY!" NEQ "[%INISection%]" IF /I "!KEY:~0,1!" EQU "[" (
					:: RESET Function Variables
					IF /I "!eReport!" EQU True ( Echo !KEY! ^|-[Skipping Line] )
					SET "KEY="
					SET "VALUE="
					SET "FLAG="
				)
			) ELSE (
				SET "FLAG=Y"
			)
		
		)
		
		IF DEFINED FLAG IF "!VALUE!" NEQ "" (
			IF /I "!eReport!" EQU True ( Echo Setting: [!KEY:#=`#!=!VALUE!] )
			SET "!KEY!=!VALUE!"
		
		)
		
		REM ECHO -[IS KEY SET]-
		IF NOT "x!KEY:[=!" NEQ "x!KEY!" (
			SET | FINDSTR /IC:"!KEY!=" > NUL && (
				IF DEFINED FLAG (
					IF /I "!eReport!" EQU True ( Echo !KEY!=!VALUE! ^|-[Skipping Line] )
				) ELSE (
					IF /I "!eReport!" EQU True ( ECHO !KEY!=!VALUE! ^|-[Skipping Line] )
				)
			) || (
				IF DEFINED FLAG (
					IF /I "!eReport!" EQU True ( Echo !KEY! ^|-[Skipping Line] )
				) ELSE (
					IF /I "!eReport!" EQU True ( ECHO !KEY! ^|-[Skipping Line] )
				)
			)
		)
		
		IF "!INILine:~0,1!" NEQ "-" (
			SET /A "LoopCount=!LoopCount!+1" 
		)
		
	)
	
	:: RESET Function Variables
	SET "KEY="
	SET "VALUE="
		
EXIT /B
::Return

pause

:: --------------------
:: INi.bat
:: INi.bat /? FOR usage
:: --------------------

@ECHO off
SETlocal enabledelayedexpansion

goto begIN

:usage
ECHO Usage: %~nx0 /i item [/v value] [/s section] INIFile
ECHO;
ECHO Take the followINg INi file FOR example:
ECHO;
ECHO    [Config]
ECHO    password=1234
ECHO    usertries=0
ECHO    allowtermINate=0
ECHO;
ECHO To read the "password" value:
ECHO    %~nx0 /s Config /i password INIFile
ECHO;
ECHO To change the "usertries" value to 5:
ECHO    %~nx0 /s Config /i usertries /v 5 INIFile
ECHO;
ECHO IN the above examples, "/s Config" is optional, but will allow the selection of
ECHO a specIFic item where the INi file contaINs similar items IN multiple sections.
goto :EOF

:begIN
IF "%~1"=="" goto usage
FOR %%I IN (item value section found) DO SET %%I=
FOR %%I IN (%*) DO (
    IF defINed next (
        IF !next!==/i SET item=%%I
        IF !next!==/v SET value=%%I
        IF !next!==/s SET section=%%I
        SET next=
    ) else (
        FOR %%x IN (/i /v /s) DO IF "%%~I"=="%%x" SET "next=%%~I"
        IF not defINed next (
            SET "arg=%%~I"
            IF "!arg:~0,1!"=="/" (
                1>&2 ECHO Error: Unrecognized option "%%~I"
                1>&2 ECHO;
                1>&2 call :usage
                exit /b 1
            ) else SET "INIFile=%%~I"
        )
    )
)
FOR %%I IN (item INIFile) DO IF not defINed %%I goto usage
IF not exist "%INIFile%" (
    1>&2 ECHO Error: %INIFile% not found.
    exit /b 1
)

IF not defINed section (
    IF not defINed value (
        FOR /f "usebackq tokens=2 delims==" %%I IN (`fINdstr /i "^%item%\=" "%INIFile%"`) DO (
            ECHO(%%I
        )
    ) else (
        FOR /f "usebackq delims=" %%I IN (`fINdstr /n "^" "%INIFile%"`) DO (
            SET "lINe=%%I" && SET "lINe=!lINe:*:=!"
            ECHO(!lINe! | fINdstr /i "^%item%\=" >NUL && (
                1>>"%INIFile%.1" ECHO(%item%=%value%
                ECHO(%value%
            ) || 1>>"%INIFile%.1" ECHO(!lINe!
        )
    )
) else (
    FOR /f "usebackq delims=" %%I IN (`fINdstr /n "^" "%INIFile%"`) DO (
        SET "lINe=%%I" && SET "lINe=!lINe:*:=!"
        IF defINed found (
            IF defINed value (
                ECHO(!lINe! | fINdstr /i "^%item%\=" >NUL && (
                    1>>"%INIFile%.1" ECHO(%item%=%value%
                    ECHO(%value%
                    SET found=
                ) || 1>>"%INIFile%.1" ECHO(!lINe!
            ) else ECHO(!lINe! | fINdstr /i "^%item%\=" >NUL && (
                FOR /f "tokens=2 delims==" %%x IN ("!lINe!") DO (
                    ECHO(%%x
                    exit /b 0
                )
            )
        ) else (
            IF defINed value (1>>"%INIFile%.1" ECHO(!lINe!)
            ECHO(!lINe! | fINd /i "[%section%]" >NUL && SET found=1
        )
    )
)

IF exist "%INIFile%.1" move /y "%INIFile%.1" "%INIFile%">NUL