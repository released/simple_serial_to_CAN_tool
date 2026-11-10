function Close-ExactToolForBuild {
    param([Parameter(Mandatory=$true)][string]$ExecutablePath)
    $expected=[IO.Path]::GetFullPath($ExecutablePath)
    $name=[IO.Path]::GetFileNameWithoutExtension($expected)
    foreach($candidate in @(Get-Process -Name $name -ErrorAction SilentlyContinue)) {
        try { $observed=$candidate.Path; $created=$candidate.StartTime; $targetPid=$candidate.Id }
        catch { continue }
        if (!$observed -or ![IO.Path]::GetFullPath($observed).Equals($expected,[StringComparison]::OrdinalIgnoreCase)) { continue }
        $current=Get-Process -Id $targetPid -ErrorAction SilentlyContinue
        if (!$current) { continue }
        if ($current.StartTime -ne $created -or !$current.Path -or
            ![IO.Path]::GetFullPath($current.Path).Equals($expected,[StringComparison]::OrdinalIgnoreCase)) {
            throw 'Build target process identity changed; no close request was sent.'
        }
        Write-Host "Closing exact build target: $expected (PID $targetPid)"
        if (!$current.CloseMainWindow() -and !$current.HasExited) { throw 'Build target is busy or has no closable window; build stopped.' }
        if (!$current.WaitForExit(45000)) { throw 'Normal close did not complete; build stopped without forced termination.' }
    }
}
