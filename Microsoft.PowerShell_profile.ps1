function prompt {
	# Report errors with a [!].
	If (-not ${?}) {
		Write-Host -NoNewline -ForegroundColor Red "[!]"
	}
	
	# Execution time
	$LastCommand = Get-History -Count 1
	If (${LastCommand}) { $RunTime = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime).TotalSeconds }
	If (${RunTime}) {
		Switch(${RunTime}) {
			{$_ -le 1} {
				$RunTimeForegroundColor = "Blue"
			}
			{$_ -le 60 -And $_ -gt 1} {
				$RunTimeForegroundColor = "Yellow"
			}
			{$_ -ge 61} {
				$RunTimeForegroundColor = "Red"
			}
		}
		$RunTime = [math]::Round((${RunTime}), 3)
		Write-Host -NoNewline -ForegroundColor ${RunTimeForegroundColor} "[${RunTime}]"
	}
    
	# User
	$IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
	If (${IsAdmin}) {$UserForegroundColor = "Red"} Else {$UserForegroundColor = "Green"}
	$CmdPromptUser = $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name).Split("\")[1]
	Write-Host -NoNewline -ForegroundColor ${UserForegroundColor} ${CmdPromptUser}
	
	# @
	Write-Host -NoNewline -ForegroundColor Gray "@"
	
	# Machine
	$CmdPromptMachine = $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name).Split("\")[0].ToLower()
	Write-Host -NoNewline -ForegroundColor Green ${CmdPromptMachine}
	
	# :
	Write-Host -NoNewline -ForegroundColor Gray ":"
	
	# Current path
	$CurrentConsolePath = "${PWD}".Replace(${HOME}, '~').Replace('\','/')
	Write-Host -NoNewline -ForegroundColor Yellow ${CurrentConsolePath}
    
	# \n
	return "$ "
}
