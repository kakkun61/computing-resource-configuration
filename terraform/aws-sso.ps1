function Set-AwsSsoEnv {
    param (
        [string] $ProfileName = "terraform"
    )

    $credentialLines = aws configure export-credentials --profile $ProfileName --format env-no-export
    if (-not $credentialLines) {
        throw "Failed to export AWS credentials for profile: $ProfileName"
    }

    foreach ($line in $credentialLines) {
        if ($line -match '^(AWS_\w+)=(.+)$') {
            Set-Item -Path ("Env:" + $matches[1]) -Value $matches[2]
        }
    }

    Remove-Item Env:AWS_PROFILE -ErrorAction SilentlyContinue

    aws sts get-caller-identity | Out-Null
    Write-Output "AWS credentials loaded for profile: $ProfileName"
}
