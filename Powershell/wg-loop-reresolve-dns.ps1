$services = Get-Service -Name "WireGuardTunnel$*"
$tunnelNames = $services.Name.Substring(16)
Get-Service -Name "WireGuardTunnel$*" | ForEach-Object { $_.Name.Substring(16) }

Get-Service -Name "WireGuardTunnel$*" | Where-Object {$_.Status -eq "Running"} | ForEach-Object { $_.Name.Substring(16) } | ForEach-Object { Get-ChildItem -File "$env:programfiles\wireguard\data\configurations\$_.conf.dpapi" } | ForEach-Object {& .\wg-reresolve-dns.ps1 $_.FullName}