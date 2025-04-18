# Startup Banner
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host "  AD Enable/Disable Audit Policy by Alejandro Leon AKA GX-OPTI" -ForegroundColor Yellow 
Write-Host "  Enables or Disables Audit Policies for the ADDS service" -ForegroundColor Cyan 
Write-Host "=============================================================`n" -ForegroundColor Cyan

# Define log file path
$logPath = "$PSScriptRoot\AuditPolicyChanges.log"

# Function to write log entries
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logPath -Append -Encoding utf8
}

# Function to check and enable/disable audit policies with user input and logging
function Check-EnableAuditPolicy {
    param (
        [string]$subcategoryGUID,
        [string]$auditName
    )

    $auditpolStatus = auditpol /get /subcategory:$subcategoryGUID

    if ($auditpolStatus -match "Success and Failure") {
        Write-Host "The audit policy '$auditName' is currently ENABLED." -ForegroundColor Green
        $response = Read-Host "Would you like to disable it? (Y/N)"
        if ($response -match "^[Yy]$") {
            try {
                auditpol /set /subcategory:$subcategoryGUID /success:disable /failure:disable | Out-Null
                Write-Host "The audit policy '$auditName' has been DISABLED." -ForegroundColor Red
                Write-Log "DISABLED: $auditName"
            } catch {
                Write-Host "An error occurred while disabling '$auditName': $_" -ForegroundColor Red
                Write-Log "ERROR disabling '$auditName': $_"
            }
        } else {
            Write-Host "The audit policy '$auditName' remains ENABLED." -ForegroundColor Green
            Write-Log "UNCHANGED: $auditName remains ENABLED"
        }
    } else {
        Write-Host "The audit policy '$auditName' is currently DISABLED." -ForegroundColor Red
        $response = Read-Host "Would you like to enable it? (Y/N)"
        if ($response -match "^[Yy]$") {
            try {
                auditpol /set /subcategory:$subcategoryGUID /success:enable /failure:enable | Out-Null
                Write-Host "The audit policy '$auditName' has been ENABLED." -ForegroundColor Green
                Write-Log "ENABLED: $auditName"
            } catch {
                Write-Host "An error occurred while enabling '$auditName': $_" -ForegroundColor Red
                Write-Log "ERROR enabling '$auditName': $_"
            }
        } else {
            Write-Host "The audit policy '$auditName' remains DISABLED." -ForegroundColor Red
            Write-Log "UNCHANGED: $auditName remains DISABLED"
        }
    }
}

# Array of audit policies with their GUIDs
$auditPolicies = @(
    @{GUID="{0CCE923F-69AE-11D9-BED3-505054503030}"; Name="Audit Directory Service Changes"},
    @{GUID="{0CCE9240-69AE-11D9-BED3-505054503030}"; Name="Audit Account Management"},
    @{GUID="{0CCE923D-69AE-11D9-BED3-505054503030}"; Name="Audit Object Access"},
    @{GUID="{0CCE923C-69AE-11D9-BED3-505054503030}"; Name="Audit Logon"},
    @{GUID="{0CCE9241-69AE-11D9-BED3-505054503030}"; Name="Audit Policy Change"},
    @{GUID="{0CCE9242-69AE-11D9-BED3-505054503030}"; Name="Audit Privilege Use"},
    @{GUID="{0CCE923E-69AE-11D9-BED3-505054503030}"; Name="Audit Directory Service Access"}
)

# Loop through each policy
foreach ($policy in $auditPolicies) {
    Check-EnableAuditPolicy -subcategoryGUID $policy.GUID -auditName $policy.Name
    Write-Host "`n---------------------------------------------`n"
}

Write-Host "All policies have been reviewed. Changes are logged in: $logPath" -ForegroundColor Cyan
