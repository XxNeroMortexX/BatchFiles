<# :
:: Based on https://gist.github.com/coldnebo/1148334
:: Converted to a batch/powershell hybrid via http://www.dostips.com/forum/viewtopic.php?p=37780#p37780
@echo off
setlocal
cls
set "POWERSHELL_BAT_ARGS=%*"
if defined POWERSHELL_BAT_ARGS set "POWERSHELL_BAT_ARGS=%POWERSHELL_BAT_ARGS:"=\"%"
endlocal & powershell -NoLogo -NoProfile -Command "$_ = $input; Invoke-Expression $( '$input = $_; $_ = \"\"; $args = @( &{ $args } %POWERSHELL_BAT_ARGS% );' + [String]::Join( [char]10, $( Get-Content \"%~f0\" ) ) )"
goto :EOF
#>


# Add-Type -TypeDefinition @"
# 	using System;
# 	using System.Runtime.InteropServices;
# 	
# 	public static class Win32 {
# 		[DllImport("User32.dll", EntryPoint="SetWindowText")]
# 		public static extern int SetWindowText(IntPtr hWnd, string strTitle);
# 	}
# "@

################################################################################
# Moves and resizes the window based the broswer
#
# Arguments: $browser - the browser being moved and resized
# Returns:   None
################################################################################
#https://www.powershellgallery.com/packages/Position-ExplorerWindow/1.2.0/Content/private%5CPosition-ResizeWindow.ps1
function MyFunction {
	param (
		[Parameter(Mandatory=$True,Position=0)][int]$servername
		,
		[Parameter(Mandatory=$True,Position=1)]$envname='Odyessy'
	)
write-host "If this script were really going to do something, it would do it on $servername in the $envname environment" 

	# Add the relevant section of the Win32 API to the PowerShell session 
	# Allows windows to be moved and resized
#	Add-Type '
#		using System;
#		using System.Runtime.InteropServices;
#
#		public class Win32 { 
#			[DllImport("user32.dll")]
#			[return: MarshalAs(UnmanagedType.Bool)]
#			public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
#
#			[DllImport("user32.dll")]
#			[return: MarshalAs(UnmanagedType.Bool)]
#			public static extern bool GetClientRect(IntPtr hWnd, out RECT lpRect);
#
#			[DllImport("user32.dll")]
#			[return: MarshalAs(UnmanagedType.Bool)]
#			public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
#			
#			[DllImport("User32.dll", EntryPoint="SetWindowText")]
#			public static extern int SetWindowText(IntPtr hWnd, string strTitle);
#		}
#		
#		public struct RECT {
#				public int Left; // x position of upper-left corner
#				public int Top; // y position of upper-left corner
#				public int Right; // x position of lower-right corner
#				public int Bottom; // y position of lower-right corner
#		}
#	'
#    # $browser_path is the full path to the browser
#    # $screen_x is the horizontal location of the window on the screen
#    # $screen_y is the vertical location of the window on the screen
#    # $win_x is the width of the target window
#    # $win_y is the height of the target window
#	#powershell -executionpolicy bypass -File eqgame.ps1 "Test-Me -NewTitle 'Hello world' -Param2 12345"
	#powershell -executionpolicy bypass -File eqgame.ps1 MyFunction -ProcessId '1' -Left '2' -Top '3' -Width '4' -Height '5'
#	powershell -executionpolicy bypass -Command "& '.\eqgame.ps1' '1' '2' '3' '4' '5'"
#powershell -executionpolicy bypass -Command "& '.\eqgame.ps1' -envname 'sssss' -servername '113'
#powershell.exe -executionpolicy bypass -command ". .\eqgame.ps1; MyFunction"
#            $Game_title="EverQuest"
#            $screen_x = 0
#            $screen_y = 0
#            $win_x = 10
#            $win_y = 10
#
#
#    # Start the desired browser
#    #Start-Process $Game_path
#
#    # Wait one second until the browser is fully loaded
#    #Start-Sleep -S 1
#
#    # Find the running process where the application path matches $Game_path
#	write-host "search for [$Game_title]"
#    $Game = (Get-Process | where {$_.mainWindowTitle -eq $Game_title}).MainWindowHandle
#	write-host "[$Game], [$screen_x], [$screen_y], [$win_x], [$win_y], [$true]"
#    [Win32]::MoveWindow($Game, $screen_x, $screen_y, $win_x, $win_y, $true)
#	write-host "New Title: [$NewTitle]"
#    [Win32]::SetWindowText($Game, "$NewTitle")
	
}