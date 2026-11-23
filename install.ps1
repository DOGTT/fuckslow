$ErrorActionPreference = "Stop"

$Repo = if ($env:FUCKSLOW_REPO) { $env:FUCKSLOW_REPO } else { "DOGTT/fuckslow" }
$Branch = if ($env:FUCKSLOW_BRANCH) { $env:FUCKSLOW_BRANCH } else { "main" }
$InstallDir = Join-Path $env:LOCALAPPDATA "Programs\fuckslow"
$TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("fuckslow-" + [guid]::NewGuid())
$LocalSource = $PSScriptRoot
$SourceDir = $null
$PythonExe = $null
$PythonPrefix = @()

try {
    if (Get-Command python -ErrorAction SilentlyContinue) {
        $PythonExe = "python"
    } elseif (Get-Command py -ErrorAction SilentlyContinue) {
        $PythonExe = "py"
        $PythonPrefix = @("-3")
    } else {
        throw "fuckslow needs Python 3.10+. Install Python and rerun this command."
    }

    $Version = & $PythonExe @PythonPrefix -c "import sys; print('%d.%d' % sys.version_info[:2])"
    if ($LASTEXITCODE -ne 0 -or [version]$Version -lt [version]"3.10") {
        throw "fuckslow needs Python 3.10 or later."
    }

    if ($LocalSource -and (Test-Path (Join-Path $LocalSource "fuckslow"))) {
        $SourceDir = $LocalSource
    } else {
        New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
        $Archive = Join-Path $TempDir "source.zip"
        $Url = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"
        Write-Host "Downloading $Repo ($Branch)…"
        Invoke-WebRequest -Uri $Url -OutFile $Archive
        Expand-Archive -Path $Archive -DestinationPath $TempDir
        $SourceDir = Get-ChildItem -Path $TempDir -Directory | Select-Object -First 1 -ExpandProperty FullName
    }

    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    Copy-Item (Join-Path $SourceDir "fuckslow") (Join-Path $InstallDir "fuckslow") -Force
    Copy-Item (Join-Path $SourceDir "fuckslow.cmd") (Join-Path $InstallDir "fuckslow.cmd") -Force
    & $PythonExe @PythonPrefix -m venv (Join-Path $InstallDir ".venv")
    if ($LASTEXITCODE -ne 0) { throw "Could not create the Python virtual environment." }

    $VenvPython = Join-Path $InstallDir ".venv\Scripts\python.exe"
    & $VenvPython -m pip install --disable-pip-version-check "psutil>=6,<8"
    if ($LASTEXITCODE -ne 0) { throw "Could not install psutil." }

    $CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $PathEntries = @($CurrentPath -split ";" | Where-Object { $_ })
    if ($PathEntries -notcontains $InstallDir) {
        [Environment]::SetEnvironmentVariable("Path", (($PathEntries + $InstallDir) -join ";"), "User")
    }

    Write-Host "Installed fuckslow in $InstallDir"
    Write-Host "Open a new terminal, then run: fuckslow"
} finally {
    if (Test-Path $TempDir) {
        Remove-Item -Path $TempDir -Recurse -Force
    }
}
