param(
    [string]$OutputDir = "C:\BackupSQL\_emails",
    [string]$ComputerName = $env:COMPUTERNAME
)

function Get-ThunderbirdEmails {
    $result = @()
    $appdata = [Environment]::GetFolderPath("ApplicationData")
    $tbDir = Join-Path $appdata "Thunderbird"
    $profilesIni = Join-Path $tbDir "profiles.ini"
    if (-not (Test-Path $profilesIni)) { return $result }
    $profilePaths = @()
    Get-Content $profilesIni | ForEach-Object {
        if ($_ -match '^Path=(.+)$') { $profilePaths += $Matches[1] }
    }
    foreach ($relPath in $profilePaths) {
        $profileDir = Join-Path $tbDir $relPath
        $prefsJs = Join-Path $profileDir "prefs.js"
        if (-not (Test-Path $prefsJs)) { continue }
        $lines = Get-Content $prefsJs
        foreach ($line in $lines) {
            if ($line -match 'mail\.identity\.\d+\.useremail') {
                $parts = $line -split '"'
                if ($parts.Count -ge 4) {
                    $email = $parts[3]
                    if ($email -match '@') { $result += $email }
                }
            }
        }
    }
    return ($result | Select-Object -Unique)
}

function Get-LiveMailEmails {
    $result = @()
    $regPath = "HKCU:\Software\Microsoft\Windows Live Mail\Accounts"
    if (Test-Path $regPath) {
        Get-ChildItem $regPath -ErrorAction SilentlyContinue | ForEach-Object {
            $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
            if ($props.EmailAddress) { $result += $props.EmailAddress }
        }
    }
    $localAppData = [Environment]::GetFolderPath("LocalApplicationData")
    $wlDir = Join-Path $localAppData "Windows Live Mail"
    if (Test-Path $wlDir) {
        Get-ChildItem "$wlDir\*.windows-live-mail\*.account" -ErrorAction SilentlyContinue | ForEach-Object {
            $content = Get-Content $_.FullName -Raw
            if ($content -match 'EmailAddress\s*=\s*"([^"]+)"') { $result += $Matches[1] }
        }
    }
    return ($result | Select-Object -Unique)
}

function Get-OutlookEmails {
    $result = @()
    $regPaths = @(
        "HKCU:\Software\Microsoft\Office\16.0\Outlook\Profiles",
        "HKCU:\Software\Microsoft\Office\15.0\Outlook\Profiles",
        "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles"
    )
    foreach ($rp in $regPaths) {
        if (Test-Path $rp) {
            Get-ChildItem $rp -ErrorAction SilentlyContinue | ForEach-Object {
                $profileName = $_.PSChildName
                Get-ChildItem "$rp\$profileName\*" -ErrorAction SilentlyContinue | ForEach-Object {
                    $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
                    if ($props.Email) { $result += $props.Email }
                }
            }
        }
    }
    return ($result | Select-Object -Unique)
}

function Get-IPAddress {
    try {
        $ip = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet*","Wi-Fi*" -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -ne "127.0.0.1" } | Select-Object -First 1).IPAddress
        if ($ip) { return $ip }
    } catch {}
    return "0.0.0.0"
}

$ip = Get-IPAddress
$tbEmails = Get-ThunderbirdEmails
$wlEmails = Get-LiveMailEmails
$olEmails = Get-OutlookEmails
$allEmails = @($tbEmails + $wlEmails + $olEmails) | Select-Object -Unique

$result = @{
    time = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    computer = $ComputerName
    host = $ip
    thunderbird = @($tbEmails)
    live_mail = @($wlEmails)
    outlook = @($olEmails)
    emails = @($allEmails)
}

if (-not (Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null }
$outputFile = Join-Path $OutputDir "$ComputerName.json"
$result | ConvertTo-Json -Compress | Set-Content $outputFile -Encoding UTF8
Write-Output ($result | ConvertTo-Json -Compress)
