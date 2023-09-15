# Copyright (C) 2021 Max Schulze. All Rights Reserved.
# near-literal Translation of the linux version by Jason A. Donenfeld

# to decrypt the dpapi Credentials, you have to be the same user as the wireguard tunnel service, i.e. "nt authority\system", check with "whoami"
# this script might be called by task scheduler as 
#  powershell -NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -Command "Get-ChildItem -File 'c:\Program Files\wireguard\data\configurations\*.dpapi' | foreach {& C:\<path to script>\wireguard_reresolve-dns.ps1 $_.FullName}"
# if you want to try it in cmd, remember to elevate the user, i.e. with psexec from sysutils
#  psexec -s -i powershell -NoPr...

Set-StrictMode -Version 3
Add-Type -AssemblyName System.Security

Set-Variable CONFIG_FILE -Value $args[0].ToString().Trim('"')

$byteCrypted = ((Get-Content -LiteralPath $CONFIG_FILE -Encoding Byte -ReadCount 0))

$config = [System.Security.Cryptography.ProtectedData]::Unprotect($byteCrypted,$null,[System.Security.Cryptography.DataProtectionScope]::LocalMachine)

$config = [System.Text.UTF8Encoding]::UTF8.GetString($config)

Set-Variable Interface -Option Constant -Value $(if ($CONFIG_FILE -match '.?([a-zA-Z0-9_=+.-]{1,18})\.conf.dpapi$') { $matches[1] } else { $null })

function process_peer () {
  if (-not $PEER_SECTION -or ($PUBLIC_KEY -eq $null) -or ($ENDPOINT -eq $null)) { return }
  if (-not ((& wg show "$INTERFACE" latest-handshakes) -replace $PUBLIC_KEY -match ('[0-9]+'))) { return }
  if (((Get-Date) - (New-Object -Type DateTime -ArgumentList 1970,1,1,0,0,0,0).AddSeconds($matches[0]).ToLocalTime()).TotalSeconds -le 135) { return }
  (& wg set "$INTERFACE" peer "$PUBLIC_KEY" endpoint "$ENDPOINT")
  reset_peer_section
}

function reset_peer_section () {
  Set-Variable PEER_SECTION -Value $null
  Set-Variable PUBLIC_KEY -Value $null
  Set-Variable ENDPOINT -Value $null
}

reset_peer_section
Set-Variable PEER_SECTION -Value $null

foreach ($line in $config.Split([Environment]::NewLine,[StringSplitOptions]::RemoveEmptyEntries)) 
{
  if ($line.Trim().length -gt 0) {
    $stripped = $line.Trim() -ireplace '\#.*'
    $key = $stripped -ireplace '=.*'; $key = $key.Trim()
    $val = $stripped -ireplace '^.*?='; $val = $val.Trim()
    if ($key -match '\[.*') { process_peer; reset_peer_section; }
    if ($key -eq '[Peer]') { $PEER_SECTION = $true }
    if ($PEER_SECTION) {
      switch ($key) {
        "PublicKey" { $PUBLIC_KEY = $val; continue; }
        "Endpoint" { $ENDPOINT = $val; continue; }
      }
    }
  }
}
process_peer
