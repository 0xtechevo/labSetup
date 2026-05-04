# Output file path
$outputPath = "C:\Logs\SysmonStream.json"

# Sysmon Log Query
$queryText = "*[System[Provider[@Name='Microsoft-Windows-Sysmon']]]"
$query = [System.Diagnostics.Eventing.Reader.EventLogQuery]::new("Microsoft-Windows-Sysmon/Operational", [System.Diagnostics.Eventing.Reader.PathType]::LogName, $queryText)

# Create the watcher
$watcher = [System.Diagnostics.Eventing.Reader.EventLogWatcher]::new($query)

# Action to perform when a new event is recorded
$action = {
    $eventRecord = $eventArgs.EventRecord
    
    # Map the event to a clean object
    $logEntry = [PSCustomObject]@{
        Timestamp   = $eventRecord.TimeCreated
        EventID     = $eventRecord.Id
        Level       = $eventRecord.LevelDisplayName
        MachineName = $eventRecord.MachineName
        Message     = $eventRecord.FormatDescription()
        # Flatten event data for easy JSON parsing
        Details     = @{}
    }
    
    # Extract specific Sysmon Data fields
    foreach ($property in $eventRecord.Properties) {
        $logEntry.Details[$property.Value] = $property.Value # Simplified for example
    }

    # Append the single JSON object to the file
    $logEntry | ConvertTo-Json -Compress | Out-File -FilePath $Event.MessageData -Append -Encoding utf8
    Write-Host "New event processed: ID $($logEntry.EventID)" -ForegroundColor Gray
}

# Register the event in PowerShell
Register-ObjectEvent -InputObject $watcher -EventName "EventRecordWritten" -Action $action -MessageData $outputPath

# Start watching
$watcher.Enabled = $true

Write-Host "Monitoring Sysmon logs... Press Ctrl+C to stop." -ForegroundColor Green

# Keep the script running to maintain the watcher
try { while ($true) { Start-Sleep -Seconds 1 } }
finally {
    $watcher.Enabled = $false
    Unregister-Event -SourceIdentifier "WriteWinEventsToTempFile"
}

