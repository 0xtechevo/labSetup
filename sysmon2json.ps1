param(
    [string]$inputFilePath = "C:\Input\sysmon.xml",
    [string]$outputFilePath = "C:\Output\sysmon.json"
)

# Debug Logging Function
function Log-Debug {
    param([string]$message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Write-Host "$timestamp - DEBUG: $message"
}

try {
    # Loading the Sysmon XML file
    Log-Debug "Loading Sysmon XML file from $inputFilePath"
    [xml]$sysmonData = Get-Content $inputFilePath
    Log-Debug "Sysmon data loaded successfully."

    # Extracting relevant properties
    $events = @()
    foreach ($event in $sysmonData.Sysmon.Event) {
        $events += [pscustomobject]@{
            Timestamp = $event.TimeCreated.SystemTime
            EventID = $event.EventID
            ProcessName = $event.ProcessName
            User = $event.User
            Image = $event.Image
            # Add more properties as needed
        }
    }
    Log-Debug "Property extraction completed. Found $($events.Count) events."

    # Converting to JSON
    $jsonOutput = $events | ConvertTo-Json -Depth 10
    Log-Debug "JSON conversion completed."

    # Writing to output file
    Set-Content -Path $outputFilePath -Value $jsonOutput
    Log-Debug "Output written to $outputFilePath successfully."
} catch {
    Log-Debug "An error occurred: $_"
    throw
}
