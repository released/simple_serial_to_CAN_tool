param(
    [string]$Configuration = "Release",
    [string]$Platform = "x64",
    [bool]$CloseRunningTool = $true
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$sln = Join-Path $repoRoot "SerialToCanIspToolMfc.sln"
$bumpScript = Join-Path $PSScriptRoot "bump_version.ps1"
$toolExe = Join-Path $repoRoot "build\SerialToCanIspToolMfc.exe"

if ($CloseRunningTool) {
    $running = Get-Process -Name "SerialToCanIspToolMfc" -ErrorAction SilentlyContinue
    if ($running) {
        Write-Host "Closing running SerialToCanIspToolMfc.exe before build..."
        $running | Stop-Process -Force
        Start-Sleep -Milliseconds 300
    }
}

$msbuild = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
if (-not (Test-Path $msbuild)) {
    $msbuild = "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
}
if (-not (Test-Path $msbuild)) {
    $msbuild = "msbuild"
}

if (Test-Path $bumpScript) {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $bumpScript
    if ($LASTEXITCODE -ne 0) {
        throw "Version bump failed."
    }
}

Write-Host "Building $sln ($Configuration|$Platform)"
& $msbuild $sln /t:Build /p:Configuration=$Configuration /p:Platform=$Platform /m
if ($LASTEXITCODE -ne 0) {
    throw "Build failed."
}

Write-Host "Build success. Output: $toolExe"
