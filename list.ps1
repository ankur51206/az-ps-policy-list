$policyAssignments = az policy assignment list --query "[?contains(displayNam'NSP')].[displayName, description, enforcementMode, scope, excludedScopes, parametersEffectValue]" --output json | ConvertFrom-Json

$formattedAssignments = if ($policyAssignments) {
    $policyAssignments | ForEach-Object {
        $_.displayName = $_.displayName ?? "N/A"
        $_.description = $_.description ?? "N/A"
        $_.scope = $_.scope ?? "N/A"
        $_.enforcementMode = $_.enforcementMode ?? "N/A"
        $_.excludedScopes = $_.excludedScopes ?? "N/A"
        $_
    }
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
$table = $formattedAssignments | Format-Table -Property $headers -AutoSize | Out-String
Write-Output $table
