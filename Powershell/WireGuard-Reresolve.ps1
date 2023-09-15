# Copyright (C) 2021 Max Schulze. All Rights Reserved.
# Modified by Kenvix <i@kenvix.com> @ 2023/9/15
# 
# near-literal Translation of the linux version by Jason A. Donenfeld

# to decrypt the dpapi Credentials, you have to be the same user as the wireguard tunnel service, i.e. "nt authority\system", check with "whoami"
# this script might be called by task scheduler as 
#  powershell -NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -Command ./WireGuard-Reresolve.ps1 -LoopRunAsCron -DelaySeconds 600
# if you want to try it in cmd, remember to elevate the user, i.e. with psexec from sysutils 
#  psexec -s -i powershell -NoPr...
#Requires -RunAsAdministrator
param(
    [switch]$LoopRunAsCron = $false,
    [int]$DelaySeconds = 600
)

Set-StrictMode -Version 3
Add-Type -AssemblyName System.Security

function WireGuard-Reresolve {
  param(
    [Parameter(Mandatory=$true)]
    [string]$File
  )
  
  Set-Variable CONFIG_FILE -Value $File.ToString().Trim('"')

  if (-not (Test-Path -Path $CONFIG_FILE)) {
    throw New-Object System.IO.FileNotFoundException("Wireguard Config $CONFIG_FILE File not found.", $CONFIG_FILE)
  }

  $byteCrypted = ((Get-Content -LiteralPath $CONFIG_FILE -Encoding Byte -ReadCount 0))

  $config = [System.Security.Cryptography.ProtectedData]::Unprotect($byteCrypted,$null,[System.Security.Cryptography.DataProtectionScope]::LocalMachine)

  $config = [System.Text.UTF8Encoding]::UTF8.GetString($config)

  Set-Variable Interface -Option Constant -Value $(if ($CONFIG_FILE -match '.?([a-zA-Z0-9_=+.-]{1,64})\.conf.dpapi$') { $matches[1] } else { $null })

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
}

function WireGuard-Reresolve-All-Active {
  Get-Service -Name "WireGuardTunnel$*" `
   | Where-Object {$_.Status -eq "Running"} `
   | ForEach-Object { $_.Name.Substring(16) } `
   | ForEach-Object { Get-ChildItem -File "$env:programfiles\wireguard\data\configurations\$_.conf.dpapi" } `
   | ForEach-Object { WireGuard-Reresolve $_.FullName}
}

if ($LoopRunAsCron) {
  echo "Running as Cron DelaySeconds=$DelaySeconds"
  while ($true) {
    WireGuard-Reresolve-All-Active
    Start-Sleep -Seconds $DelaySeconds
  }
}