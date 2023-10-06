#requires -RunAsAdministrator

param(
    [Parameter(Mandatory=$true)]
    [String] $Interface
)

$DisabledInterfaces = (Get-NetFirewallProfile -Profile Private).DisabledInterfaceAliases

if ($DisabledInterfaces -notcontains $Interface) {
    $DisabledInterfaces += $Interface
    Set-NetFirewallProfile -Profile Private -DisabledInterfaceAliases $DisabledInterfaces
    Set-NetConnectionProfile -InterfaceAlias $Interface -NetworkCategory Private
}