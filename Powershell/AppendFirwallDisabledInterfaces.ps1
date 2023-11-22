#requires -RunAsAdministrator

param(
    [Parameter(Mandatory=$true)]
    [String] $Interface
)

# Try get lock of lock file
$LockMutex = New-Object -TypeName System.Threading.Mutex($false, "AppendFirwallDisabledInterfacesLock")
$LockMutex.WaitOne()

try {
    $DisabledInterfaces = (Get-NetFirewallProfile -Profile Private).DisabledInterfaceAliases

    if ($DisabledInterfaces -notcontains $Interface) {
        $DisabledInterfaces += $Interface
        Set-NetFirewallProfile -Profile Private -DisabledInterfaceAliases $DisabledInterfaces
        Set-NetConnectionProfile -InterfaceAlias $Interface -NetworkCategory Private
    }
} finally {
    $LockMutex.Dispose()
}