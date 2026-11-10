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
    . (Join-Path $PSScriptRoot 'close_exact_tool_for_build.ps1')
    Close-ExactToolForBuild -ExecutablePath (Join-Path $repoRoot 'build\SerialToCanIspToolMfc.exe')
}

$msbuild = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
if (-not (Test-Path $msbuild)) {
    $msbuild = "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
}
if (-not (Test-Path $msbuild)) {
    $msbuild = "msbuild"
}

# MSBuild PreBuild owns the single version allocation.

Write-Host "Building $sln ($Configuration|$Platform)"
& $msbuild $sln /t:Build /p:Configuration=$Configuration /p:Platform=$Platform /m
if ($LASTEXITCODE -ne 0) {
    throw "Build failed."
}

Write-Host "Build success. Output: $toolExe"
