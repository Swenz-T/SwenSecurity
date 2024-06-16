# Function to get all scheduled tasks
function Get-ScheduledTasks {
    $tasks = Get-ScheduledTask | ForEach-Object {
        [PSCustomObject]@{
            TaskName = $_.TaskName
            TaskPath = $_.TaskPath
            Actions  = $_.Actions
            Triggers = $_.Triggers
        }
    }
    return $tasks
}

# Function to scan for suspicious tasks
function Scan-SuspiciousTasks {
    $tasks = Get-ScheduledTasks
    $suspiciousTasks = @()

    foreach ($task in $tasks) {
        foreach ($action in $task.Actions) {
            if ($action.Execute -match 'powershell' -or $action.Execute -match 'cmd.exe') {
                if ($action.Execute -match 'powershell' -or $action.Execute -match 'PowerShell' -or $action.Execute -match 'pwsh') {
                    $suspiciousTasks += $task
                }
            }
        }
    }

    return $suspiciousTasks
}

# Function to check for obfuscation
function Check-Obfuscation {
    param (
        [string]$command
    )

    if ($command -match 'Base64' -or $command -match 'IEX' -or $command -match '[char[]]' -or $command -match '\[System.Text.Encoding\]::UTF8\.GetString' -or $command -match '\[System.Convert\]::FromBase64String' -or $command -match 'New-Object System.IO.StreamReader' -or $command -match '\[System.Reflection.Assembly\]::Load') {
        return $true
    } else {
        return $false
    }
}

# Main script
$suspiciousTasks = Scan-SuspiciousTasks

if ($suspiciousTasks.Count -eq 0) {
    Write-Output "No suspicious scheduled tasks found."
} else {
    Write-Output "Suspicious scheduled tasks found:"
    foreach ($task in $suspiciousTasks) {
        foreach ($action in $task.Actions) {
            if (Check-Obfuscation -command $action.Execute) {
                Write-Output "Obfuscated command found in scheduled task: $action.Execute"
            }
        }
        $task | Format-Table -AutoSize
    }
}

# Optional: Remove suspicious tasks (use with caution)
function Remove-SuspiciousTasks {
    param (
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]]$Tasks
    )

    foreach ($task in $Tasks) {
        $taskName = $task.TaskName
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        Write-Output "Deleted suspicious task: $taskName"
    }
}

# Uncomment to automatically remove suspicious tasks
# Remove-SuspiciousTasks -Tasks $suspiciousTasks
