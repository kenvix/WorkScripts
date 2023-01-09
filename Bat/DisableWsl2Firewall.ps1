#Requires -RunAsAdministrator

Set-NetFirewallProfile -Profile Private -DisabledInterfaceAliases "vEthernet (WSL)"
Set-NetFirewallProfile -Profile Public -DisabledInterfaceAliases "vEthernet (WSL)"
Set-NetConnectionProfile -InterfaceAlias "vEthernet (WSL)" -NetworkCategory Private