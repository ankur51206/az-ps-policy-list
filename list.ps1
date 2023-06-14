function email_error() {
    param(
        $err1,
        $emailFrom,
        $emailTo,
        $emailSubject,
        $smtpServer,
        $smtpPort,
        $smtpUsername,
        $smtpPassword
    )

    # Default email body
    $emailBody = @"
        <html>
        <body>
            <h2>Policy Assignment Data</h2>
            <table cellpadding='5' cellspacing='0' border='1'>
                <tr>
                    <th>Display Name</th>
                    <th>Assignment Scope</th>
                    <th>Description</th>
                    <th>Excluded Scopes</th>
                </tr>
                $err1
            </table>
        </body>
        </html>
"@

    # Send the email
    Send-MailMessage -From $emailFrom -To $emailTo -Subject $emailSubject -Body $emailBody -BodyAsHtml -SmtpServer $smtpServer -Port $smtpPort -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $smtpUsername, (ConvertTo-SecureString -String $smtpPassword -AsPlainText -Force))
}

# Email details
$EmailFrom = "hello@abc.com"
$EmailTo = "ankur51206@gmail.com"
$EmailSubject = "Policy Assignment Report"
$SMTPServer = "smtp.sendgrid.net"
$SMTPPort = 587
$SMTPUsername = "apikey"
$SMTPPassword = "smtppasshere"

$policyAssignments = az policy assignment list --query "[?contains(displayName, 'Testing')]" --output json | ConvertFrom-Json

# Create empty array to store policy assignment data
$policyAssignmentData = @()
$message = ""

# Loop through each policy assignment and extract the relevant data
foreach ($assignment in $policyAssignments) {
    $displayName = $assignment.displayName
    $assignmentScope = $assignment.scope
    $description = $assignment.description
    $excludedScopes = $assignment.excludedScopes

    # Add the policy assignment data to the array
    $policyAssignmentData += [PSCustomObject]@{
        DisplayName = $displayName
        AssignmentScope = $assignmentScope
        Description = $description
        ExcludedScopes = $excludedScopes 
    }

    # Append the data to the email message
    $message += @"
        <tr>
            <td>$displayName</td>
            <td>$assignmentScope</td>
            <td>$description</td>
            <td>$excludedScopes</td>
        </tr>
"@
}

# Call the email_error function with the email details
email_error -err1 $message -emailFrom $EmailFrom -emailTo $EmailTo -emailSubject $EmailSubject -smtpServer $SMTPServer -smtpPort $SMTPPort -smtpUsername $SMTPUsername -smtpPassword $SMTPPassword
