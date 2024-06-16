# SwenSecurity
# Persistence Scan Script

## Purpose

The Persistence Scan Script is designed to enhance the security posture of a system by identifying potentially malicious scheduled tasks that could be used to maintain persistence by an attacker. Scheduled tasks are a common method for attackers to ensure continued access to compromised systems even after reboots or user logoffs. This script helps system administrators and security professionals detect and remove such tasks to protect their systems from persistent threats.

## Explanation

The script performs the following key functions:

1. **Retrieve Scheduled Tasks:**
   - The `Get-ScheduledTasks` function retrieves all scheduled tasks on the system using the `Get-ScheduledTask` cmdlet. It extracts essential details such as task name, path, actions, and triggers and stores them in custom objects for further analysis.

2. **Scan for Suspicious Tasks:**
   - The `Scan-SuspiciousTasks` function scans through the retrieved scheduled tasks to identify any tasks that execute PowerShell or command prompt (`cmd.exe`) commands. Tasks that match these criteria are flagged as suspicious.

3. **Check for Obfuscation:**
   - The `Check-Obfuscation` function checks for common obfuscation techniques used in command strings, such as Base64 encoding, use of `Invoke-Expression` (`IEX`), character arrays, and various other patterns that indicate attempts to hide the true intent of the command. If such patterns are detected, the command is flagged as obfuscated.

4. **Output Results:**
   - The main script runs the scanning functions and outputs any detected suspicious tasks. It formats the output for readability and highlights commands that are obfuscated.

5. **Optional Removal of Suspicious Tasks:**
   - The `Remove-SuspiciousTasks` function provides an option to automatically remove identified suspicious tasks. This function is commented out by default to prevent accidental deletion of legitimate tasks and should be used with caution.

## Usage

To use the script, simply run it in a PowerShell session with administrative privileges. It will scan for and report any suspicious scheduled tasks on the system. If you wish to enable automatic removal of detected tasks, uncomment the relevant lines in the script.
