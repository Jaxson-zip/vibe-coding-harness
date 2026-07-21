<#
.SYNOPSIS
  Initialize a project with Vibe Coding engineering harness.
  Creates AGENTS.md, docs/ structure, and multi-tool symlinks.

.DESCRIPTION
  Run this from any project root directory (empty or existing).
  It will:
  1. Create docs/ directory structure
  2. Generate AGENTS.md from template (with placeholders for you to fill)
  3. Create hard links for Claude Code, Windsurf, Gemini CLI, etc.

.USAGE
  & "$env:USERPROFILE\.config\opencode\skills\vibe-coding\scripts\init.ps1"

  Or if you copied this script elsewhere:
  .\init.ps1
#>

param(
    [string]$ProjectName = "",
    [switch]$Force = $false
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$templateDir = Join-Path (Split-Path -Parent $scriptDir) "templates"

if (-not $ProjectName) {
    $ProjectName = Read-Host "Enter project name"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Vibe Coding Harness - Project Init" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Create docs/ directory
Write-Host "[1/4] Creating docs/ directory..." -ForegroundColor Yellow
$dirs = @("docs")
foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  + Created $dir/" -ForegroundColor Green
    } else {
        Write-Host "  - $dir/ already exists" -ForegroundColor Gray
    }
}

# 2. Copy AGENTS.md template
Write-Host "[2/4] Creating AGENTS.md..." -ForegroundColor Yellow
$template = Join-Path $templateDir "AGENTS.md"
$target = Join-Path (Get-Location) "AGENTS.md"

if (Test-Path $template) {
    if ((Test-Path $target) -and -not $Force) {
        Write-Host "  - AGENTS.md already exists (use -Force to overwrite)" -ForegroundColor Gray
    } else {
        $content = Get-Content $template -Raw
        $content = $content -replace '<项目名称>', $ProjectName
        Set-Content -Path $target -Value $content -Encoding UTF8
        Write-Host "  + Created AGENTS.md (replace <...> placeholders with your project details)" -ForegroundColor Green
    }
} else {
    Write-Host "  ! Template not found at $template" -ForegroundColor Red
    Write-Host "    Download from: https://github.com/obviousworks/vibe-coding-ai-rules" -ForegroundColor Gray
}

# 3. Create multi-tool symlinks
Write-Host "[3/4] Creating multi-tool links..." -ForegroundColor Yellow
$links = @(
    @{Path="CLAUDE.md"; Target="AGENTS.md"; Tool="Claude Code"},
    @{Path="GEMINI.md"; Target="AGENTS.md"; Tool="Gemini CLI"},
    @{Path=".windsurfrules"; Target="AGENTS.md"; Tool="Windsurf"},
    @{Path=".clinerules"; Target="AGENTS.md"; Tool="Cline"},
    @{Path="conventions.md"; Target="AGENTS.md"; Tool="Aider"}
)

foreach ($link in $links) {
    $linkPath = Join-Path (Get-Location) $link.Path
    if (Test-Path $linkPath) {
        Write-Host "  - $($link.Path) already exists (for $($link.Tool))" -ForegroundColor Gray
    } else {
        try {
            New-Item -ItemType HardLink -Path $linkPath -Target $link.Target -Force | Out-Null
            Write-Host "  + $($link.Path) -> AGENTS.md (for $($link.Tool))" -ForegroundColor Green
        } catch {
            # Hard link failed (cross-drive), fall back to copy
            try {
                Copy-Item -Path $link.Target -Destination $linkPath -Force
                Write-Host "  + $($link.Path) copied from AGENTS.md (for $($link.Tool)) [hard link unavailable]" -ForegroundColor Green
            } catch {
                Write-Host "  ! Failed to create $($link.Path): $_" -ForegroundColor Red
            }
        }
    }
}

# 4. Summary
Write-Host "[4/4] Done!" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Project initialized with Vibe Coding harness" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Open AGENTS.md and replace all <...> placeholders"
Write-Host "  2. Create docs/REQ-*.md with product requirements"
Write-Host "  3. Create docs/PROG-*.md to start progress tracking"
Write-Host ""
Write-Host "Compatible with:" -ForegroundColor White
Write-Host "  Codex  Cursor  Copilot  Cline  Zed  (read AGENTS.md natively)"
Write-Host "  Claude Code  Windsurf  Gemini CLI  Aider  (via symlink)"
Write-Host "  OpenCode  (via opencode skill)" 
Write-Host ""
