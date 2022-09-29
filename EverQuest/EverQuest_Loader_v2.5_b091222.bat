:~[ EverQuest Auto Load Batch File
:~[ Written by NeroMorte
:~[ Verion: 2.5 Build:091222
:~[ Problems/Suggestions Please Contact Me on Discord: NeroMorte#8786
::Batchfile Features

::
:: Version [1.9] Build: [042022] Changes:
:: 	  • Ability to Set Affinity on Each Client Via [PSEXEC.EXE], [Windows Start Command], [Powershell].
::    • Ability to Set Process Priority via [Powershell]
::    • Ability to Set [TimeOut] How long to wait to start next Bots.
::    • Ability to Set [WINEQ2_TimeOut] How long to wait for WinEQ2 to load Before loading Bots.
::    • Ability to Set [StartLoop] & [EndLoop] Pick what Account Numbers Batchfile will load Between Start & End Loop.
::    • Ability to Load [AccountSelector] Shows a List of Accounts you can pick from for Batchfile to loads.
::    • Autoload MQ2 & EQBC, WinEQ2 Before Bots are loaded.
::    • Ability to Use WinEQ2 Profiles or EQGame to Load Bots.
::    • Ability to Load Each Bot from a Different Game Directory.
::    • [AccountSelector] Options: Load Individual Bots, Set Affinity/Priority, Close All Open Client.
::
:: Version [2.5] Build: [091222] Changes:
::    • Added Color to Screen Output & Created a Function to always have same Size table for Account Selector Screen.
::    • Added Code that will Copy MQ2 Code to your Clipboard for use with [STATUS] Feature.
::    • Ability to Load a Range of Toon E.G.; 1-18
::    • Ability to Check Toon Status if Window is Open/Closed. 
::      Type Command: Status (Must set each Character Window Title to either [Login Account] OR [Account Description])
::    • Added all Batch Settings to INI file for ease.
::    • Added Ability to Set a [Group] of accounts to load in EQ Toon Selector & Auto Load EQGame [Group].
::    • Added Ability to Set a [Group] for WINEQ2 Profiles, EQGAME Folder Locations Per Account.
::    • 
::
:: Version [?] Build: [?] UP Comming Features:
::    • Auto Load Accounts Missing Online Status. With A way to Set Check Timer.
::    • Auto Set Resize Windows & Set Window Title on Account loading.
::    • Add Ability to Load Group1 Group3 OR 1-6,12-18
::    • Add Option To Disable Window Resize.
::    • Option To Load Team Sets without Reloading File.
::    • 
::    • 
::


SET EQLoader_Version=Version [2.5] Build: [091222]

:: Load EQ Load As ADMIN ...
CALL :OpenAsADMIN

:: Change Directory to Batchfile Current File Path Location.
PUSHD "%CD%"
CD /D "%~dp0"

:: Set Console Colors
:: COLOR ([Background|Foreground])
::0	=	Black	 	8	=	Gray
::1	=	Blue	 	9	=	Light Blue
::2	=	Green	 	A	=	Light Green
::3	=	Aqua	 	B	=	Light Aqua
::4	=	Red	 		C	=	Light Red
::5	=	Purple	 	D	=	Light Purple
::6	=	Yellow	 	E	=	Light Yellow
::7	=	White	 	F	=	Bright White
COLOR 0F

:: Resize CMD Window.
call :conSize 125 55 125 9999
CLS

@ECHO OFF
setlocal EnableDelayedExpansion
CHCP 65001 > NUL
rem CHCP 437 > NUL


:~
:~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
:~             DO NOT EDIT ABOVE THIS LINE!!!             :
:~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~:
:~
:~
:~-~-~-~Below are the Options you can Set/Edit.~-~-~-~
:~

:: Set INI Filename.
Set "EQLoader_Ini=EQLoader.ini"

:: IF INI Missing Create New INI & Open it up.
IF NOT EXIST "!EQLoader_Ini!" (
	
	CALL :Create_INI
	
	CLS
	ECHO Created [!EQLoader_Ini!] ...
	
	:: Error Reset
	CALL;
	
	Powershell -command "& {Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Notepad++ | Select-Object DisplayName, DisplayVersion} | FINDSTR /I "Notepad++"
	IF [%errorlevel%] EQU [0] (
	
		start notepad++ "!EQLoader_Ini!" -n1
		
		@echo.x=msgbox^("!EQLoader_Ini! Created, Opened Please fill out, Save and press [Enter] key in Batchfile Window to Continue ..." ,0, "!EQLoader_Ini! Created!"^) > msgbox.vbs
		start msgbox.vbs
		
		echo Please Fillout !EQLoader_Ini!, Press Enter here when done.
		echo Press Enter to Continue ...
		
		set /p "input="
		IF EXIST "msgbox.vbs" DEL msgbox.vbs >nul 2>nul
	
	) 
	IF [%errorlevel%] EQU [1] (
	
		start notepad "!EQLoader_Ini!"
		
		@echo.x=msgbox^("!EQLoader_Ini! Created, Opened Please fill out, Save and press [Enter] key in Batchfile Window to Continue ..." ,0, "!EQLoader_Ini! Created!"^) > msgbox.vbs
		start msgbox.vbs
		
		echo Please Fillout !EQLoader_Ini!, Press Enter here when done.
		echo Press Enter to Continue ...
		
		set /p "input="
		IF EXIST "msgbox.vbs" DEL msgbox.vbs >nul 2>nul
	
	)
	
)

::CALL :Record_SYS_Variables

:: Load INI Sections
CALL :ReadINI "!EQLoader_Ini!" "[CPUAffinity][MainSettings][LoginAccounts][WinEQ2Profiles][EQGameDirectory]" "False"
:: Load INI Account Keys
CALL :ReadINI "!EQLoader_Ini!" "[%LoginTeam%][%WinEQ2LoginTeam%][%EQDirectory%]" "False"

::CALL :Report_New_Variables

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

:: FIx Stupid!
IF %StartLoop% EQU 0 SET StartLoop=1
IF "%StartLoop:~0,1%" EQU "-" SET StartLoop=1

:: Set Orginal StartLoop Value.
set StartLoopOrg=%StartLoop%

:: Padding & Frame for Table Formating Below
set "spaces=                                                            "
Set "Columns=|"

:: Line Feed
	(SET LF=^

	)

:: Carriage Return
(SET CR=^&@Echo.     )

:: Backspace 1 Character
for /F %%a in ('echo prompt $H ^| cmd') do set BKSPC=%%a


:~[ IF No EQGAME.EXE Loaded in Task-Manager Then Skip Account Selecter.
IF /I [%AccountSelector%] EQU [0] (
	tasklist /v /fo List /fi "IMAGENAME eq eqgame.exe"		| FINDSTR /i "eqgame.exe" > NUL && (set Choices=YES) || (set Choices=NO)
) ELSE (
	set Choices=YES
)

::Sub Main
:Loop
IF [%Choices%] EQU [NO] (

	:~[ Create [Account_*_Login]&[Account_*_Class] Argument Based on Delimiter [:]
	IF %EQLoadType% EQU WinEQ2 (
		FOR /f "tokens=1,2 delims=:" %%a IN ("!Account_%StartLoop%_Profile!") DO (set Account_%StartLoop%_Profile=%%a&set Account_%StartLoop%_Class=%%b)
		TITLE ACCOUNT: [%StartLoop%] - [!Account_%StartLoop%_Profile!] - [!Account_%StartLoop%_Class!]
	) 
	IF %EQLoadType% EQU EQ (
		FOR /f "tokens=1,2 delims=:" %%a IN ("!Account_%StartLoop%_Login!") DO (set Account_%StartLoop%_Login=%%a&set Account_%StartLoop%_Class=%%b)
		TITLE ACCOUNT: [%StartLoop%] - [!Account_%StartLoop%_Login!] - [!Account_%StartLoop%_Class!]
	)

	:: FIx Stupid!
	IF %EndLoop% EQU 0 SET EndLoop=54
	IF "%EndLoop:~0,1%" EQU "-" SET EndLoop=54
	
	:: Check IF StartLoop & EndLoop Settings are Correct for Current Loaded Variables
	FOR /L %%i IN (%StartLoop%,1,%EndLoop%) DO (
		SET i=%%i
		IF NOT DEFINED Account_%%i_Profile IF %EQLoadType% EQU WinEQ2 (
			GOTO :ExitLoopChecker
		)
		IF NOT DEFINED Account_%%i_Login IF %EQLoadType% EQU EQ (
			GOTO :ExitLoopChecker
		)

	)

)

IF [%Choices%] EQU [YES] (

	TITLE EQ Toon Launcher! Coded by NeroMorte...
	
	IF DEFINED EQSelectorAccounts (SET /A EndLoop=%EQSelectorAccounts%)
	
	:: FIx Stupid!
	IF %EndLoop% EQU 0 SET EndLoop=54
	IF "%EndLoop:~0,1%" EQU "-" SET EndLoop=54
	
	:: Check IF StartLoop & EndLoop Settings are Correct for Current Loaded Variables
	FOR /L %%i IN (%StartLoop%,1,%EndLoop%) DO (
		SET i=%%i
		IF NOT DEFINED Account_%%i_Profile IF %EQLoadType% EQU WinEQ2 (
			GOTO :ExitLoopChecker
		) 
		IF NOT DEFINED Account_%%i_Login IF %EQLoadType% EQU EQ (
			GOTO :ExitLoopChecker
		)	

	)
	
)
:ChoicesEnd


:~[ This Adds Affinity to EQ Game Client
IF /I %Set_Affinity% NEQ 2 (

	IF /I %Set_Affinity% EQU 1 (
		IF /I [%Set_ALL_Affinity%] NEQ [] ( set USE_AFFINITY=/Affinity %Set_ALL_Affinity% )
		IF /I [!Set_%StartLoop%_Affinity!] NEQ [] ( set USE_AFFINITY=/Affinity !Set_%StartLoop%_Affinity! )
	)
	IF /I [%Set_ALL_Affinity%] NEQ [] (
		IF %USE_PSEXEC% EQU 1 ( set RUN_PSEXEC=psexec -d -a %Set_ALL_Affinity%  cmd /c )
	)
	IF /I [!Set_%StartLoop%_Affinity!] NEQ [] (
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
	call :conSize 125 55 125 9999
	CHCP 65001 > NUL
	
	IF [%Choices%] EQU [YES] (
	
		CLS
		
		TITLE EQ Toon Launcher! Coded by NeroMorte...
		
		SET "GroupTeams=1"
		SET "GroupNumbers=1"
		
		CHCP 437 > NUL
		
		IF /I %Display_Color% EQU 1 (
		
			@ECHO.
			SET Write_Output=
			CALL :WriteColor Green "     Batch EQ Toon Launcher %EQLoader_Version%" "PAD"
			Powershell !Write_Output!
			@ECHO.
			@ECHO.
			
			SET Write_Output=
			CALL :WriteColor Green "     Batch File Coded by NeroMorte#8786" "PAD"
			Powershell !Write_Output!
			@ECHO.
			@ECHO.
			
			SET Write_Output=
			set "ESC=^"
			set "ExclamationPoint=!"
			set "Colen=:"
			CALL :WriteColor White "     `[Status`]{ }" "PAD"
			CALL :WriteColor DarkRed "To have this work properly You must Set your EQ Window Titles `n{   }TO [" "NONE"
			CALL :WriteColor White "Account: [Login Account] OR Account Description" "NONE"
			CALL :WriteColor DarkRed "]`n{   }Add Below Code to your Macro Mainloop OR MQ2 zoned.cfg" "NONE"
			Powershell !Write_Output!
			@ECHO.
			@ECHO.
			
			SET Write_Output=
			CALL :WriteColor White "`[Copied to Clipboard`]" "PAD"
			Powershell !Write_Output!
				
			SET Write_Output=
			CALL :WriteColor DarkRed "`n{   }/if `($([char]0x0021)$`{EverQuest.WinTitle.Equal[`%%ESC%%<`%%ESC%%<  Class`%%Colen%% $`{Me.Class`} - Character`%%Colen%% [$`{Me.Name`}] - Account`%%Colen%% [$`{EverQuest`.LoginName`}] - Zone`%%Colen%% [$`{Zone`}  - $`{Zone.ID`}] `%%ESC%%>`%%ESC%%>]`}`) /SetWinTitle `%%ESC%%<`%%ESC%%< Class`%%Colen%% $`{Me.Class`} - Character`%%Colen%% [$`{Me.Name`}] - Account`%%Colen%% [$`{EverQuest`.LoginName`}] - Zone`%%Colen%% [$`{Zone`}  - $`{Zone.ID`}] `%%ESC%%>`%%ESC%%>" "PAD"
			Powershell !Write_Output!
			Powershell !Write_Output! | Clip
			@ECHO.
			@ECHO.
				
			SET Write_Output=
			CALL :WriteColor Green "     Please select From %StartLoopOrg% - %EndLoop% from the following:" "PAD"
			Powershell !Write_Output!
			@ECHO.
			@ECHO.
			
		) ELSE (
			
			@ECHO.
			@ECHO.     Batch EQ Toon Launcher %EQLoader_Version%
			@ECHO.
			@ECHO.
			
			@ECHO.     Batch File Coded by NeroMorte#8786
			@ECHO.
			@ECHO.

			@ECHO.     [ Status ] To have this work properly You must Set your EQ Window Titles
			@ECHO.     TO [Account: [Login Account] OR Account Description]
			@ECHO.     Add Below Code to your Macro Mainloop OR MQ2 zoned.cfg
			@ECHO.
			@ECHO.
			
			@ECHO.     [ Copied to Clipboard ]
			SET Write_Output=
			SET "ESC=^"
			SET "ExclamationPoint=!"
			SET "Colen=:"
			CALL :WriteColor White "`n{   }/if `($([char]0x0021)$`{EverQuest.WinTitle.Equal[`%%ESC%%<`%%ESC%%<  Class`%%Colen%% $`{Me.Class`} - Character`%%Colen%% [$`{Me.Name`}] - Account`%%Colen%% [$`{EverQuest`.LoginName`}] - Zone`%%Colen%% [$`{Zone`}  - $`{Zone.ID`}] `%%ESC%%>`%%ESC%%>]`}`) /SetWinTitle `%%ESC%%<`%%ESC%%< Class`%%Colen%% $`{Me.Class`} - Character`%%Colen%% [$`{Me.Name`}] - Account`%%Colen%% [$`{EverQuest`.LoginName`}] - Zone`%%Colen%% [$`{Zone`}  - $`{Zone.ID`}] `%%ESC%%>`%%ESC%%>" "PAD"
			Powershell !Write_Output!
			Powershell !Write_Output! | CLIP
			
			@ECHO.     
			@ECHO.     Please select From %StartLoopOrg% - %EndLoop% from the following:
			@ECHO.
			@ECHO.
     	 
		)
		
		CHCP 65001 > NUL
		
		call :Write "*" "7+4+15+60+3
		
		call :FormatTable "[7] [4] [15] [60]" "%Columns%Online%spaces:~0,7%" "%Columns% ##%spaces:~0,4%" "%Columns% Login Account%spaces:~0,15%" "%Columns% Account Description %spaces:~0,36% %Columns%"
		@ECHO.     !line!
			
		:ChoiceLoop
		IF [!Account_%StartLoop%_Login!] NEQ [] IF %EQLoadType% EQU EQ (
		
			:~[ Create [Account_*_Login]&[Account_*_Class] Argument Based on Delimiter [:]
			IF NOT Defined Account_%StartLoop%_Class FOR /f "tokens=1,2 delims=:" %%a IN ("!Account_%StartLoop%_Login!") DO (set Account_%StartLoop%_Login=%%a&set Account_%StartLoop%_Class=%%b)
				
			:: Set GameStatus Based on [Account or Account Description] 
			SET GameStatus=0
			IF !GameStatus! EQU 0 ( TASKLIST /v /fo List /fi "IMAGENAME eq eqgame.exe"		| FINDSTR /IC:"Account: [!Account_%StartLoop%_Login!]" > NUL && (SET GameStatus=1) || (SET GameStatus=0) )
			IF !GameStatus! EQU 0 ( TASKLIST /v /fo List /fi "IMAGENAME eq eqgame.exe"		| FINDSTR /IC:"!Account_%StartLoop%_Class!" > NUL && (SET GameStatus=1) || (SET GameStatus=0) )
			IF !GameStatus! EQU 1 (SET GameStatus=▓▓▓) ELSE (SET GameStatus=░░░)
			
			:~[ Parse through Each Account Listed.
			set "Col[1]=[!GameStatus!]%spaces%"
			IF %StartLoop% LSS 10 (
				set "Col[2]=0%StartLoop%%spaces%"
			) ELSE (
				set "Col[2]=%StartLoop%%spaces%"
			)
			set "Col[3]=!Account_%StartLoop%_Login!%spaces%"
			set "Col[4]=!Account_%StartLoop%_Class!%spaces%"
						
		)

		IF [!Account_%StartLoop%_Profile!] NEQ [] IF %EQLoadType% EQU WinEQ2 (
		
			:~[ Create [Account_*_Profile]&[Account_*_Class] Argument Based on Delimiter [:]
			IF NOT Defined Account_%StartLoop%_Class FOR /f "tokens=1,2 delims=:" %%a IN ("!Account_%StartLoop%_Profile!") DO (set Account_%StartLoop%_Profile=%%a&set Account_%StartLoop%_Class=%%b)
			
			:: Set GameStatus Based on [Account or Account Description] 
			SET GameStatus=0
			IF !GameStatus! EQU 0 ( TASKLIST /v /fo List /fi "IMAGENAME eq eqgame.exe"		| FINDSTR /IC:"Account: [!Account_%StartLoop%_Profile!]" > NUL && (SET GameStatus=1) || (SET GameStatus=0) )
			IF !GameStatus! EQU 0 ( TASKLIST /v /fo List /fi "IMAGENAME eq eqgame.exe"		| FINDSTR /IC:"!Account_%StartLoop%_Class!" > NUL && (SET GameStatus=1) || (SET GameStatus=0) )
			IF !GameStatus! EQU 1 (SET GameStatus=▓▓▓) ELSE (SET GameStatus=░░░)
			
			:~[ Parse through Each Account Listed.
			set "Col[1]=[!GameStatus!]%spaces%"
			IF %StartLoop% LSS 10 (
				set "Col[2]=0%StartLoop%%spaces%"
			) ELSE (
				set "Col[2]=%StartLoop%%spaces%"
			)
			set "Col[3]=!Account_%StartLoop%_Profile!%spaces%"
			set "Col[4]=!Account_%StartLoop%_Class!%spaces%"
			
		)
		
		IF %StartLoop% EQU !GroupNumbers! (
			call :FormatTable "[26] [0] [0] [60]" "%Columns%       Group Team #!GroupTeams!" " " " " "%Columns% %spaces:~0,56% %Columns%"
			@ECHO.     !line!
			
			IF !GroupNumbers! EQU 1 (
				SET /A GroupNumbers=7
			) ELSE (
				SET /A GroupNumbers=!GroupNumbers!+6
			)
			
			SET /A GroupTeams=!GroupTeams!+1
		)
		
		call :FormatTable "[7] [4] [15] [60]" "%Columns% !Col[1]:~0,7!" "%Columns% !Col[2]:~0,4!" "%Columns% !Col[3]:~0,15!" "%Columns% !Col[4]:~0,56! %Columns%"
		
		REM	12345678901245678901234567890123456789012345678901234567890123456789012345678901234567890	
		REM | [▓▓▓] | 01 | Account     | GROUP1-ENC [CharacterName]                                 |
		REM | [░░░] | 01 | Account     | GROUP1-ENC [CharacterName]                                 |
		
		Set "Line1=!line:~0,1! !line:~2,1!"
		Set "Line2=!line:~3,3!"
		Set "Line3=!line:~6,1! !line:~8,1!!line:~9,4!!line:~13,1!"
		Set "Line4=!line:~14,15!"
		Set "Line5=!line:~29,1!"
		Set "Line6=!line:~30,58!"
		Set "Line7=!line:~88,1!"
		
		@ECHO.     !Line1!!Line2!!Line3!!Line4!!Line5!!Line6!!Line7!
		
		IF [%StartLoop%] EQU [%EndLoop%] ( GOTO :ChoiceEND )
		SET /a StartLoop=%StartLoop%+1
		GOTO :ChoiceLoop
		
		:ChoiceEND
		call :Write "*" "7+4+15+60+3
		
		CHCP 437 > NUL
		
		IF /I %Display_Color% EQU 1 (
			
			@ECHO.
			SET Write_Output=
			CALL :WriteColor White "     [   STATUS  ]" "PAD"
			CALL :WriteColor Red "-" "NONE"
			CALL :WriteColor Green "[ Refresh Character Selector Status Page." "NONE"
			Powershell !Write_Output!
			@ECHO.
			@ECHO.
			
			SET Write_Output=
			CALL :WriteColor White "     [   MOD  ]" "PAD"
			CALL :WriteColor Red "-" "NONE"
			CALL :WriteColor Green "[ Sets All Open Clients Affinity/Priority." "NONE"
			Powershell !Write_Output!
			@ECHO.
			@ECHO.
			
			SET Write_Output=
			CALL :WriteColor White "     [   Close  ]" "PAD"
			CALL :WriteColor Red "-" "NONE"
			CALL :WriteColor Green "[ Closes all instances of [eqgame.exe] running! `(Requires: Run As Administrator`)" "NONE"
			Powershell !Write_Output!
			@ECHO.
			@ECHO.
			
			SET Write_Output=
			CALL :WriteColor White "     [   Exit  ]" "PAD"
			CALL :WriteColor Red "-" "NONE"
			CALL :WriteColor Green "[ Closes and Exit the EQ Loader Script." "NONE"
			Powershell !Write_Output!
			@ECHO.
			@ECHO.
			
			SET Write_Output=
			CALL :WriteColor DarkRed "     Pick Account Number`(s`) to Load?... Seperated by [ Space or Comma or Dash `(1-6`) ]. " "PAD"
			Powershell !Write_Output!
			@ECHO.
			SET Write_Output=
			CALL :WriteColor DarkRed "     May also Type [ Status or MOD or Close or Exit ]. " "PAD"
			Powershell !Write_Output!
			@ECHO.
			@ECHO.
			
		) ELSE (
		
			@ECHO.
			@ECHO.     [ STATUS ]-[ Refresh Character Selector Status Page.
			@ECHO.
			
			@ECHO.     [ MOD ]-[ Sets All Open Clients Affinity/Priority.
			@ECHO.
			@ECHO.
			
			@ECHO.     [ Close ]-[ Closes all instances of [eqgame.exe] running! ^(Requires: Run As Administrator^)
			@ECHO.
			@ECHO.
			
			@ECHO.     [ Exit ]-[ Closes and Exit the EQ Loader Script.
			@ECHO.
			@ECHO.
			
			@ECHO.     Pick Account Number^(s^) to Load?... Seperated by [ Space or Comma or Dash ^(1-6^) ].
			@ECHO.
			@ECHO.     May also Type [ Status or MOD or Close or Exit ].
			@ECHO.
			@ECHO.
		)		
		
		CHCP 65001 > NUL
		
		:Selection
		SET StartLoop=%StartLoopOrg%
		
		@echo. 
		set /p "Login=Your Option. ?"
		@echo. 
		
		set Login=%Login:,= %
		
		:~[ Check Variable [%Login%] For Close.
		ECHO %Login% | FINDSTR /I "STATUS"
		IF [%ErrorLevel%] EQU [0] (
			:: GOTO Account Selector Screen.
			GOTO :ELSE
		)
		
		:~[ Check Variable [%Login%] For Close.
		ECHO %Login% | FINDSTR /I "CLOSE"
		IF [%ErrorLevel%] EQU [0] (
			Taskkill /t /f /im eqgame.exe
			GOTO :ELSE
		)
		
		:~[ Check Variable [%Login%] For Exit
		ECHO %Login% | FINDSTR /I "EXIT"
		IF [%ErrorLevel%] EQU [0] (
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
			tasklist /v /fo List /fi "IMAGENAME eq %MQ2_Application%"		| FINDSTR /i "%MQ2_Application%" > NUL || (start "MacroQuest2" /d "%MQ2_Path%" "%MQ2_Path%\%MQ2_Application%")  && (timeout /t %TimeOut%)
		)
		

		:~[ Start EQBCS Second IF Enabled
		IF /I %EQBCS% EQU 1 (
			@echo. 
			@echo. Load Type: 		[EQBCS=ON]
			@echo. Path: 			[!EQBCS_Path!]
			@echo. 
			tasklist /v /fo List /fi "IMAGENAME eq %EQBCS_Application%"		| FINDSTR /i "%EQBCS_Application%" > NUL || (start "EQBCServer" /d "%EQBCS_Path%" "%EQBCS_Path%\%EQBCS_Application%")  && (timeout /t %TimeOut%)
		)
		
		CLS
		
		SET "MultiCheck=x%Login:-=%"
		IF NOT !MultiCheck! EQU x!Login! ( call :LoadMultiple )
		
		for %%1 in (%Login%) do (
		
			IF [!Account_%%1_EQDirectory!] NEQ [] (
				set EQ_Game_Path=!Account_%%1_EQDirectory!
				ECHO !EQ_Game_Path! :: !Account_%%1_EQDirectory!
			)
			
			IF [!Account_%%1_Profile!] NEQ [] IF %EQLoadType% EQU WinEQ2 (
				
				TITLE ACCOUNT: [%%1] - [!Account_%%1_Profile!] - [!Account_%%1_Class!]
				
				@echo. 
				@echo. EQ Load Type:    	[%EQLoadType%]
				@echo. EQ User Account:	[!Account_%%1_Profile!]
				@echo. Path: 			[!EQ_Game_Path!]
				@echo. Affinity: 		[%USE_AFFINITY%%CPUCore%^^2]
				@echo. Description:		[!Account_%%1_Class!]
				@echo.
				
				tasklist /v /fo List /fi "IMAGENAME eq WinEQ2.exe"		| FINDSTR /i "WinEQ2.exe" > NUL || (%RUN_PSEXEC% start %USE_AFFINITY% "!Account_%%1_Profile!" /d "%EQ_WINEQ2_Path%\" "%EQ_WINEQ2_Path%\WinEQ2.exe")  && (timeout /t %WINEQ2_TimeOut%)
				%RUN_PSEXEC% start %USE_AFFINITY% "!Account_%%1_Profile!" /d "%EQ_WINEQ2_Path%\"  "%EQ_WINEQ2_Path%\WinEQ2.exe" /plugin:WinEQ2-EQ.dll "!Account_%%1_Profile!"
				timeout /t %TimeOut%
			
			) 
			IF [!Account_%%1_Login!] NEQ [] IF %EQLoadType% EQU EQ (
				
				TITLE ACCOUNT: [%%1] - [!Account_%%1_Login!] - [!Account_%%1_Class!]
				
				@echo. 
				@echo. EQ Load Type:    	[%EQLoadType%]
				@echo. EQ User Account:	[!Account_%%1_Login!]
				@echo. Path: 			[!EQ_Game_Path!]
				@echo. Affinity: 		[%USE_AFFINITY%%CPUCore%^^2]
				@echo. Description:		[!Account_%%1_Class!]
				@echo.
	
				%RUN_PSEXEC% start %USE_AFFINITY% "!Account_%%1_Login!" /d "!EQ_Game_Path!" "!EQ_Game_Path!\eqgame.exe" patchme /Login:!Account_%%1_Login! && (timeout /t %TimeOut%)
				
			)

		)
			
		TITLE ALL Selected Accounts [%Login%] have been Loaded.
		timeout /t 120
		
		IF /I [%Set_Affinity%] EQU [2] ( GOTO :AffinitySet )
		IF /I [%Set_Priority%] EQU [1] ( GOTO :PrioritySet )
		
		:: GOTO Account Selector Screen.
		IF [%Choices%] EQU [NO] SET Choices=YES
		IF DEFINED EQSelectorAccounts (
			SET /A StartLoop=%StartLoopOrg%
			SET /A EndLoop=%EQSelectorAccounts%
		) ELSE (
			SET /A StartLoop=%StartLoopOrg%
		)
		GOTO :ELSE
		
	)
	:: End Choice YES

		:~[ Start MQ2 First IF Enabled
		IF /I %MQ2% EQU 1 (
			@echo. 
			@echo. Load Type: 		[MQ2=ON]
			@echo. EQ User Account:	[!Account_%StartLoop%_Login!]
			@echo. Path:			[!MQ2_Path!]
			@echo. 
			tasklist /v /fo List /fi "IMAGENAME eq %MQ2_Application%"		| FINDSTR /i "%MQ2_Application%" > NUL || (start "MacroQuest2" /d "%MQ2_Path%" "%MQ2_Path%\%MQ2_Application%")  && (timeout /t %TimeOut%)
		)

		:~[ Start EQBCS Second IF Enabled
		IF /I %EQBCS% EQU 1 (
			@echo. 
			@echo. Load Type: 		[EQBCS=ON]
			@echo. EQ User Account:	[!Account_%StartLoop%_Login!]
			@echo. Path: 			[!EQBCS_Path!]
			@echo. 
			tasklist /v /fo List /fi "IMAGENAME eq %EQBCS_Application%"		| FINDSTR /i "%EQBCS_Application%" > NUL || (start "EQBCServer" /d "%EQBCS_Path%" "%EQBCS_Path%\%EQBCS_Application%")  && (timeout /t %TimeOut%)
		)
		
		IF [!Account_%StartLoop%_EQDirectory!] NEQ [] (
			ECHO !EQ_Game_Path! :: !Account_%StartLoop%_EQDirectory!
			set EQ_Game_Path=!Account_%StartLoop%_EQDirectory!
		)
		
		:~[ Start EQ Game IF Enabled
		IF /I %EQLoadType% EQU EQ (
			@echo. 
			@echo. EQ Load Type: 		[%EQLoadType%]
			@echo. EQ User Account:	[!Account_%StartLoop%_Login!]
			@echo. Path: 			[!EQ_Game_Path!]
			@echo. Affinity: 		[%USE_AFFINITY%%CPUCore%^^2]
			@echo. Description:		[!Account_%StartLoop%_Class!]
			@echo. 
			%RUN_PSEXEC% start %USE_AFFINITY% "!Account_%StartLoop%_Login!" /d "!EQ_Game_Path!" "!EQ_Game_Path!\eqgame.exe" patchme /Login:!Account_%StartLoop%_Login! && (timeout /t %TimeOut%)
		)		
		
		:~[ Start WINEQ2 & Game IF Enabled
		IF /I %EQLoadType% EQU WinEQ2 (
			@echo. 
			@echo. EQ Load Type: 		[%EQLoadType%]
			@echo. EQ User Account:	[!Account_%StartLoop%_Profile!]
			@echo. Path: 			[!EQ_WINEQ2_Path!]
			@echo. Affinity: 		[%USE_AFFINITY%%CPUCore%^^2]
			@echo. Description:		[!Account_%StartLoop%_Class!]
			@echo. 
			tasklist /v /fo List /fi "IMAGENAME eq WinEQ2.exe"		| FINDSTR /i "WinEQ2.exe" > NUL || (%RUN_PSEXEC% start %USE_AFFINITY% "!Account_%StartLoop%_Profile!" /d "%EQ_WINEQ2_Path%\" "%EQ_WINEQ2_Path%\WinEQ2.exe")  && (timeout /t %WINEQ2_TimeOut%)
			%RUN_PSEXEC% start %USE_AFFINITY% "!Account_%StartLoop%_Profile!" /d "%EQ_WINEQ2_Path%\"  "%EQ_WINEQ2_Path%\WinEQ2.exe" /plugin:WinEQ2-EQ.dll "!Account_%StartLoop%_Profile!"
			timeout /t %TimeOut%
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
		
		:: GOTO Account Selector Screen.
		IF [%Choices%] EQU [NO] SET Choices=YES
		IF DEFINED EQSelectorAccounts (
			SET /A StartLoop=%StartLoopOrg%
			SET /A EndLoop=%EQSelectorAccounts%
		) ELSE (
			SET /A StartLoop=%StartLoopOrg%
		)
		GOTO :ELSE
		
		:AffinitySet
		CHCP 437 > NUL
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
				:: GOTO Account Selector Screen.
				IF [%Choices%] EQU [NO] SET Choices=YES
				IF DEFINED EQSelectorAccounts (
					SET /A StartLoop=%StartLoopOrg%
					SET /A EndLoop=%EQSelectorAccounts%
				) ELSE (
					SET /A StartLoop=%StartLoopOrg%
				)
				GOTO :ELSE

			) ELSE (
				ECHO I Cannot Set Affinity, You Must Run me [As ADMIN]
				timeout /t 120
				:: GOTO Account Selector Screen.
				IF [%Choices%] EQU [NO] SET Choices=YES
				IF DEFINED EQSelectorAccounts (
					SET /A StartLoop=%StartLoopOrg%
					SET /A EndLoop=%EQSelectorAccounts%
				) ELSE (
					SET /A StartLoop=%StartLoopOrg%
				)
				GOTO :ELSE
			)

EXIT /B
::Return

:: Sub
:ExitLoopChecker

	SET /A EndLoop=!i!-1

	:: Error Reset
	CALL;
	Powershell -command "& {Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Notepad++ | Select-Object DisplayName, DisplayVersion} | FINDSTR /I "Notepad++"
	IF %EndLoop% EQU 0 IF [%errorlevel%] EQU [0] (
		IF /I %EQLoadType% EQU EQ (
			start notepad++ "!EQLoader_Ini!" -n152
			@echo.x=msgbox^("No Accounts Selected in [!EQLoader_Ini!] Please see Section: [LoginAccounts] KEY: [LoginTeam=] AT Line: 152" ,0, "Search for LoginTeam="^) > msgbox.vbs
		)
		IF /I %EQLoadType% EQU WinEQ2 (
			start notepad++ "!EQLoader_Ini!" -n151
			@echo.x=msgbox^("No Accounts Selected in [!EQLoader_Ini!] Please see Section: [LoginAccounts] KEY: [WinEQ2LoginTeam=]" ,0, "Search for WinEQ2LoginTeam="^) > msgbox.vbs
		)
		start msgbox.vbs
		TimeOut /t 20
		IF EXIST "msgbox.vbs" DEL msgbox.vbs >nul 2>nul
		EXIT
	) 
	IF %EndLoop% EQU 0 IF [%errorlevel%] EQU [1] (
		start notepad "!EQLoader_Ini!"
		@echo.x=msgbox^("No Accounts Selected in [!EQLoader_Ini!] Please see Section: [LoginAccounts] KEY: [LoginTeam=] AT Line: 152" ,0, "Search for LoginTeam="^) > msgbox.vbs
		start msgbox.vbs
		TimeOut /t 20
		IF EXIST "msgbox.vbs" DEL msgbox.vbs >nul 2>nul
		EXIT
	)

GOTO :ChoicesEnd
::Return

::Sub
:OpenAsADMIN
	
	@ECHO OFF
	
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

		::Change Directory to Batchfile Current File Path Location.
		PUSHD "%CD%"
		CD /D "%~dp0"
		
    EXIT

	::Change Directory to Batchfile Current File Path Location.
	:gotAdmin
    PUSHD "%CD%"
    CD /D "%~dp0"
	
EXIT /B
::Return

::Sub
:is_Numeric
echo [%Login%] %Login: =%
	
	IF !Login! EQU [] GOTO :ELSE
	
	SET "is_Numeric="&FOR /F "delims=0123456789" %%i IN ("%Login: =%") DO SET is_Numeric=%%i
	IF DEFINED is_Numeric (
		ECHO [%Login: =%] NOT numeric
		Pause
		GOTO :ELSE
	) ELSE (
		ECHO [%Login: =%] numeric
	)

EXIT /B
::Return

::Sub
:LoadMultiple
	
	SET Accounts=!Login!
	SET Login=
	
	:: FOR /F "tokens=* delims= " %%a IN ("!Login!") DO (SET OLDLogin=!OLDLogin! %%a )
	FOR /F "tokens=1,2 delims=-" %%a IN ("!Accounts!") DO ( SET MultipleLoad[1]=%%a&SET MultipleLoad[2]=%%b )	
	FOR /L %%n in (!MultipleLoad[1]!,1,!MultipleLoad[2]!) do (
		SET "Login=!Login!%%n "
	)

EXIT /B
::Return
		
::Sub
:Write
	
	SET "Write_String=%~1"
	SET /A Write_Qty=%~2
	SET len=0

	FOR /l %%i IN (2,1,%Write_Qty%) DO CALL SET "Write_String=%%Write_String%%%Write_String%"
	@Echo.     %Write_String%

EXIT /B
::Return

::Sub
:WriteColor
	
	SET Write_Color=%1
	SET Write_Message=%~2
	SET "Padding=    "
	
	IF %~3 EQU PAD (
		SET Write_Output=%Write_Output% Write-Host "$env:Padding%Write_Message%" -ForegroundColor %Write_Color% -NoNewline;
	) ELSE (
		SET Write_Output=%Write_Output% Write-Host "%Write_Message%" -ForegroundColor %Write_Color% -NoNewline;
	)

EXIT /B
::Return

::Sub  :~0,%%b
:FormatTable [Width] [Width] [Width] [Col1] [Col2] [Col3]

	set "fmt=%~1"
	set "line="
	set "space=                                                                                                    "
	
	for %%n in (^"^

^") do for /f "tokens=1,2 delims=[" %%a in (".!fmt:]=%%~n.!") do (
		
		set "const=%%a"
		call set "subst=%%~2%space%%%~2"
		
		if %%b0 geq 0 (set "subst=!subst:~0,%%b!") else set "subst=!subst:~%%b!"
		
		for /f delims^=^ eol^= %%c in ("!line!!const:~1!!subst!") do (
			set "line=%%c"
		)
		
		shift /2
	
	)

EXIT /B
::Return

::Sub
:conSize  winWidth  winHeight  bufWidth  bufHeight
mode con: cols=%1 lines=%2
powershell -command "&{$H=get-host;$W=$H.ui.rawui;$B=$W.buffersize;$B.width=%3;$B.height=%4;$W.buffersize=$B;}"

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

	IF /I "!eReport!" EQU "True" (
		ECHO INIFile: [%INIFile%] Section: [%INISection%]
		@Echo.
	)

	:: FOR /f "tokens=1,* eol=| delims==" %%c IN ('find /v "" %INIFile% ^| find /v "---"')
	FOR /f "usebackq tokens=1,* eol=| delims==" %%a IN (%INIFile%) DO (
		SET "INILine=%%a"
		SET "KEY=%%a"
		SET "VALUE=%%b"
		
		IF "!VALUE!"=="" IF /I "!KEY:~0,1!" EQU "[" (
			IF /I "!eReport!" EQU "True" ( echo String: !INISection!&echo SearchForRemove: !KEY! )
			for %%N in (!KEY!) do (	set "Before=!INISection:%%N="! & set "After=!INISection:*%%N=!"	)
			IF /I "!eReport!" EQU "True" ( @echo.&Echo Before: ::!Before: =!:: )
			IF /I "!eReport!" EQU "True" ( Echo After: ::!After: =!::&@echo. )
			
			IF /I "!KEY:~0,1!" EQU "[" IF "!Before: =!" NEQ "!After: =!" ( IF /I "!eReport!" EQU "True" ( Echo Section Found: !KEY! ) ) ELSE ( IF /I "!eReport!" EQU "True" ( Echo Section not Found: !KEY! ) )
		)
		
		IF "!VALUE!"=="" (
			
			REM NO = so must be [SECTION]
			IF /I "!INISection!" NEQ "ALL" (			
				IF /I "!KEY:~0,1!" EQU "[" IF "!Before: =!" NEQ "!After: =!" (
					IF /I "!eReport!" EQU "True" ( Echo Found Correct Section [%INISection%] )
					SET "FLAG=Y"
				) 
				IF /I "!KEY:~0,1!" EQU "[" IF "!Before: =!" EQU "!After: =!" (
					:: RESET Function Variables
					IF /I "!eReport!" EQU "True" ( Echo !KEY! ^|-[Skipping Line0] )
					SET "KEY="
					SET "VALUE="
					SET "FLAG="
				)
			) ELSE (
				SET "FLAG=Y"
			)
		
		)
		
		IF DEFINED FLAG IF "!VALUE!" NEQ "" IF "!KEY:~0,1!" NEQ ";" (
			IF /I "!eReport!" EQU "True" ( Echo Setting: [!KEY!=!VALUE!] )
			SET "!KEY!=!VALUE!"
		
		)
		
		REM ECHO -[IS KEY SET]-
		IF /I "!INISection!" NEQ "ALL" (
			IF "x!KEY:[=!" NEQ "x!KEY!" (
				SET | FINDSTR /IC:"!KEY!=" > NUL && (
					IF DEFINED FLAG (
						IF /I "!eReport!" EQU "True" ( Echo !KEY!=!VALUE! ^|-[Skipping Line1] )
					) ELSE (
						IF /I "!eReport!" EQU "True" ( ECHO !KEY!=!VALUE! ^|-[Skipping Line2] )
					)
				) || (
					IF DEFINED FLAG (
						IF /I "!eReport!" EQU "True" ( Echo !KEY! ^|-[Skipping Line3] )
					) ELSE (
						IF /I "!eReport!" EQU "True" ( ECHO !KEY! ^|-[Skipping Line4] )
					)
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

:: Sub Record System Environment Variables
:Record_SYS_Variables

	set "oldfile=oldfile.txt"
	set "newfile=newfile.txt"
	
	IF EXIST "!oldfile!" del !oldfile! >nul 2>nul
	IF EXIST "!newfile!" del !newfile! >nul 2>nul
	FOR /f %%a IN ('SET') DO ECHO %%a>>!oldfile!

EXIT /B
::Return

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

:: Sub Batch File Create INI File.
:Create_INI
(
@ECHO.;~[ EverQuest Auto Load Batch File
@ECHO.;~[ Written by NeroMorte
@ECHO.;~[ Verion: 2.5 Build:091222
@ECHO.;~[ Problems/Suggestions Please Contact Me on Discord: NeroMorte#8786
@ECHO.
@ECHO.
@ECHO.;: [Batchfile Features]
@ECHO.;:
@ECHO.;: Version [1.9] Build: [042022] Changes:
@ECHO.;: 	  • Ability to Set Affinity on Each Client Via [PSEXEC.EXE], [Windows Start Command], [Powershell].
@ECHO.;:    • Ability to Set Process Priority via [Powershell]
@ECHO.;:    • Ability to Set [TimeOut] How long to wait to start next Bots.
@ECHO.;:    • Ability to Set [WINEQ2_TimeOut] How long to wait for WinEQ2 to load Before loading Bots.
@ECHO.;:    • Ability to Set [StartLoop] ^& [EndLoop] Pick what Account Numbers Batchfile will load Between Start ^& End Loop.
@ECHO.;:    • Ability to Load [AccountSelector] Shows a List of Accounts you can pick from for Batchfile to loads.
@ECHO.;:    • Autoload MQ2 ^& EQBC, WinEQ2 Before Bots are loaded.
@ECHO.;:    • Ability to Use WinEQ2 Profiles or EQGame to Load Bots.
@ECHO.;:    • Ability to Load Each Bot from a Different Game Directory.
@ECHO.;:    • [AccountSelector] Options: Load Individual Bots, Set Affinity/Priority, Close All Open Client.
@ECHO.;:
@ECHO.;: Version [2.5] Build: [091222] Changes:
@ECHO.;:    • Added Color to Screen Output ^& Created a Function to always have same Size table for Account Selector Screen.
@ECHO.;:    • Added Code that will Copy MQ2 Code to your Clipboard for use with [STATUS] Feature.
@ECHO.;:    • Ability to Load a Range of Toon E.G.; 1-18
@ECHO.;:    • Ability to Check Toon Status if Window is Open/Closed. 
@ECHO.;:      Type Command: Status ^(Must set each Character Window Title to either [Login Account] OR [Account Description]^)
@ECHO.;:    • Added all Batch Settings to INI file for ease.
@ECHO.;:    • Added Ability to Set a [Group] of accounts to load in EQ Toon Selector ^& Auto Load EQGame [Group].
@ECHO.;:    • Added Ability to Set a [Group] for WINEQ2 Profiles, EQGAME Folder Locations Per Account.
@ECHO.;:    • 
@ECHO.;:
@ECHO.;: Version [?] Build: [?] UP Comming Features:
@ECHO.;:    • Auto Load Accounts Missing Online Status. With A way to Set Check Timer.
@ECHO.;:    • Auto Set Resize Windows ^& Set Window Title on Account loading.
@ECHO.;:    • 
@ECHO.;:    • 
@ECHO.;:
@ECHO.
@ECHO.[CPUAffinity]
@ECHO.; [ 24 Cores: 0xFFFFFF ][ 23 Cores: 0x7FFFFF ][ 22 Cores: 0x3FFFFF ][ 21 Cores: 0x1FFFFF ][ 20 Cores: 0xFFFFF ][ 19 Cores: 0x7FFFF ]
@ECHO.; [ 18 Cores: 0x3FFFF ][ 17 Cores: 0x1FFFF ][ 16 Cores: 0xFFFF ][ 15 Cores: 0x7FFF ][ 14 Cores: 0x3FFF ][ 13 Cores: 0x1FFF ]
@ECHO.; [ 12 Cores: 0xFFF ][ 11 Cores: 0x7FF ][ 10 Cores: 0x3FF ][ 09 Cores: 0x1FF ][ 08 Cores: 0xFF ][ 07 Cores: 0x7F ]
@ECHO.; [ 06 Cores: 0x3F ][ 05 Cores: 0x1F ][ 04 Cores: 0xF ][ 03 Cores: 0x7 ][ 02 Cores: 0x3 ][ 01 Cores: 0x1 ]
@ECHO.; For other Affinity Combonation Use: https://bitsum.com/tools/cpu-affinity-calculator/
@ECHO.;psexec -d -a 7F cmd /c
@ECHO.
@ECHO.;~[ Options are 1 = ON or 0 = OFF ^(To Set Affinity Via PSEXEC^)
@ECHO.;~[ COPY [PSEXEC.EXE] TO [C:\Windows\System32\] P.S. Make sure to run psexec once first and accept terms.
@ECHO.USE_PSEXEC=0
@ECHO.
@ECHO.;~[ Set_Affinity= Options are 1 = ON or 0 = OFF OR 2 = Power-Shell Set Affinity ^(CPUCore Must be Set to Current Amount of Cores.^)  **Requires Run As Admin**
@ECHO.;~[  Option 1 = Windows Start /Affinity Command.
@ECHO.;~[  Option 2 = Creamo's EQ Affinity Batchfile.
@ECHO.;~[  Set_Affinity= ^(Default: 2^)
@ECHO.;~[  This Uses an Even Balance Method to Split Cores.
@ECHO.Set_Affinity=2
@ECHO.CPUCore=24
@ECHO.
@ECHO.;~[ Set_Priority= Options are 1 = ON or 0 = OFF
@ECHO.;~[ Priority Options   ;~[ Idle, BelowNormal, Normal, AboveNormal, High, RealTime
@ECHO.;~[ Priority Options   ;~[ 64  , 16384      , 32    , 32768      , 128 , 256
@ECHO.;~[ IF Set_Priority=1  ;~[   Make sure [MQ2_Application=, EQBCS_Application=] are Set below so Code knows what Process to Modify.
@ECHO.Set_Priority=0
@ECHO.EQGamePriority=AboveNormal
@ECHO.EQBCServerPriority=High
@ECHO.MQ2Priority=High
@ECHO.WinEQ2Priority=High
@ECHO.
@ECHO.;~[ This Sets the affinity for all eqgame the same. ^(Default: 0xFFFFFF^) 24 Cores
@ECHO.;~[ Batch will Skip Blank =
@ECHO.;~[ Must be set if using Set_Affinity=1 IF blank will use per client Set_*_Affinity Below.
@ECHO.Set_ALL_Affinity=
@ECHO.
@ECHO.;~[ This Sets the affinity Per eqgame Client loaded. ^(Can Add Unlimited Amount of Set Affinitys^)
@ECHO.;~[ Batch will Skip Blank =
@ECHO.
@ECHO.;~[ Group #1
@ECHO.Set_1_Affinity=
@ECHO.Set_2_Affinity=
@ECHO.Set_3_Affinity=
@ECHO.Set_4_Affinity=
@ECHO.Set_5_Affinity=
@ECHO.Set_6_Affinity=
@ECHO.;~[ Group #2
@ECHO.Set_7_Affinity=
@ECHO.Set_8_Affinity=
@ECHO.Set_9_Affinity=
@ECHO.Set_10_Affinity=
@ECHO.Set_11_Affinity=
@ECHO.Set_12_Affinity=
@ECHO.;~[ Group #3
@ECHO.Set_13_Affinity=
@ECHO.Set_14_Affinity=
@ECHO.Set_15_Affinity=
@ECHO.Set_16_Affinity=
@ECHO.Set_17_Affinity=
@ECHO.Set_18_Affinity=
@ECHO.
@ECHO.[MainSettings]
@ECHO.;~[ This will Determine EQ Loader is [Colored] OR [Black/White] ^(Default: 1^)
@ECHO.Display_Color=1
@ECHO.
@ECHO.;~[ This is the Delay until Next Window will Load. ^(Default: 8^)
@ECHO.TimeOut=1
@ECHO.
@ECHO.;~[ This is the Delay until WinEQ2 Finished loading, Selected Profile will start to load^ (Default: 30^)
@ECHO.WINEQ2_TimeOut=30
@ECHO.
@ECHO.;~[ First Account Number to start with.
@ECHO.StartLoop=1
@ECHO.
@ECHO.;~[ Last Account Number to end on.
@ECHO.EndLoop=30
@ECHO.
@ECHO.;~[ Options are 1 = ON or 0 = OFF ^(IF =1 Will Ignore [StartLoop,EndLoop] Settings^) ^(Default: 0^)
@ECHO.;~[ This will Force Batchfile to Load Account Selector, not auto load all Accounts listed in [StartLoop,EndLoop] Settings.
@ECHO.;~[ This Option Auto turns ON once you have at least one EQGame open.
@ECHO.;~[ EQSelectorAccounts= Blank will load "EndLoop" of Toons or you can pick how many EQ Toon Selector loads. ^(Default: Blank^)
@ECHO.AccountSelector=0
@ECHO.EQSelectorAccounts=
@ECHO.
@ECHO.;~[ Options are 1 = ON or 0 = OFF ^(IF Open will not Try to Open Another.^) ^(Default: 0^)
@ECHO.;~[ Path Do not include Filename.EXE in EQBCS_Path Location, Also no Ending \ on Path ex; C:\MQ2
@ECHO.;~[ EQBCS_Application= This is the EQBCS File to be loaded.
@ECHO.EQBCS=0
@ECHO.EQBCS_Path=E:\Games\Sony\Release_ROF2
@ECHO.EQBCS_Application=EQBCServer.exe
@ECHO.
@ECHO.;~[ Options are 1 = ON or 0 = OFF ^(IF MQ2 Open will not Try to Open Another.^) ^(Default: 0^)
@ECHO.;~[ Path Do not include Filename.EXE in MQ2_Path Location, Also no Ending \ on Path ex; C:\MQ2
@ECHO.;~[ MQ2_Application= This is the MQ2 File to be loaded.
@ECHO.MQ2=0
@ECHO.MQ2_Path=E:\Games\Sony\Release_ROF2
@ECHO.MQ2_Application=MacroQuest2.exe
@ECHO.
@ECHO.;~[ Options are EQ or WinEQ2 ^(Default: EQ^)
@ECHO.;~[ Options EQ= Loads each client directly without WinEQ2
@ECHO.;~[ Options WinEQ2= Uses WinEQ2 Profiles Names to load each client.
@ECHO.;~[ Path Do not include Filename.EXE just a PATH Location, Also no Ending \ on Path ex; C:\EQ_PEQ
@ECHO.;~[ EQ_Game_Path= This is the Path to EQGame.exe File to be loaded.
@ECHO.;~[ EQ_WINEQ2_Path= This is the Path to WinEQ2.exe File to be loaded.
@ECHO.EQLoadType=EQ
@ECHO.EQ_Game_Path=E:\Games\Sony\EverQuest_rof2Steam
@ECHO.EQ_WINEQ2_Path=E:\Games\Sony\WinEQ2_PEQ
@ECHO.
@ECHO.
@ECHO.;~[ User Name used to Login ^(Can Add Unlimited Amount of Account Logins^)
@ECHO.;~[ Set using Following Format.   Account_*_Login=AccountLogin:AccountDescription    e.x; Account_1_Login=PeQAccount:Group1-Enchanter
@ECHO.;~[ LoginTeam= This will Load all "Account_*_Login" from [ANYNAME] to [ANYNAME].
@ECHO.;~[ Batch will Skip Blank =
@ECHO.[LoginAccounts]
@ECHO.LoginTeam=TEAM1
@ECHO.
@ECHO.
@ECHO.;~[ TEAM1 Can be any Custom name you would like to use. Just Place it in ^(LoginTeam=^) Above to Load that [GROUP].
@ECHO.;~[ Can also Create More Sets of Groups by Creating e.x; [TEAM2], Add "Account_*_Login=" Changing * From 1 TO Amount of Characters to load.
@ECHO.[TEAM1]
@ECHO.;~[ Group #1
@ECHO.Account_1_Login=Blank_AccountLogin:Group1 [Account Description]
@ECHO.Account_2_Login=Blank_AccountLogin:Group1 [Account Description]
@ECHO.Account_3_Login=Blank_AccountLogin:Group1 [Account Description]
@ECHO.Account_4_Login=Blank_AccountLogin:Group1 [Account Description]
@ECHO.Account_5_Login=Blank_AccountLogin:Group1 [Account Description]
@ECHO.Account_6_Login=Blank_AccountLogin:Group1 [Account Description]
@ECHO.;~[ Group #2
@ECHO.Account_7_Login=Blank_AccountLogin:Group2 [Account Description]
@ECHO.Account_8_Login=Blank_AccountLogin:Group2 [Account Description]
@ECHO.Account_9_Login=Blank_AccountLogin:Group2 [Account Description]
@ECHO.Account_10_Login=Blank_AccountLogin:Group2 [Account Description]
@ECHO.Account_11_Login=Blank_AccountLogin:Group2 [Account Description]
@ECHO.Account_12_Login=Blank_AccountLogin:Group2 [Account Description]
@ECHO.;~[ Group #3
@ECHO.Account_13_Login=Blank_AccountLogin:Group3 [Account Description]
@ECHO.Account_14_Login=Blank_AccountLogin:Group3 [Account Description]
@ECHO.Account_15_Login=Blank_AccountLogin:Group3 [Account Description]
@ECHO.Account_16_Login=Blank_AccountLogin:Group3 [Account Description]
@ECHO.Account_17_Login=Blank_AccountLogin:Group3 [Account Description]
@ECHO.Account_18_Login=Blank_AccountLogin:Group3 [Account Description]
@ECHO.;~[ Group #4
@ECHO.Account_19_Login=Blank_AccountLogin:Group4 [Account Description]
@ECHO.Account_20_Login=Blank_AccountLogin:Group4 [Account Description]
@ECHO.Account_21_Login=Blank_AccountLogin:Group4 [Account Description]
@ECHO.Account_22_Login=Blank_AccountLogin:Group4 [Account Description]
@ECHO.Account_23_Login=Blank_AccountLogin:Group4 [Account Description]
@ECHO.Account_24_Login=Blank_AccountLogin:Group4 [Account Description]
@ECHO.;~[ Group #5
@ECHO.Account_25_Login=Blank_AccountLogin:Group5 [Account Description]
@ECHO.Account_26_Login=Blank_AccountLogin:Group5 [Account Description]
@ECHO.Account_27_Login=Blank_AccountLogin:Group5 [Account Description]
@ECHO.Account_28_Login=Blank_AccountLogin:Group5 [Account Description]
@ECHO.Account_29_Login=Blank_AccountLogin:Group5 [Account Description]
@ECHO.Account_30_Login=Blank_AccountLogin:Group5 [Account Description]
@ECHO.;~[ Group #6
@ECHO.Account_31_Login=Blank_AccountLogin:Group6 [Account Description]
@ECHO.Account_32_Login=Blank_AccountLogin:Group6 [Account Description]
@ECHO.Account_33_Login=Blank_AccountLogin:Group6 [Account Description]
@ECHO.Account_34_Login=Blank_AccountLogin:Group6 [Account Description]
@ECHO.Account_35_Login=Blank_AccountLogin:Group6 [Account Description]
@ECHO.Account_36_Login=Blank_AccountLogin:Group6 [Account Description]
@ECHO.;~[ Group #7
@ECHO.Account_37_Login=Blank_AccountLogin:Group7 [Account Description]
@ECHO.Account_38_Login=Blank_AccountLogin:Group7 [Account Description]
@ECHO.Account_39_Login=Blank_AccountLogin:Group7 [Account Description]
@ECHO.Account_40_Login=Blank_AccountLogin:Group7 [Account Description]
@ECHO.Account_41_Login=Blank_AccountLogin:Group7 [Account Description]
@ECHO.Account_42_Login=Blank_AccountLogin:Group7 [Account Description]
@ECHO.;~[ Group #8
@ECHO.Account_43_Login=Blank_AccountLogin:Group8 [Account Description]
@ECHO.Account_44_Login=Blank_AccountLogin:Group8 [Account Description]
@ECHO.Account_45_Login=Blank_AccountLogin:Group8 [Account Description]
@ECHO.Account_46_Login=Blank_AccountLogin:Group8 [Account Description]
@ECHO.Account_47_Login=Blank_AccountLogin:Group8 [Account Description]
@ECHO.Account_48_Login=Blank_AccountLogin:Group8 [Account Description]
@ECHO.;~[ Group #9
@ECHO.Account_49_Login=Blank_AccountLogin:Group9 [Account Description]
@ECHO.Account_50_Login=Blank_AccountLogin:Group9 [Account Description]
@ECHO.Account_51_Login=Blank_AccountLogin:Group9 [Account Description]
@ECHO.Account_52_Login=Blank_AccountLogin:Group9 [Account Description]
@ECHO.Account_53_Login=Blank_AccountLogin:Group9 [Account Description]
@ECHO.Account_54_Login=Blank_AccountLogin:Group9 [Account Description]
@ECHO.
@ECHO.;~[ WinEQ2 Profiles Names ^(Can Add Unlimited Amount of Profiles^)
@ECHO.;~[ Account_*_Profile= are inside your WinEQ2 Main Directory, Inside file: "WinEQ-EQ.ini", Under each [Profile*] *=Number 1-100, Where it says "Name="  That is What you Place in Account_*_Profile=
@ECHO.;~[ Must fill out below if using EQLoadType=WinEQ2
@ECHO.;~[ Batch will Skip Blank =
@ECHO.[WinEQ2Profiles]
@ECHO.WinEQ2LoginTeam=MainProfile
@ECHO.
@ECHO.
@ECHO.;~[ MainProfile Can be any Custom name you would like to use. Just Place it in ^(WinEQ2LoginTeam=^) Above to Load that [GROUP].
@ECHO.;~[ Can also Create More Sets of Groups by Creating e.x; [ANYNAME], Add "Account_*_Profile=" Changing * From 1 TO Amount of Characters to load.
@ECHO.;~[ Account_*_Profile= are inside your WinEQ2 Main Directory, Inside file: "WinEQ-EQ.ini", Under each [Profile*] *=Number 1-100, Where it says "Name="  That is What you Place in Account_*_Profile=
@ECHO.[MainProfile]
@ECHO.;~[ Group #1
@ECHO.Account_1_Profile=
@ECHO.Account_2_Profile=
@ECHO.Account_3_Profile=
@ECHO.Account_4_Profile=
@ECHO.Account_5_Profile=
@ECHO.Account_6_Profile=
@ECHO.;~[ Group #2      
@ECHO.Account_7_Profile=
@ECHO.Account_8_Profile=
@ECHO.Account_9_Profile=
@ECHO.Account_10_Profile=
@ECHO.Account_11_Profile=
@ECHO.Account_12_Profile=
@ECHO.;~[ Group #3      
@ECHO.Account_13_Profile=
@ECHO.Account_14_Profile=
@ECHO.Account_15_Profile=
@ECHO.Account_16_Profile=
@ECHO.Account_17_Profile=
@ECHO.Account_18_Profile=
@ECHO.
@ECHO.;~[ Account EQDirectory Names ^(Can Add Unlimited Amount of Directories^) One Per toon if you want.
@ECHO.;~[ EverQuest Directories Locations ^(Will Load Bots in different Directories^)
@ECHO.;~[ This allows each client to be opened in Different Directories.
@ECHO.;~[ Batch will Skip Blank =
@ECHO.[EQGameDirectory]
@ECHO.EQDirectory=MainDirectory
@ECHO.
@ECHO.
@ECHO.;~[ MainDirectory Can be any Custom name you would like to use. Just Place it in ^(EQDirectory=^) Above to Load that [GROUP].
@ECHO.;~[ Can also Create More Sets of Groups by Creating e.x; [ANYNAME], Add "Account_*_EQDirectory=" Changing * From 1 TO Amount of Characters to load.
@ECHO.;~[ Account_*_EQDirectory= This is the Path to EQGame.exe File to be loaded.
@ECHO.;~[ Do not include Filename.EXE just a PATH Location, Also no Ending \ on Path e.x; C:\EQ_PEQ
@ECHO.[MainDirectory]
@ECHO.;~[ Group #1
@ECHO.Account_1_EQDirectory=
@ECHO.Account_2_EQDirectory=
@ECHO.Account_3_EQDirectory=
@ECHO.Account_4_EQDirectory=
@ECHO.Account_5_EQDirectory=
@ECHO.Account_6_EQDirectory=
@ECHO.;~[ Group #2
@ECHO.Account_7_EQDirectory=
@ECHO.Account_8_EQDirectory=
@ECHO.Account_9_EQDirectory=
@ECHO.Account_10_EQDirectory=
@ECHO.Account_11_EQDirectory=
@ECHO.Account_12_EQDirectory=
@ECHO.;~[ Group #3                 
@ECHO.Account_13_EQDirectory=
@ECHO.Account_14_EQDirectory=
@ECHO.Account_15_EQDirectory=
@ECHO.Account_16_EQDirectory=
@ECHO.Account_17_EQDirectory=
@ECHO.Account_18_EQDirectory=
@ECHO.
) > !EQLoader_Ini!

EXIT /B
::Return