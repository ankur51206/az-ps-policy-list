$assignmentName = "ASC Default" # Specify the assignment name you want to filter

$policyAssignments = az policy assignment list --output json | ConvertFrom-Json
$filteredAssignments = $policyAssignments | Where-Object { $_.displayName -match $assignmentName }

$formattedAssignments = if ($filteredAssignments) {
    $filteredAssignments
} else {
    [PSCustomObject]@{
        displayName = "N/A"
        description = "N/A"
        scope = "N/A"
        enforcementMode = "N/A"
        excludedScopes = "N/A"
    }
}

$headers = "DisplayName", "Description", "Scope", "EnforcementMode", "ExcludedScopes"
$tableRows = $formattedAssignments | ForEach-Object {
    [PSCustomObject]@{
        DisplayName = $_.displayName ?? "N/A"
        Description = $_.description ?? "N/A"
        Scope = $_.scope ?? "N/A"
        EnforcementMode = $_.enforcementMode ?? "N/A"
        ExcludedScopes = $_.excludedScopes ?? "N/A"
    }
}

$table = $tableRows | Format-Table -AutoSize | Out-String
Write-Output $table
