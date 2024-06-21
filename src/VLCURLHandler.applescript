on open location this_URL
	set AppleScript's text item delimiters to "://"
	set urlParts to text items of this_URL
	set vlcArgs to item 2 of urlParts
	
	set appPath to path to me
	set bashScriptPath to (appPath as text) & "Contents:Resources:vlc_handler.sh"
	set bashScriptPath to POSIX path of bashScriptPath
	
	set shellCommand to quoted form of bashScriptPath & " " & quoted form of vlcArgs
	
	try
		set vlcCommand to do shell script shellCommand
		
		-- Launch VLC using the command from the shell script
		do shell script vlcCommand & " > /dev/null 2>&1 & sleep 1 && osascript -e 'tell application \"VLC\" to activate'"
		
	on error errMsg
		display dialog "Error: " & errMsg buttons {"OK"} default button "OK" with icon caution
	end try
end open location

on run
	display dialog "This app is designed to handle VLC URL schemes."
end run