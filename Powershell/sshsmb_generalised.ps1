#if you had created some hosts with ports like so
#Create-Host -Name 'frodo' -Ip '10.254.0.1' -Dest '127.0.0.1' -Port 21112
#Create-Host -Name 'bilbo' -Ip '10.254.0.2' -Dest '127.0.0.1' -Port 21212
#and there are some other services like RDP and SOCKS you want
#you can run this to attach an array of disks
#	@{
#		H = '\\frodo\USER'
#		G = '\\bilbo\shared$'
#		I = '\\frodo\dbapps$'
#		J = '\\frodo\joint$'
#		P = '\\bilbo\public$'
#	}.GetEnumerator() `
#	| ConnectSMB `
#		-server   middle.earth `
#		-domain   shire `
#		-account  USER `
#		-socks    21012 `
#		-forwards @{
#			21112 = 'frodo:445'
#			21212 = 'bilbo:445'
#			21312 = 'eyeofsauron:3389'
#		}

#see the hardcoded.ps1 for a discription of what the function does (that was actually written first, before I generalised it here)
Function ConnectSMB { Param(
	[Parameter(Mandatory=$true)][string]$server,
	[string]$user,
	[int]$socks,
	[Parameter(Mandatory=$true)][System.Collections.Hashtable]$forwards,
	[string]$domain,
	[string]$account,
	[Parameter(ValueFromPipeline=$true)][System.Collections.DictionaryEntry[]]$Input
)
	Begin {
		$success = @($socks)
		$ssh = Start-Process `
			-NoNewWindow `
			-PassThru `
			ssh `
			(
				$forwards.GetEnumerator() `
				| &{
					Begin {
						if ($user) {
							$server = "$user@$server"
						}
						$args = [System.Collections.ArrayList]@($server)
						if ($socks) {
							$args.AddRange(('-D',$socks))
						}
					}
					Process {
						$args.AddRange(('-L', "$($_.Key):$($_.Value)"))
						if (!$success[0]) {
							$success[0] = ($_.Value -split ':')[-1]
						}
					}
					End {
						$args.AddRange((
							'-o', 'ExitOnForwardFailure=yes',
							'-q',
							'read; kill $PPID'
						))
						$args
					}
				}
			)
		if (!$success[0]) {
			throw 'Add some forwardings'
		}
		
		$tmp = $Global:ProgressPreference
		$Global:ProgressPreference = 'SilentlyContinue'
		try {
			while (!(Test-NetConnection `
				-InformationLevel Quiet `
				-ComputerName     localhost `
				-Port             $success[0] `
				-WarningAction    SilentlyContinue
			)) {
				if ($ssh.HasExited) {
					throw 'SSH failed to connect!'
				}
			}
			
			$ErrorActionPreference = 'Stop'
			if (!$account) {
				$account = $user
			}
			if ($domain) {
				$account = "$domain\$account"
			}
			$credential = Get-Credential $account
		}
		catch {
			if (!$ssh.HasExited) {
				$ssh.Kill()
			}
			throw $_
		}
		finally {
			$Global:ProgressPreference = $tmp
		}
	}
	
	Process {
		try {
			New-PSDrive `
				-PSPRovider FileSystem `
				-Name       $_.Key `
				-Root       $_.Value `
				-Credential $credential `
				-Persist
		}
		catch {
			if (!$ssh.HasExited) {
				$ssh.Kill()
			}
			throw $_
		}
	}
	
	End {
		'Drives connected! Press enter when done.'
		$ssh | Wait-Process
	}
}