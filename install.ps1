# Installation Script
# Verifies dependencies and creates symbolic links for all Windows configurations

param(
    [switch]$Force
)

$Repo = $PSScriptRoot
$ConfigDir = "$HOME\.config\hatdots-windows"

Write-Host "Checking dependencies..." -ForegroundColor Green
Write-Host "Repository: $Repo" -ForegroundColor Cyan

# Function to check if a command exists
function Test-Command {
    param($Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Check required tools
$requiredTools = @{
    "git" = "Git - Required for version control"
    "nvim" = "Neovim - Main editor"
    "wezterm" = "WezTerm - Terminal emulator"
    "starship" = "Starship - Shell prompt"
    "fd" = "fd - Fast file finder for Telescope"
    "rg" = "ripgrep - Content search for Telescope"
}

# Check optional tools
$optionalTools = @{
    "eza" = "eza - Modern ls replacement"
    "zoxide" = "zoxide - Smart cd command"
    "lazygit" = "lazygit - Git TUI"
    "win32yank" = "win32yank - Clipboard utility for Neovim"
}

$missingTools = @()
$allToolsInstalled = $true

foreach ($tool in $requiredTools.GetEnumerator()) {
    if (Test-Command $tool.Key) {
        Write-Host "[OK] $($tool.Value)" -ForegroundColor Green
    } else {
        Write-Host "[MISSING] $($tool.Value)" -ForegroundColor Red
        $missingTools += $tool.Key
        $allToolsInstalled = $false
    }
}

# Check optional tools
Write-Host "`nOptional tools (recommended for better experience):" -ForegroundColor Cyan
foreach ($tool in $optionalTools.GetEnumerator()) {
    if (Test-Command $tool.Key) {
        Write-Host "[OK] $($tool.Value)" -ForegroundColor Green
    } else {
        Write-Host "[OPTIONAL] $($tool.Value)" -ForegroundColor Yellow
    }
}

# Check for PowerShell 7+
$psVersion = $PSVersionTable.PSVersion.Major
if ($psVersion -lt 7) {
    Write-Host "[ERROR] PowerShell 7+ required (current: $psVersion)" -ForegroundColor Red
    $allToolsInstalled = $false
} else {
    Write-Host "[OK] PowerShell $psVersion" -ForegroundColor Green
}

# Check for developer mode or admin rights
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$devMode = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction SilentlyContinue

if ($devMode.AllowDevelopmentWithoutDevLicense -eq 1 -or $isAdmin) {
    Write-Host "[OK] Can create symbolic links" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Cannot create symbolic links (enable Developer Mode or run as Admin)" -ForegroundColor Red
    $allToolsInstalled = $false
}

if (-not $allToolsInstalled) {
    Write-Host "`n[ERROR] Installation failed. Missing dependencies found." -ForegroundColor Red
    Write-Host "`nInstall missing tools with winget:" -ForegroundColor Yellow

    if ($missingTools -contains "git") {
        Write-Host "winget install -e --id Git.Git" -ForegroundColor Cyan
    }
    if ($missingTools -contains "nvim") {
        Write-Host "winget install -e --id Neovim.Neovim" -ForegroundColor Cyan
    }
    if ($missingTools -contains "wezterm") {
        Write-Host "winget install -e --id WezTerm.WezTerm" -ForegroundColor Cyan
    }
    if ($missingTools -contains "starship") {
        Write-Host "winget install -e --id Starship.Starship" -ForegroundColor Cyan
    }
    if ($missingTools -contains "fd") {
        Write-Host "winget install -e --id sharkdp.fd" -ForegroundColor Cyan
    }
    if ($missingTools -contains "rg") {
        Write-Host "winget install -e --id BurntSushi.ripgrep.MSVC" -ForegroundColor Cyan
    }

    Write-Host "`nOptional tools installation:" -ForegroundColor Yellow
    Write-Host "winget install -e --id eza-community.eza" -ForegroundColor Cyan
    Write-Host "winget install -e --id JesseDuffield.lazygit" -ForegroundColor Cyan
    Write-Host "# For win32yank, use scoop: scoop install win32yank" -ForegroundColor Cyan

    if (-not $devMode -and -not $isAdmin) {
        Write-Host "`nEnable Developer Mode in Windows Settings or run as Administrator" -ForegroundColor Yellow
    }

    exit 1
}

Write-Host "[OK] All dependencies satisfied" -ForegroundColor Green
Write-Host "`nCreating symbolic links..." -ForegroundColor Green

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
