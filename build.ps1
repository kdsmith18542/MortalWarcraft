# Mortal Warcraft Overhaul - Build Script (PowerShell)
# Usage: .\build.ps1
# Presumes azerothcore/ submodule is initialized

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ACDir = Join-Path $RepoDir "azerothcore"
$ModuleDir = Join-Path $RepoDir "modules\mod-mortal"
$BuildOut = Join-Path $ACDir "build"

Write-Host "=== Mortal Warcraft Overhaul Build ==="

if (-not (Test-Path (Join-Path $ACDir "CMakeLists.txt"))) {
    Write-Error "azerothcore/ not found. Run: git submodule update --init"
    exit 1
}

New-Item -ItemType Directory -Force -Path $BuildOut | Out-Null
Set-Location $BuildOut

# Configure with external module path
cmake .. `
    -DMODULES="$ModuleDir" `
    -DCMAKE_INSTALL_PREFIX="$RepoDir/env/dist" `
    @args

# Build
Write-Host "Building..."
cmake --build . --config Release --parallel

Write-Host "=== Build complete! ==="
Write-Host "Binaries: $BuildOut/bin/"
