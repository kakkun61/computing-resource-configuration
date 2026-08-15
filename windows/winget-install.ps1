param(
    [switch]$Force,
    [switch]$Verbose
)

$ErrorActionPreference = 'Stop'

$packages =
    Get-ChildItem -Path (Join-Path $PSScriptRoot '*/winget') -File |
    Get-Content |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and -not $_.StartsWith('#') }

if ($Verbose) {
    Write-Host "検出したパッケージ: $($packages -join ' ')"
}

$option = @()
if ($Force) {
    $option += '--force'
}
$option += '--exact'
$option += $packages

if ($Verbose) {
    Write-Host "実行するコマンド: winget install $option"
}

winget install $option
