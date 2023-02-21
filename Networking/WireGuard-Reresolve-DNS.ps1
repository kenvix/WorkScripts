#requires RunAsAdministrator

# This script will re-resolve the DNS entries for all WireGuard peers.
# This is useful if you have a dynamic DNS service and want to update the DNS entries for your WireGuard peers.

# check config path arugment is present
# if ($args.count -eq 0) { Write-Host "Usage: WireGuard-Reresolve-DNS.ps1 <config path>" -ForegroundColor Red; exit 1 }

# INI parser support
function Get-IniFile 
{  
    param(  
        [parameter(Mandatory = $true)] [string] $filePath  
    )  
    
    $anonymous = "NoSection"
  
    $ini = @{}  
    switch -regex -file $filePath  
    {  
        "^\[(.+)\]$" # Section  
        {  
            $section = $matches[1]  
            $ini[$section] = @{}  
            $CommentCount = 0  
        }  

        "^(;.*)$" # Comment  
        {  
            if (!($section))  
            {  
                $section = $anonymous  
                $ini[$section] = @{}  
            }  
            $value = $matches[1]  
            $CommentCount = $CommentCount + 1  
            $name = "Comment" + $CommentCount  
            $ini[$section][$name] = $value  
        }   

        "(.+?)\s*=\s*(.*)" # Key  
        {  
            if (!($section))  
            {  
                $section = $anonymous  
                $ini[$section] = @{}  
            }  
            $name,$value = $matches[1..2]  
            $ini[$section][$name] = $value  
        }  
    }  

    return $ini  
}

function WireGuard-Reresolve-DNS($InterfaceName, $ConfigPath, $DNSServer = $null, $LoopDelay = 0)
{
    $config = Get-IniFile $ConfigPath
    $privateKey = $config.Interface.PrivateKey
    $endpoint = $config.Peer.Endpoint 
    $publicKey = $config.Peer.PublicKey

    do 
    {
        try 
        {
            # Resolve the DNS entry for the endpoint
            $dnsQueryRet = Resolve-DnsName -Name $endpoint -DnsOnly -Server $DNSServer
            if ($dnsQueryRet -eq $null) { 
                Write-Host "Failed to resolve DNS for $endpoint" -ForegroundColor Red;
            }
        } 
        catch(Exception) 
        {
            
        }
    } while ($LoopDelay -gt 0)

}

# Get the WireGuard config file
