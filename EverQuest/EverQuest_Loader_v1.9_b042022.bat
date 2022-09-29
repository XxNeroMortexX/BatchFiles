:: BatchGotAdmin
::-------------------------------------
:: Check for permissions
IF [%PROCESSOR_ARCHITECTURE%] EQU [amd64] (
	>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
	>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

:: If error flag set, we do not have admin.
IF [%errorlevel%] NEQ [0] (
    ECHO Requesting administrative privileges...
    GOTO :UACPrompt
) ELSE ( 
	GOTO :gotAdmin
)

::Create VBS File to Elevate Batchfile to Runas Admin and Delete VBS
:UACPrompt
    ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    ECHO UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    DEL "%temp%\getadmin.vbs"
    EXIT /B

::Change Directory to Batchfile Current File Path Location.
:gotAdmin
    PUSHD "%CD%"
    CD /D "%~dp0"
::--------------------------------------

:~[ EverQuest Auto Load Batch File
:~[ Written by NeroMorte
:~[ Verion: 1.9 Build:042022
:~[ Problems/Suggestions Please Contact Me on Discord: NeroMorte#8786
::Batchfile Features

::
:: Ability to Set Affinity on Each Client Via [PSEXEC.EXE], [Windows Start Command], [Powershell].
:: Ability to Set Process Priority via [Powershell]
:: Ability to Set [TimeOut] How long to wait to start next Bots.
:: Ability to Set [WINEQ2_TimeOut] How long to wait for WinEQ2 to load Before loading Bots.
:: Ability to Set [StartLoop] & [EndLoop] Pick what Account Numbers Batchfile will load Between Start & End Loop.
:: Ability to Load [AccountSelector] Shows a List of Accounts you can pick from for Batchfile to loads.
:: Ability to Set [SelectAccounts] This Option Lets you Pick How many Accounts Show on [AccountSelector] List.
:: Autoload MQ2 & EQBC, WinEQ2 Before Bots are loaded.
:: Ability to Use WinEQ2 Profiles or EQGame to Load Bots.
:: Ability to Load Each Bot from a Different Game Directory.
:: [AccountSelector] Options: Load Individual Bots, Set Affinity/Priority, Close All Open Client.
::

COLOR 0C
cls


@ECHO OFF
setlocal enabledelayedexpansion

:~
:~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
:~             DO NOT EDIT ABOVE THIS LINE!!!             :
:~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
:~
:~
:~-~-~-~Below are the Options you can Set/Edit.~-~-~-~
:~

:: [ 24 Cores: 0xFFFFFF ][ 23 Cores: 0x7FFFFF ][ 22 Cores: 0x3FFFFF ][ 21 Cores: 0x1FFFFF ][ 20 Cores: 0xFFFFF ][ 19 Cores: 0x7FFFF ]
:: [ 18 Cores: 0x3FFFF ][ 17 Cores: 0x1FFFF ][ 16 Cores: 0xFFFF ][ 15 Cores: 0x7FFF ][ 14 Cores: 0x3FFF ][ 13 Cores: 0x1FFF ]
:: [ 12 Cores: 0xFFF ][ 11 Cores: 0x7FF ][ 10 Cores: 0x3FF ][ 09 Cores: 0x1FF ][ 08 Cores: 0xFF ][ 07 Cores: 0x7F ]
:: [ 06 Cores: 0x3F ][ 05 Cores: 0x1F ][ 04 Cores: 0xF ][ 03 Cores: 0x7 ][ 02 Cores: 0x3 ][ 01 Cores: 0x1 ]
:: For other Affinity Combonation Use: https://bitsum.com/tools/cpu-affinity-calculator/
::psexec -d -a 7F cmd /c

:~[ Options are 1 = ON or 0 = OFF (To Set Affinity Via PSEXEC)
:~[ COPY [PSEXEC.EXE] TO [C:\Windows\System32\] P.S. Make sure to run psexec once first and accept terms.
set USE_PSEXEC=0

:~[ Set_Affinity= Options are 1 = ON or 0 = OFF OR 2 = Power-Shell Set Affinity (CPUCore Must be Set to Current Amount of Cores.)  **Requires Run As Admin**
:~[  Option 1 = Windows Start /Affinity Command.
:~[  Option 2 = Creamo's EQ Affinity Batchfile.
:~[  Set_Affinity= (Default: 2)
set Set_Affinity=2
set CPUCore=24

:~[ Set_Priority= Options are 1 = ON or 0 = OFF
:~[ Priority Options::~[ Idle, BelowNormal, Normal, AboveNormal, High, RealTime
:~[ Priority Options::~[ 64  , 16384      , 32    , 32768      , 128 , 256
:~[ IF Set_Priority=1  ::~[   Make sure [MQ2_Application=, EQBCS_Application=] are Set below so Code knows what Process to Modify.
set Set_Priority=0
set EQGamePriority=AboveNormal
set EQBCServerPriority=High
set MQ2Priority=High
set WinEQ2Priority=High

:~[ This Sets the affinity for all eqgame the same. (Default: 0xFFFFFF) 24 Cores
:~[ Batch will Skip Blank =
:~[ Must be set if using Set_Affinity=1 IF blank will use per client Set_*_Affinity Below.
set Set_ALL_Affinity=

:~[ This Sets the affinity Per eqgame Client loaded. (Can Add Unlimited Amount of Set Affinitys)
:~[ Batch will Skip Blank =

:~[ Group #1
set Set_1_Affinity=
set Set_2_Affinity=
set Set_3_Affinity=
set Set_4_Affinity=
set Set_5_Affinity=
set Set_6_Affinity=
:~[ Group #2
set Set_7_Affinity=
set Set_8_Affinity=
set Set_9_Affinity=
set Set_10_Affinity=
set Set_11_Affinity=
set Set_12_Affinity=
:~[ Group #3
set Set_13_Affinity=
set Set_14_Affinity=
set Set_15_Affinity=
set Set_16_Affinity=
set Set_17_Affinity=
set Set_18_Affinity=

:~[ This is the Delay until Next Window will Load. (Default: 8)
set TimeOut=1

:~[ This is the Delay until WinEQ2 Finished loading, Selected Profile will start to load(Default: 30)
set WINEQ2_TimeOut=30

:~[ First Account Number to start with.
set StartLoop=1

:~[ Last Account Number to end on.
set EndLoop=18

:~[ Options are 1 = ON or 0 = OFF (IF =1 Will Ignore [StartLoop,EndLoop] Settings)  (Default: 0)
:~[ This will Force Batchfile to Load Account Selector, not auto load all Accounts listed in [StartLoop,EndLoop] Settings.
:~[ This Option Auto loads once you have at least one EQGame open.
set AccountSelector=0
set SelectAccounts=18

:~[ Options are 1 = ON or 0 = OFF (IF Open will not Try to Open Another.) (Default: 1)
:~[ Path Do not include Filename.EXE in EQBCS_Path Location, Also no Ending \ on Path ex; C:\MQ2
:~[ EQBCS_Application= This is the EQBCS File to be loaded.
set EQBCS=0
set EQBCS_Path=E:\Games\Sony\Release_ROF2
set EQBCS_Application=EQBCServer.exe

:~[ Options are 1 = ON or 0 = OFF (IF Open will not Try to Open Another.) (Default: 1)
:~[ Path Do not include Filename.EXE in MQ2_Path Location, Also no Ending \ on Path ex; C:\MQ2
:~[ MQ2_Application= This is the MQ2 File to be loaded.
set MQ2=0
set MQ2_Path=E:\Games\Sony\Release_ROF2
set MQ2_Application=MacroQuest2.exe

:~[ Options are EQ or WinEQ2 (Default: EQ)
:~[ Path Do not include Filename.EXE just a PATH Location, Also no Ending \ on Path ex; C:\EQ_PEQ
:~[  Option EQ= Loads each client directly without WinEQ2
:~[  Option WinEQ2= Uses WinEQ2 Profiles to load each client.
set EQLoadType=EQ
set EQ_Game_Path=E:\Games\Sony\EverQuest_rof2Steam
set EQ_WINEQ2_Path=E:\Games\Sony\WinEQ2_PEQ


:~[ User Name used to Login (Can Add Unlimited Amount of Account Logins)
:~[ Set using Following Format.   Account_X_Login=AccountLogin:AccountDescription    e.x; PeQAccount:Group1-Enchanter
:~[ Batch will Skip Blank =

:~[ Group #1
set Account_1_Login=
set Account_2_Login=
set Account_3_Login=
set Account_4_Login=
set Account_5_Login=
set Account_6_Login=
:~[ Group #2
set Account_7_Login=
set Account_8_Login=
set Account_9_Login=
set Account_10_Login=
set Account_11_Login=
set Account_12_Login=
:~[ Group #3
set Account_13_Login=
set Account_14_Login=
set Account_15_Login=
set Account_16_Login=
set Account_17_Login=
set Account_18_Login=

:~[ WinEQ2 Profiles Names (Can Add Unlimited Amount of Profiles)
:~[ Account_*_Profile= are inside your WinEQ2 "WinEQ-EQ.ini", Under each [Profile*] Name=
:~[ Must fill out below if using EQLoadType=WinEQ2
:~[ Batch will Skip Blank =

:~[ Group #1
set Account_1_Profile=
set Account_2_Profile=
set Account_3_Profile=
set Account_4_Profile=
set Account_5_Profile=
set Account_6_Profile=
:~[ Group #2          
set Account_7_Profile=
set Account_8_Profile=
set Account_9_Profile=
set Account_10_Profile=
set Account_11_Profile=
set Account_12_Profile=
:~[ Group #3           
set Account_13_Profile=
set Account_14_Profile=
set Account_15_Profile=
set Account_16_Profile=
set Account_17_Profile=
set Account_18_Profile=

:~[ EverQuest Directories Locations (Will Load Bots in different Directories)
:~[ This allows each client to be opened in Different Directories.
:~[ Batch will Skip Blank =

:~[ Group #1
set Account_1_EQDirectory=
set Account_2_EQDirectory=
set Account_3_EQDirectory=
set Account_4_EQDirectory=
set Account_5_EQDirectory=
set Account_6_EQDirectory=
:~[ Group #2
set Account_7_EQDirectory=
set Account_8_EQDirectory=
set Account_9_EQDirectory=
set Account_10_EQDirectory=
set Account_11_EQDirectory=
set Account_12_EQDirectory=
:~[ Group #3                 
set Account_13_EQDirectory=
set Account_14_EQDirectory=
set Account_15_EQDirectory=
set Account_16_EQDirectory=
set Account_17_EQDirectory=
set Account_18_EQDirectory=

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
		
set StartLoopOrg=%StartLoop%

set Choices=YES
:~[ IF No EQGAME.EXE Loaded in Task-Manager Then Skip Account Selecter.
IF /I [%AccountSelector%] NEQ [1] (
	tasklist /v /fo List /fi "IMAGENAME eq eqgame.exe"		| FINDSTR /i "eqgame.exe" > NUL || (set Choices=NO)
)

		
:Loop
IF [%Choices%] EQU [NO] (
	:~[ Create [Account_*_Login]&[Account_*_Class] Argument Based on Delimiter [:]
	FOR /f "tokens=1,2 delims=:" %%a IN ("!Account_%StartLoop%_Login!") DO ( set Account_%StartLoop%_Login=%%a&set Account_%StartLoop%_class=%%b )
		
	TITLE ACCOUNT: [%StartLoop%] - [!Account_%StartLoop%_Login!] - [!Account_%StartLoop%_class!]
) ELSE (
	TITLE EQ Toon Launcher! Coded by NeroMorte...
	set EndLoop=%SelectAccounts%
)


:~[ This Adds Affinity to EQ Game Client
IF /I %Set_Affinity% NEQ 2 (

	IF /I %Set_Affinity% EQU 1 (
		IF /I [%Set_ALL_Affinity%] NEQ [] ( set USE_AFFINITY=/Affinity %Set_ALL_Affinity% )
		IF /I [%Set_1_Affinity%] NEQ [] ( set USE_AFFINITY=/Affinity !Set_%StartLoop%_Affinity! )
	)
	IF /I [%Set_ALL_Affinity%] NEQ [] (
		IF %USE_PSEXEC% EQU 1 ( set RUN_PSEXEC=psexec -d -a %Set_ALL_Affinity%  cmd /c )
	)
	IF /I [%Set_1_Affinity%] NEQ [] (
		IF %USE_PSEXEC% EQU 1 ( set RUN_PSEXEC=psexec -d -a !Set_%StartLoop%_Affinity! cmd /c )
	)
	
)

IF %EQLoadType% EQU EQ (
	
	:~[ IF ACCOUNT INFO Settings Blank Skip & goto Next.
	IF [!Account_%StartLoop%_Login!] EQU [] (

		:~[ Loop through Account Listed.
		IF [%StartLoop%] EQU [%EndLoop%] ( GOTO :END )
		SET /a StartLoop=%StartLoop%+1
		GOTO :Loop
		
	) ELSE (
	
		GOTO :ELSE
	
	)

) 

IF %EQLoadType% EQU WinEQ2 (
	
	IF [!Account_%StartLoop%_Profile!] EQU [] (
	
		:~[ Loop through Account Listed.
		IF [%StartLoop%] EQU [%EndLoop%] ( GOTO :END )
		SET /A StartLoop=%StartLoop%+1
		GOTO :Loop
		
	) ELSE (

		GOTO :ELSE
	
	)

)

ECHO You Must Set "set EQLoadType=" TO "EQ" OR "WinEQ2" NOT "%EQLoadType%"
timeout /t 120
Exit

	:ELSE

	IF [%Choices%] EQU [YES] (

		ECHO Batch EQ Toon Launcher
		ECHO Batch File Coded by NeroMorte

		ECHO Please select From %StartLoopOrg% - %EndLoop% from the following:
		                             
		ECHO [ Choices ]-[    Login Account    ]-[   Account Description   ]
	
		:ChoiceLoop
		IF [!Account_%StartLoop%_Login!] NEQ [] (
		
			:~[ Create [Account_*_Login]&[Account_*_Class] Argument Based on Delimiter [:]
			FOR /f "tokens=1,2 delims=:" %%a IN ("!Account_%StartLoop%_Login!") DO ( set Account_%StartLoop%_Login=%%a&set Account_%StartLoop%_class=%%b )
			
			:~[ Parse through Each Account Listed.
			ECHO [    %StartLoop%    ]-[      !Account_%StartLoop%_Login!      ]-[       [%StartLoop%] !Account_%StartLoop%_class!       ]
			
			SET /a StartLoop=%StartLoop%+1
			IF [%StartLoop%] EQU [%EndLoop%] ( GOTO :ChoiceEND )
			GOTO :ChoiceLoop
		)
		
		:ChoiceEND
		ECHO [    MOD   ]-[ Sets All Open Clients Affinity/Priority.
		ECHO [   Close  ]-[ Closes all instances of [eqgame.exe] running^^! ^(Requires: Run As Administrator^)
		ECHO [   Exit   ]-[ Closes and Exit the EQ Loader Script.
		
		:Selection
		@echo. 
		set /p Login=Pick Account Number^(s^) to Load?... Seperated by ^[Space or Comma^].
		@echo. 
		
		set Login=%Login:,= %
		
		:~[ Check Variable [%Login%] For Close.
		ECHO %Login% | FINDSTR /I "CLOSE"
		IF [%ErrorLevel%] EQU [0] (
			Taskkill /t /f /im eqgame.exe
			GOTO :Selection
		)
		
		:~[ Check Variable [%Login%] For Exit
		ECHO %Login% | FINDSTR /I "EXIT"
		IF [%ErrorLevel%] EQU [0] (
			timeout /t 120
			Exit
		)
		
		:~[ Check Variable [%Login%] For Exit
		ECHO %Login% | FINDSTR /I "MOD"
		IF [%ErrorLevel%] EQU [0] (
			GOTO :AffinitySet
		)
		set ErrorLevel=
		
		
		:~[ Start MQ2 First IF Enabled
		IF /I %MQ2% EQU 1 (
			@echo. 
			@echo. Load Type: 		[MQ2=ON]
			@echo. Path:			[!MQ2_Path!]
			@echo. 
			tasklist /v /fo List /fi "WINDOWTITLE eq MacroQuest" /fi "IMAGENAME eq %MQ2_Application%"		| FINDSTR /i "%MQ2_Application%" > NUL || (start "MacroQuest2" /d "%MQ2_Path%" "%MQ2_Path%\%MQ2_Application%")  && (timeout /t %TimeOut%)
		)
		

		:~[ Start EQBCS Second IF Enabled
		IF /I %EQBCS% EQU 1 (
			@echo. 
			@echo. Load Type: 		[EQBCS=ON]
			@echo. Path: 			[!EQBCS_Path!]
			@echo. 
			tasklist /v /fo List /fi "IMAGENAME eq EQBCS*"		| FINDSTR /i "EQBCS" > NUL || (start "EQBCServer" /d "%EQBCS_Path%" "%EQBCS_Path%\%EQBCS_Application%")  && (timeout /t %TimeOut%)
		)
		
		CLS
		
		for %%1 in (%Login%) do (
		
			IF [!Account_%%1_EQDirectory!] NEQ [] (
				set EQ_Game_Path=!Account_%%1_EQDirectory!
				ECHO !EQ_Game_Path! :: !Account_%%1_EQDirectory!
			)
		
			TITLE ACCOUNT: [%%1] - [!Account_%%1_Login!] - [!Account_%%1_class!]
			
			@echo. 
			@echo. EQ Load Type:    	[%EQLoadType%]
			@echo. EQ User Account:	[!Account_%%1_Login!]
			@echo. Path: 			[!EQ_Game_Path!]
			@echo. Affinity: 		[%USE_AFFINITY%%CPUCore%^^2]
			@echo. Description:		[!Account_%%1_class!]
			@echo. 
			
			%RUN_PSEXEC% start %USE_AFFINITY% "!Account_%%1_Login!" /d "!EQ_Game_Path!" "!EQ_Game_Path!\eqgame.exe" patchme /Login:!Account_%%1_Login! && (timeout /t %TimeOut%)
		)
		
		TITLE ALL Selected Accounts [%Login%] have been Loaded.
		IF /I [%Set_Affinity%] EQU [2] ( GOTO :AffinitySet )
		IF /I [%Set_Priority%] EQU [1] ( GOTO :PrioritySet )
		timeout /t 120
		Exit
		
	)
	
		:~[ Start MQ2 First IF Enabled
		IF /I %MQ2% EQU 1 (
			@echo. 
			@echo. Load Type: 		[MQ2=ON]
			@echo. EQ User Account:	[!Account_%StartLoop%_Login!]
			@echo. Path:			[!MQ2_Path!]
			@echo. 
			tasklist /v /fo List /fi "WINDOWTITLE eq MacroQuest" /fi "IMAGENAME eq %MQ2_Application%"		| FINDSTR /i "%MQ2_Application%" > NUL || (start "MacroQuest2" /d "%MQ2_Path%" "%MQ2_Path%\%MQ2_Application%")  && (timeout /t %TimeOut%)
		)

		:~[ Start EQBCS Second IF Enabled
		IF /I %EQBCS% EQU 1 (
			@echo. 
			@echo. Load Type: 		[EQBCS=ON]
			@echo. EQ User Account:	[!Account_%StartLoop%_Login!]
			@echo. Path: 			[!EQBCS_Path!]
			@echo. 
			tasklist /v /fo List /fi "IMAGENAME eq EQBCS*"		| FINDSTR /i "EQBCS" > NUL || (start "EQBCServer" /d "%EQBCS_Path%" "%EQBCS_Path%\%EQBCS_Application%")  && (timeout /t %TimeOut%)
		)
		
		IF [!Account_%StartLoop%_EQDirectory!] NEQ [] (
			set EQ_Game_Path=!Account_%StartLoop%_EQDirectory!
			ECHO !EQ_Game_Path! :: !Account_%StartLoop%_EQDirectory!
		)
		
		:~[ Start EQ Game IF Enabled
		IF /I %EQLoadType% EQU EQ (
			@echo. 
			@echo. EQ Load Type: 		[%EQLoadType%]
			@echo. EQ User Account:	[!Account_%StartLoop%_Login!]
			@echo. Path: 			[!EQ_Game_Path!]
			@echo. Affinity: 		[%USE_AFFINITY%%CPUCore%^^2]
			@echo. Description:		[!Account_%StartLoop%_class!]
			@echo. 
			tasklist /v /fo List /fi "WINDOWTITLE eq !Account_%StartLoop%_Login!" /fi "IMAGENAME eq eqgame.exe"		| FINDSTR /i "eqgame.exe" > NUL || (%RUN_PSEXEC% start %USE_AFFINITY% "!Account_%StartLoop%_Login!" /d "!EQ_Game_Path!" "!EQ_Game_Path!\eqgame.exe" patchme /Login:!Account_%StartLoop%_Login!)  && (timeout /t %TimeOut%)
		)		
		
		:~[ Start WINEQ2 & Game IF Enabled
		IF /I %EQLoadType% EQU WinEQ2 (
			@echo. 
			@echo. EQ Load Type: 		[%EQLoadType%]
			@echo. EQ User Account:	[!Account_%StartLoop%_Login!]
			@echo. Path: 			[!EQ_WINEQ2_Path!]
			@echo. Affinity: 		[%USE_AFFINITY%%CPUCore%^^2]
			@echo. Description:		[!Account_%StartLoop%_class!]
			@echo. 
			tasklist /v /fo List /fi "IMAGENAME eq WinEQ2.exe"		| FINDSTR /i "WinEQ2.exe" > NUL || (%RUN_PSEXEC% start %USE_AFFINITY% "!Account_%StartLoop%_Login!" /d "%EQ_WINEQ2_Path%\" "%EQ_WINEQ2_Path%\WinEQ2.exe")  && (timeout /t %WINEQ2_TimeOut%)
			tasklist /v /fo List /fi "WINDOWTITLE eq !Account_%StartLoop%_Login!" /fi "IMAGENAME eq WinEQ2.exe"		| FINDSTR /i "WinEQ2.exe" > NUL || (%RUN_PSEXEC% start %USE_AFFINITY% "!Account_%StartLoop%_Login!" /d "%EQ_WINEQ2_Path%\"  "%EQ_WINEQ2_Path%\WinEQ2.exe" /plugin:WinEQ2-EQ.dll "!Account_%StartLoop%_Profile!")  && (timeout /t %TimeOut%)
		)
		
																																				
		:~[ This Loop through Account Listed.
		IF [%StartLoop%] EQU [%EndLoop%] GOTO :END
		SET /a StartLoop=%StartLoop%+1
		goto :Loop


		:END
		TITLE ALL Accounts %StartLoopOrg% to %EndLoop% have been Loaded.
		timeout /t 120
		IF /I [%Set_Affinity%] EQU [2] ( GOTO :AffinitySet )
		IF /I [%Set_Priority%] EQU [1] ( GOTO :PrioritySet )
		
		timeout /t 120
		Exit
		
		:AffinitySet
		
		:: #change 255 to fit your purpose.  255 spreads across all 8 cores.  # to use = 2^N - 1 where N=num cores #

		set LoopCores=1
		set /a Cores=2*1


		:CoreLoop
			IF [%LoopCores%] EQU [%CPUCore%] GOTO :ExitCoreLoop
			set /a LoopCores=%LoopCores%+1
			set /a Cores=%Cores%*2
		goto :CoreLoop
		
		:ExitCoreLoop
		:~[ Must Minus 1 From Total 2^NumberCores (2 To the Power of NumberCores. ex; 8 Core = 2x2x2x2x2x2x2x2-1)
		set /a Cores=%Cores%-1
			
			::Check IF Session is ADMIN
			net session >nul 2>&1

			IF %errorlevel% == 0 (
				@echo.
				@echo.
				ECHO Setting Processor Affinitys.
				@echo.
				:: [EQGame] Processor Affinity
				powershell "$EQGameAffinity=GET-PROCESS EQGame -ErrorAction SilentlyContinue; if ($EQGameAffinity) { foreach ($i in $EQGameAffinity) {$i.ProcessorAffinity=%Cores%} Write-Host "I am Setting [EQGame] Processor Affinity to [%Cores%]" -BackgroundColor "Yellow" -ForegroundColor "DarkRed" }"
				powershell "Exit;"
				
				:: [EQBCServer] Processor Affinity
				powershell "$EQBCServerAffinity=GET-PROCESS %EQBCS_Application:~0,-4% -ErrorAction SilentlyContinue; if ($EQBCServerAffinity) { foreach ($i in $EQBCServerAffinity) {$i.ProcessorAffinity=%Cores%} Write-Host "I am Setting [%EQBCS_Application:~0,-4%] Processor Affinity to [%Cores%]" -BackgroundColor "Yellow" -ForegroundColor "DarkRed" }"
				powershell "Exit;"
				
				:: [MQ2] Processor Affinity
				powershell "$MQ2Affinity=GET-PROCESS %MQ2_Application:~0,-4% -ErrorAction SilentlyContinue; if ($MQ2Affinity) { foreach ($i in $MQ2Affinity) {$i.ProcessorAffinity=%Cores%} Write-Host "I am Setting [%MQ2_Application:~0,-4%] Processor Affinity to [%Cores%]" -BackgroundColor "Yellow" -ForegroundColor "DarkRed" }"
				powershell "Exit;"
				
				:: [WinEQ2] Processor Affinity
				powershell "$WinEQ2Affinity=GET-PROCESS WinEQ2 -ErrorAction SilentlyContinue; if ($WinEQ2Affinity) { foreach ($i in $WinEQ2Affinity) {$i.ProcessorAffinity=%Cores%} Write-Host "I am Setting [WinEQ2] Processor Affinity to [%Cores%]" -BackgroundColor "Yellow" -ForegroundColor "DarkRed" }"
				powershell "Exit;"
				
				:PrioritySet
				IF /I %Set_Priority% EQU 1 (
					
					@echo.
					@echo.
					ECHO Setting Processor Prioritys.
					@echo.
					:: [EQGame] Processor Priority
					powershell "$EQGamePriority=GET-PROCESS eqgame -ErrorAction SilentlyContinue; if ($EQGamePriority) { foreach ($i in $EQGamePriority) {$i.PriorityClass='%EQGamePriority%'} Write-Host "I am Setting [EQGame] Processor Priority to [%EQGamePriority%]" -BackgroundColor "Yellow" -ForegroundColor "DarkRed" }"
					powershell "Exit;"
					
					:: [EQBCServer] Processor Priority
					powershell "$EQBCServerPriority=GET-PROCESS %EQBCS_Application:~0,-4% -ErrorAction SilentlyContinue; if ($EQBCServerPriority) { foreach ($i in $EQBCServerPriority) {$i.PriorityClass='%EQBCServerPriority%'} Write-Host "I am Setting [%EQBCS_Application:~0,-4%] Processor Priority to [%EQBCServerPriority%]" -BackgroundColor "Yellow" -ForegroundColor "DarkRed" }"
					powershell "Exit;"
					
					:: [MQ2] Processor Priority
					powershell "$MQ2Priority=GET-PROCESS %MQ2_Application:~0,-4% -ErrorAction SilentlyContinue; if ($MQ2Priority) { foreach ($i in $MQ2Priority) {$i.PriorityClass='%MQ2Priority%'} Write-Host "I am Setting [%MQ2_Application:~0,-4%] Processor Priority to [%MQ2Priority%]" -BackgroundColor "Yellow" -ForegroundColor "DarkRed" }"
					powershell "Exit;"
					
					:: [WinEQ2] Processor Priority
					powershell "$WinEQ2Priority=GET-PROCESS WinEQ2 -ErrorAction SilentlyContinue; if ($WinEQ2Priority) { foreach ($i in $WinEQ2Priority) {$i.PriorityClass='%WinEQ2Priority%'} Write-Host "I am Setting [WinEQ2] Processor Priority to [%WinEQ2Priority%]" -BackgroundColor "Yellow" -ForegroundColor "DarkRed" }"
					powershell "Exit;"
					
				)
						
				timeout /t 120
				Exit				

			) ELSE (
				ECHO I Cannot Set Affinity, You Must Run me [As ADMIN]
				timeout /t 120
				Exit
			)
	
	:EOF