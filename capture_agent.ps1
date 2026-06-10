param($Port = 5986, $Prefix = "/capture", $Secret = "Until1987")

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:$Port$Prefix/")
$listener.Start()

while ($listener.IsListening) {
  try {
    $ctx = $listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response

    if ($req.Url.AbsolutePath -eq "$Prefix/health") {
      $buffer = [System.Text.Encoding]::UTF8.GetBytes("OK")
      $res.ContentType = "text/plain"
      $res.OutputStream.Write($buffer, 0, $buffer.Length)
      $res.Close()
      continue
    }

    if ($req.Url.AbsolutePath -ne "$Prefix/api/v1/metrics") {
      $res.StatusCode = 404; $res.Close(); continue
    }

    $auth = $req.Headers["Authorization"]
    if ($auth -ne "Bearer $Secret" -and $req.QueryString["secret"] -ne $Secret) {
      $res.StatusCode = 401; $res.Close(); continue
    }

    $disks = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 } | ForEach-Object {
      @{mount = $_.Name + ":\"; total = [math]::Round($_.Used + $_.Free); used = [math]::Round($_.Used); available = [math]::Round($_.Free); usedPercent = [math]::Round(($_.Used / ($_.Used + $_.Free)) * 100, 1)}
    }

    $cpu = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average

    $os = Get-CimInstance Win32_OperatingSystem
    $memTotal = [math]::Round($os.TotalVisibleMemorySize * 1024)
    $memFree = [math]::Round($os.FreePhysicalMemory * 1024)
    $memUsed = $memTotal - $memFree

    $metrics = @{
      hostname = $env:COMPUTERNAME
      platform = "windows"
      disks = @($disks)
      cpu = @{cores = (Get-CimInstance Win32_Processor).Count; percentUsed = [math]::Round($cpu, 1)}
      memory = @{total = $memTotal; used = $memUsed; available = $memFree; usedPercent = [math]::Round(($memUsed / $memTotal) * 100, 1)}
      timestamp = (Get-Date -Format "o")
    }

    $json = $metrics | ConvertTo-Json -Compress
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
    $res.ContentType = "application/json"
    $res.OutputStream.Write($buffer, 0, $buffer.Length)
  } catch { Write-Host "Error: $_" } finally {
    try { $res.Close() } catch {}
  }
}
