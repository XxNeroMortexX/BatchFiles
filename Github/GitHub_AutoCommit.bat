:~[ GitHub Auto Pull/Push Batch File
:~[ Written by NeroMorte
:~[ Verion: 1.0 Build:08012022
:~[ Problems/Suggestions Please Contact Me on Discord: NeroMorte#8786

cls

@Echo OFF
setlocal EnableDelayedExpansion


:~
:~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
:~             DO NOT EDIT ABOVE THIS LINE!!!             :
:~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
:~
:~
:~-~-~-~Below are the Options you can Set/Edit.~-~-~-~
:~

::~
::~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
::~           Script Settings BELOW THIS LINE!!!           :
::~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
::~

:~[ This will AutomactiCALLy [Pull, Push] Each GitHub with ( AutoCommit Time/Date )
:~[ Based on settings given below.

:~[ This will Spew OutPut to CMD window] (Options: 1=TRUE | 2=FALSE)
SET Debug=1
SET Files_Debug=1

:~[ Delay Rechecking ALL GitHub ] (Default: 30)
SET Recheck_Delay=10

:~[ Total Amount of Account INFO added Below. (Will Loop 1-Total_Account)
SET Total_Account=1


::~
::~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
::~           GitHub Accounts BELOW THIS LINE!!!           :
::~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
::~

:~[ Your GitHub Account Display Name]
SET GitHub_Account_1_Name=Sample_Name

:~[ Your GitHub Clone URL]
SET GitHub_Account_1_CloneLink=https://github.com/UserName/Repository_Name.git

:~[ Your GitHub Directory for you GitHub Clone]
SET GitHub_Account_1_Directory=E:\Repository_Name.git

:~[ Delay between Rechecking Each GitHub ] (Default: 0)
SET GitHub_Account_1_Display_OutPut=1

:~
:~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
:~             DO NOT EDIT BELOW THIS LINE!!!             :
:~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
:~

::~[ Compare-Operators
::~[  NOT - perform the command if the condition is false. 
::~[  ==  - perform the command if the two strings are equal. 
::~[  /I  - Do a case Insensitive string comparison.
::~[  EQU - equal to ==
::~[  NEQ - not equal to !=
::~[  LSS - less than <
::~[  LEQ - less than or equal to  <=
::~[  GTR - greater than >
::~[  GEQ - greater than or equal to >=

::~[ Taskkill-Command
::~[  /t - Terminate all process including sub-ones 
::~[  /f - with force.
::~[  /im - with image name.

::Sub
:Mainloop
	
	:: Line Feed
	(SET LF=^

	)
	
	:: Carriage Return
	(SET CR=^&@Echo.     )
	
	:: COLOR ([Background|Foreground])
	::0	=	Black	 	8	=	Gray
	::1	=	Blue	 	9	=	Light Blue
	::2	=	Green	 	A	=	Light Green
	::3	=	Aqua	 	B	=	Light Aqua
	::4	=	Red	 		C	=	Light Red
	::5	=	Purple	 	D	=	Light Purple
	::6	=	Yellow	 	E	=	Light Yellow
	::7	=	White	 	F	=	Bright White

	SET ColorAlpha[10]=A
	SET ColorAlpha[11]=B
	SET ColorAlpha[12]=C
	SET ColorAlpha[13]=D
	SET ColorAlpha[14]=E
	SET ColorAlpha[15]=F
	SET Loopnumber=1
	SET Nextnumber=2
	SET Git_ErrorLevel=
	SET AutoCommit=None
	
	:: Random 0-16 To Randomize Display Color.
	SET /a DisplayColor=%random% %%16
	IF %DisplayColor% GEQ 10 SET DisplayColor=!ColorAlpha[%DisplayColor%]!
	COLOR 0%DisplayColor%
	
	:GitHub_Accounts
		
		TITLE Checking Github Account: [!GitHub_Account_%Loopnumber%_Name!] Loop: [%Loopnumber%] Total Accounts: [%Total_Account%]
		
		IF %Debug% EQU 1 (
			@Echo.
			@Echo. ---------------------[!GitHub_Account_%Loopnumber%_Name!]----------------------
			@Echo.
		)
		
			CALL :GitHub_Repository !GitHub_Account_%Loopnumber%_Directory! !GitHub_Account_%Loopnumber%_Name! !GitHub_Account_%Loopnumber%_CloneLink!
			IF %Git_ErrorLevel% EQU False ( SET ErrorMessage=[No File Changes!] )
			IF %Git_ErrorLevel% EQU True ( SET ErrorMessage=[Files with Changes!] )
			
			IF "%AutoCommit%" EQU "None" (
				IF %Debug% EQU 1 Echo Return: [%ReturnMessage%] & Echo Error: %ErrorMessage% & Echo My Param: [%Param0%]-[%Param1%]-[%Param2%]
			) ELSE (
				IF %Debug% EQU 1 Echo Return: [%ReturnMessage%] & Echo Error: %ErrorMessage% & Echo !AutoCommit:_= ! & Echo My Param: [%Param0%]-[%Param1%]-[%Param2%]
			)
			
		IF %Debug% EQU 1 (
			@Echo.
			@Echo. ---------------------------------------------------
			@Echo.
		)
		
		:: Wait !GitHub_Account_%Loopnumber%_Display_OutPut! seconds until going to the start of the loop.
		IF !GitHub_Account_%Loopnumber%_Display_OutPut! NEQ 0 (
			CALL :DisplayTimer !GitHub_Account_%Loopnumber%_Display_OutPut! "to check next [!GitHub_Account_%Nextnumber%_Name!] ..."
			@Echo.
		)
		
		:: Exit Loop & Restart from the top.
		IF [%Loopnumber%] EQU [%Total_Account%] ( GOTO :Account_loop )
		SET /a Loopnumber=%Loopnumber%+1

		IF %Nextnumber% LSS %Total_Account% (
			SET /a Nextnumber=%Nextnumber%+1
		) ELSE (
			SET Nextnumber=1
		)
		
	GOTO :GitHub_Accounts
	
	:Account_loop
	:: Wait %Recheck_Delay% seconds until going to the start of the loop.
	@Echo.
	CALL :DisplayTimer %Recheck_Delay% "to restart ..."
	@Echo.
	
	:: Clear CMD Screen.
	cls
	
:: Restart from the top.
GOTO :Mainloop
::Return

::Sub
:GitHub_Repository
	SET Param0=%1
	SET Param1=%2
	SET Param2=%3
	
	:: Create Directory IF Missing
	IF NOT EXIST "%Param0%" MKDIR %Param0%
	
	:: Navigate to the directory you wish to push to GitHub
	CD /D %Param0%
	
	:: Clone GitHub Repository
	IF NOT EXIST "%Param0%\.git" (
		git clone %Param2% .
	)

	:: Initialize GitHub
	git init --quiet
	
	:: Pull any external changes (maybe you deleted a file from your repo?)
	git pull --quiet
	
	:: Add all files in the directory
	git add --all
	
	:: SET errorlevel based on IF Changes was made. git diff-index --cached --quiet HEAD
	:: ' ' = unmodified
	:: M = modified
	:: T = file type changed (regular file, symbolic link or submodule)
	:: A = added
	:: D = deleted
	:: R = renamed
	:: C = copied (if config option status.renames is set to "copies")
	:: U = updated but unmerged

	IF %Files_Debug% EQU 1 (
		
		git status --porcelain | FINDSTR . > NUL && SET "Git_ErrorLevel=True" || SET "Git_ErrorLevel=False"
		Echo Account [!GitHub_Account_%Loopnumber%_Name!] Changes IN Status: [!Git_ErrorLevel!]
		
		CALL :String_Length "Account [!GitHub_Account_%Loopnumber%_Name!] Status:" "AccountStatus" "False"
		CALL :Write "-" !AccountStatus!
		
		SET /A "INDEX=0"
		FOR /F "tokens=*" %%a IN ('git status --porcelain ^| FINDSTR .') DO (
			SET /A "INDEX+=1"
			IF !INDEX! NEQ 0 ( CALL SET "_Status[!INDEX!]=%%a" )
		)
		FOR /L %%n IN (1,1,!INDEX!) DO (
			SET _Status[%%n]=!_Status[%%n]:M  =[Modified]   !
			SET _Status[%%n]=!_Status[%%n]:T  =[File Type Changed]   !
			SET _Status[%%n]=!_Status[%%n]:A  =[Added]   !
			SET _Status[%%n]=!_Status[%%n]:D  =[Deleted]   !
			SET _Status[%%n]=!_Status[%%n]:R  =[Renamed]   !
			SET _Status[%%n]=!_Status[%%n]:C  =[Copied]   !
			SET _Status[%%n]=!_Status[%%n]:U  =[Updated]   !
			Echo File: [%%n] !_Status[%%n]!
		)
		
		SET lastline=0
		FOR /F "delims==" %%a IN ('git status --porcelain ^| FINDSTR .') DO SET lastline=%%a
		IF !lastline! EQU 0 ( Echo No Files have Changed ... )
		
		IF !INDEX! NEQ 0 ( Echo Files Found: [!INDEX!] )
				
		CALL :String_Length "!lastline:"=!" "LLAccountStatus" "False"
		CALL :Write "-" !LLAccountStatus!
		
		@Echo.
		
	) ELSE (
		git status --porcelain | FINDSTR . > NUL && SET "Git_ErrorLevel=True" || SET "Git_ErrorLevel=False"
		IF %Debug% EQU 1 Echo Account [!GitHub_Account_%Loopnumber%_Name!] Changes IN Status: [!Git_ErrorLevel!]
	)

	IF %Git_ErrorLevel% EQU True ( 
		
		:: AutoCommit: Wed [ 08/10/2022 Time: 19:04:49 ]
		SET AutoCommit=AutoCommit:_%date:~0,3%_[_%date:~4,2%/%date:~7,2%/%date:~-4%_Time:_%time:~0,2%:%time:~3,2%:%time:~6,2%_]
		git commit -m "!AutoCommit:_= !"

		:: Push all changes to GitHub 
		git push --quiet
		
		:: Alert user to script completion and relaunch.
		SET ReturnMessage=New Uploads Completed: %Param1:_= %
		
		@Echo.
		
	) ELSE IF %Git_ErrorLevel% EQU False (
		
		SET AutoCommit=None
		
		:: Alert user to script completion and relaunch.
		SET ReturnMessage=Nothing to Upload
	
	)
	
EXIT /B
::Return

::Sub
:RemoveWhiteSpace
	
	SET rWhiteSpace=%~1
	
	:: Remove WhiteSpace front of File
	FOR /f "tokens=* delims= " %%a in ("%rWhiteSpace%") do SET rWhiteSpace=%%a
	
EXIT /B
::Return

::Sub
:DisplayTimer

	SET SETTimer=%1
	SET SETTimerMsg=%~2
	
	FOR /F %%r IN ('COPY /Z "%~f0" NUL') DO (
		:: FOR /L %%parameter IN (start,step,end) DO command 
		FOR /L %%n IN (%SETTimer%, -1, 0) DO (
			< NUL SET /P "DisplayTimer=Waiting [%%n] Seconds %SETTimerMsg% %%r"
			TIMEOUT /t 1 /nobreak > NUL
		)
		(SET DisplayTimer=%%r)
	)
	
EXIT /B
::Return

::Sub
:Split_Str_By_Num
	
	SET "String=%~1"
	SET "Split_Str=%3"

	REM Split String by N characters
	SET "N=%2"

	:Split_Str_LOOP
	
	SET "%Split_Str%=!%Split_Str%!!String:~0,%N%! "
	SET "String=!String:~%N%!"
	IF DEFINED String GOTO Split_Str_LOOP
	
	IF %Debug% EQU 1 Echo Return: [!%Split_Str%:~0,-1%!]

EXIT /B
::Return

::Sub
:String_Length

	SET StringData=%~1
	SET StringVar=%~2
	SET StringDisplay=%~3
	SET len=0
	
	:: %string:~start,end%
	:: !%1:~%len%!
	:strLen_Loop
		IF %StringDisplay% EQU True Echo String: [!StringData:~%len%!] Length: [%len%]
		IF NOT "!StringData:~%len%!"=="" SET /A len+=1 & GOTO :strLen_Loop
	SET /A %StringVar%=%len%

EXIT /B
::Return

::Sub
:Write
	
	SET "Write_String=%~1"
	SET Write_Qty=%2
	SET len=0

	FOR /l %%i IN (2,1,%Write_Qty%) DO CALL SET "Write_String=%%Write_String%%%Write_String%"
	Echo %Write_String%

EXIT /B
::Return

:: END OF File	
:EOF