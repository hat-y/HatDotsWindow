# Installation Script
# This script creates symbolic links for all Windows configurations

param(
    [switch]$Force
)

$Repo = $PSScriptRoot
$ConfigDir = "$HOME\.config\hatdots-windows"

Write-Host " Installing HatDots Windows..." -ForegroundColor Green
Write-Host "Repository: $Repo" -ForegroundColor Cyan

# Create necessary directories
$Directories = @(
    "$ConfigDir",
    "$ConfigDir\nvim",
    "$ConfigDir\wezterm",
    "$ConfigDir\powershell",
    "$ConfigDir\starship",
    "$env:LOCALAPPDATA\nvim",
    "$HOME\Documents\PowerShell",
    "$HOME\.config"
)

foreach ($Dir in $Directories) {
    if (-not (Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
        Write-Host " Created: $Dir" -ForegroundColor Gray
    }
}

# Define source and target paths
$Links = @{
    # Neovim
    "$env:LOCALAPPDATA\nvim" = "$Repo\nvim"

    # WezTerm
    "$HOME\.wezterm.lua" = "$Repo\wezterm\wezterm.lua"

    # PowerShell
    "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" = "$Repo\Microsoft.PowerShell_profile.ps1"

    # Starship
    "$HOME\.config\starship.toml" = "$Repo\starship.toml"
}

# Create symbolic links
function New-SymLink($Source, $Target) {
    if (Test-Path $Source) {
        if ($Force) {
            Remove-Item $Source -Recurse -Force
        }
    }

    try {
        if (Test-Path $Target -PathType Container) {
            New-Item -ItemType SymbolicLink -Path $Source -Target $Target -Force | Out-Null
        } else {
            New-Item -ItemType SymbolicLink -Path $Source -Target $Target -Force | Out-Null
        }
        Write-Host " Linked: $Source → $Target" -ForegroundColor Green
    }
    catch {
        Write-Host " Failed to link: $Source → $Target" -ForegroundColor Red
        Write-Host " Try running as Administrator or enable Developer Mode" -ForegroundColor Yellow
    }
}

# Process all links
foreach ($Source in $Links.Keys) {
    $Target = $Links[$Source]
    New-SymLink -Source $Source -Target $Target
}

Write-Host "`n Installation complete!" -ForegroundColor Green
Write-Host " Next steps:" -ForegroundColor Cyan
Write-Host "   1. Restart your terminal" -ForegroundColor White
Write-Host "   2. Install required tools: winget install -e --id Neovim.Neovim WezTerm.WezTerm" -ForegroundColor White
Write-Host "   3. Configure API keys for AI plugins (see API_KEYS.md)" -ForegroundColor White
Write-Host "   4. Open Neovim and wait for plugins to install" -ForegroundColor White
