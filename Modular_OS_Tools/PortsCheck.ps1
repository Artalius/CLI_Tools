Write-Host ""
Write-Host "$(Get-Date) Checking Ports"
Write-Host ""

# Ping the target IP address
$Target = "192.168.6.15"
$PingResult = if (Test-Connection -ComputerName $Target -Count 1 -Quiet) { $true } else { $false }

# Define port numbers and protocols
$portsAndProtocols = @(
    @{ Protocol = 'FTP'; Port = 21; },
    @{ Protocol = 'SFTP'; Port = 22; },
    @{ Protocol = 'SSH'; Port = 22; },
    @{ Protocol = 'DNS'; Port = 53; },
    @{ Protocol = 'HTTP'; Port = 80; },
    @{ Protocol = 'HTTPS'; Port = 443; },
    @{ Protocol = 'CIFS'; Port = 445; },
    @{ Protocol = 'HDLC'; Port = 1025; },
    @{ Protocol = 'PS Busing'; Port = 1232; },
    @{ Protocol = 'RBS/AMPQ'; Port = 5671; },
    @{ Protocol = 'HTTP RBS'; Port = 7080; },
    @{ Protocol = 'HTTPS RBS'; Port = 7081; },
    @{ Protocol = 'AppServer'; Port = 7090; },
    @{ Protocol = 'VNC'; Port = 5900; },
    @{ Protocol = 'RDP'; Port = 3389; }
)

# Create an empty array to store results
$results = @()

Write-Host ""

# Add a row for ICMP/PING
$results += [PSCustomObject]@{
    Protocol = 'PING'
    Port = ''
    Available = $PingResult
}

# Add a blank line in table
$results += [PSCustomObject]@{
    Protocol = ''
    Port = ''
    Available = ''
}

# Loop through each port and protocol, and execute Test-NetConnection
foreach ($item in $portsAndProtocols) {
    $testResult = Test-NetConnection -Port $item.Port -ComputerName $Target -InformationLevel Quiet
    $results += [PSCustomObject]@{
        Protocol = $item.Protocol
        Port = $item.Port
        Available = $testResult
    }
}

# Display results with color
$results | Format-Table -AutoSize
