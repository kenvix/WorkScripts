#Requires -RunAsAdministrator

$ifName = "wg_server" # 修改为网卡名称

function Get-IfIndex() {
    return (Get-NetAdapter | Where -Property Status -eq 'Up' | Where -Property Name -Like $ifName | select -ExpandProperty ifIndex -first 1)
}

$ifIndex = Get-IfIndex

while ( $ifIndex -eq $null -Or $ifIndex  -eq "" ) {
    echo "Waiting interface $ifName up ..."
    sleep 3s   
    $ifIndex = Get-IfIndex
}

echo "$ifName Interface index is $ifIndex"
echo "Setting up IpAddr"
New-NetIPAddress -IPAddress 172.22.0.1 -PrefixLength 24 -InterfaceIndex $ifIndex
exit 0