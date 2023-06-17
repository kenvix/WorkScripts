#runs an ssh instance in the background, whilst still asking for ssh authentication if needed
#attaching SMB hosts on the other side to ports previously expected via Create-Host in attachsmb.ps1
#as well as SOCKS and an RDP server
#when connected it will prompt for smb credentials and use these to hook up a number of network drives
#when done you simply hit enter in the terminal and the drives all detach and the ssh session is closed
#
#this is a hardcoded version of the example given in the generalised sshsmb script
#as you can see it's much simpler and more appropriate to use something like this if only ever using one configuration
#especially if passing around this script in an organisation (where users would really only be changing their username)

Function ConnectSMB { Param([Parameter(Mandatory=$true)]$user)
	$ssh = Start-Process -NoNewWindow -PassThru `
	ssh ("$user@middle.earth",
		'-D', '21012',
		'-L', '21112:frodo:445',
		'-L', '21212:bilbo:445',
		'-L', '21312:eyeofsauron:3389',
		'-o', 'ExitOnForwardFailure=yes',
		'-q',
	'read; kill $PPID')
	
	$tmp = $Global:ProgressPreference
	$Global:ProgressPreference = 'SilentlyContinue'
	try {
		while (!(Test-NetConnection `
			-InformationLevel Quiet `
			-ComputerName     localhost `
			-Port             21012 `
			-WarningAction    SilentlyContinue
		)) {
			if ($ssh.HasExited) {
				throw 'SSH failed to connect!'
			}
		}
	}
	finally {
		$Global:ProgressPreference = $tmp
	}
	
	try {
		$ErrorActionPreference = 'Stop'
		$cred = Get-Credential "shire\$user"
		New-PSDrive -Name H -PSPRovider FileSystem -Root "\\frodo\$user"   -Credential $cred -Persist
		New-PSDrive -Name G -PSPRovider FileSystem -Root '\\bilbo\shared$' -Credential $cred -Persist
		New-PSDrive -Name I -PSPRovider FileSystem -Root '\\frodo\dbapps$' -Credential $cred -Persist
		New-PSDrive -Name J -PSPRovider FileSystem -Root '\\frodo\joint$'  -Credential $cred -Persist
		New-PSDrive -Name P -PSPRovider FileSystem -Root '\\bilbo\public$' -Credential $cred -Persist
		'Drives connected! Press enter when done.'
		$ssh | Wait-Process
	}
	finally {
		if (!$ssh.HasExited) {
			$ssh.Kill()
		}
	}
}