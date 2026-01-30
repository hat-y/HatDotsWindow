# Installation Script
# Verifies dependencies and creates symbolic links for all Windows configurations

param(
    [switch]$Force
)

$Repo = $PSScriptRoot
$ConfigDir = "$HOME\.config\hatdots-windows"

# Start transcript for debugging
Start-Transcript -Path "$PSScriptRoot\install_log.txt" -Append | Out-Null

# Set error action preference
$ErrorActionPreference = "Stop"

# Strict mode
Set-StrictMode -Version Latest

Write-Host "Checking dependencies..." -ForegroundColor Green
Write-Host "Repository: $Repo" -ForegroundColor Cyan

# Track created links for rollback
$CreatedLinks = @()

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
try {
    $devMode = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction Stop
} catch {
    Write-Error "Failed to read Developer Mode setting"
    $devMode = $null
}

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
    Write-Host "winget install -e --id BrechtSanders.WinLibs.POSIX.UCRT" -ForegroundColor Cyan
    Write-Host "winget install -e --id Microsoft.tree-sitter-cli" -ForegroundColor Cyan
    Write-Host "# For win32yank, use scoop: scoop install win32yank" -ForegroundColor Cyan

    if (-not $devMode -and -not $isAdmin) {
        Write-Host "`nEnable Developer Mode in Windows Settings or run as Administrator" -ForegroundColor Yellow
    }

    # Rollback on error
    if ($CreatedLinks.Count -gt 0) {
        Write-Host "`n⚠️  Installation failed. Rolling back changes..." -ForegroundColor Yellow
        if (-not Restore-SymbolicLinks -LinksToRestore $CreatedLinks) {
            Write-Host "❌ Rollback failed. Please restore manually." -ForegroundColor Red
        }
    }

    # Stop transcript
    Stop-Transcript | Out-Null
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
function New-SymLink {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,
        [Parameter(Mandatory = $true)]
        [string]$Target
    )

    try {
        if ($Force) {
            if (Test-Path $Source) {
                Remove-Item $Source -Recurse -Force
            }
            if (Test-Path $Target -PathType Container) {
                New-Item -ItemType Directory -Path $Source -Force | Out-Null
            } else {
                New-Item -ItemType Directory -Path (Split-Path $Source -Parent) -Force | Out-Null
            }
        }

        $link = New-Item -ItemType SymbolicLink -Path $Source -Target $Target -ErrorAction Stop
        if ($link -and $link.LinkType -eq 'SymbolicLink') {
            Write-Host " Linked: $Source → $Target" -ForegroundColor Green
            $CreatedLinks += [PSCustomObject]@{
                Source = $Source
                Target = $Target
                Created = Get-Date
            }
            return $true
        }
        return $false
    } catch {
        Write-Host " Failed to link: $Source → $Target" -ForegroundColor Red
        Write-Host " Error: $($_.Exception.Message)" -ForegroundColor Yellow
        return $false
    }
}

# Process all links
foreach ($Source in $Links.Keys) {
    $Target = $Links[$Source]
    New-SymLink -Source $Source -Target $Target
}

# Verify all links were created successfully
Write-Host "`n Verification:" -ForegroundColor Cyan
$Verified = 0
$FailedVerification = 0

foreach ($Source in $Links.Keys) {
    $Target = $Links[$Source]
    if (Test-Path $Source -PathType Container -ErrorAction SilentlyContinue) {
        $LinkTarget = (Get-Item $Source).Target
        if ($LinkTarget -eq $Target) {
            Write-Host " ✓ $Source → $Target" -ForegroundColor Green
            $Verified++
        } else {
            Write-Host " ✗ $Source → $Target (Target mismatch)" -ForegroundColor Red
            $FailedVerification++
        }
    } else {
        Write-Host " ✗ $Source not found" -ForegroundColor Red
        $FailedVerification++
    }
}

Write-Host "`n Verification complete: $Verified passed, $FailedVerification failed" -ForegroundColor White

# Restore symbolic links function
function Restore-SymbolicLinks {
    param(
        [Parameter(Mandatory = $true)]
        [array]$LinksToRestore
    )

    Write-Host "`n🔄 Restoring symbolic links..." -ForegroundColor Yellow

    $Restored = 0
    $Failed = 0

    foreach ($link in $LinksToRestore) {
        try {
            if (Test-Path $link.Source) {
                Remove-Item $link.Source -Recurse -Force -ErrorAction Stop
                Write-Host " Restored: $($link.Source)" -ForegroundColor Cyan
                $Restored++
            }
        } catch {
            Write-Host " Failed to restore: $($link.Source) - $($_.Exception.Message)" -ForegroundColor Red
            $Failed++
        }
    }

    Write-Host " Rollback complete: $Restored restored, $Failed failed" -ForegroundColor White
    return $Failed -eq 0
}

# Restore on exit if error occurs
$ExitCode = 0
trap {
    Write-Host "`n⚠️  Error occurred: $($_.Exception.Message)" -ForegroundColor Red

    if ($CreatedLinks.Count -gt 0) {
        Write-Host "`n🔄 Rolling back changes..." -ForegroundColor Yellow
        if (-not Restore-SymbolicLinks -LinksToRestore $CreatedLinks) {
            Write-Host "❌ Rollback failed. Please restore manually." -ForegroundColor Red
        }
    }

    $ExitCode = 1
} finally {
    Stop-Transcript | Out-Null
    exit $ExitCode
}

Write-Host "`n✅ Installation complete!" -ForegroundColor Green
Write-Host "`n Next steps:" -ForegroundColor Cyan
Write-Host "   1. Restart your terminal" -ForegroundColor White
Write-Host "   2. Install required tools: winget install -e --id Neovim.Neovim WezTerm.WezTerm" -ForegroundColor White
Write-Host "   3. Configure API keys for AI plugins (see API_KEYS.md)" -ForegroundColor White
Write-Host "   4. Open Neovim and wait for plugins to install" -ForegroundColor White
Write-Host "`n 📝 Installation log saved to: install_log.txt" -ForegroundColor White
