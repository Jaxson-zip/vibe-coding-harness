@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: vibe-coding-init.cmd — Initialize a project with Vibe Coding
:: engineering harness (AGENTS.md + docs/ + multi-tool links)
::
:: Usage: init.cmd [project-name]
:: ============================================================

set "PROJECT_NAME=%~1"

echo.
echo ========================================
echo  Vibe Coding Harness - Project Init
echo ========================================
echo.

:: Detect script directory
set "SCRIPT_DIR=%~dp0"

:: Ask project name if not provided
if "%PROJECT_NAME%"=="" (
    set /p PROJECT_NAME="Enter project name: "
)

:: 1. Create docs/ directory
echo [1/4] Creating docs/ directory...
if not exist "docs\" (
    mkdir docs
    echo   + Created docs/
) else (
    echo   - docs/ already exists
)

:: 2. Copy AGENTS.md template
echo [2/4] Creating AGENTS.md...
set "TEMPLATE=%SCRIPT_DIR%..\templates\AGENTS.md"
if exist "!TEMPLATE!" (
    if exist "AGENTS.md" (
        echo   - AGENTS.md already exists
    ) else (
        :: Use PowerShell for text replacement (available on all modern Windows)
        powershell -Command "(Get-Content '!TEMPLATE!' -Raw) -replace '<项目名称>', '%PROJECT_NAME%' | Set-Content -Path 'AGENTS.md' -Encoding UTF8"
        echo   + Created AGENTS.md ^(replace ^<...^> placeholders with your project details^)
    )
) else (
    echo   ! Template not found at !TEMPLATE!
)

:: 3. Create multi-tool hardlinks / copies
echo [3/4] Creating multi-tool links...

if not exist "AGENTS.md" goto skip_links

:: CLAUDE.md
if exist "CLAUDE.md" (
    echo   - CLAUDE.md already exists
) else (
    mklink /H CLAUDE.md AGENTS.md >nul 2>&1
    if !errorlevel! neq 0 (
        copy /Y AGENTS.md CLAUDE.md >nul
        echo   + CLAUDE.md copied from AGENTS.md
    ) else (
        echo   + CLAUDE.md -^> AGENTS.md
    )
)

:: GEMINI.md
if exist "GEMINI.md" (
    echo   - GEMINI.md already exists
) else (
    mklink /H GEMINI.md AGENTS.md >nul 2>&1
    if !errorlevel! neq 0 (
        copy /Y AGENTS.md GEMINI.md >nul
        echo   + GEMINI.md copied from AGENTS.md
    ) else (
        echo   + GEMINI.md -^> AGENTS.md
    )
)

:: .windsurfrules
if exist ".windsurfrules" (
    echo   - .windsurfrules already exists
) else (
    mklink /H .windsurfrules AGENTS.md >nul 2>&1
    if !errorlevel! neq 0 (
        copy /Y AGENTS.md .windsurfrules >nul
        echo   + .windsurfrules copied from AGENTS.md
    ) else (
        echo   + .windsurfrules -^> AGENTS.md
    )
)

:: .clinerules
if exist ".clinerules" (
    echo   - .clinerules already exists
) else (
    mklink /H .clinerules AGENTS.md >nul 2>&1
    if !errorlevel! neq 0 (
        copy /Y AGENTS.md .clinerules >nul
        echo   + .clinerules copied from AGENTS.md
    ) else (
        echo   + .clinerules -^> AGENTS.md
    )
)

:: conventions.md
if exist "conventions.md" (
    echo   - conventions.md already exists
) else (
    mklink /H conventions.md AGENTS.md >nul 2>&1
    if !errorlevel! neq 0 (
        copy /Y AGENTS.md conventions.md >nul
        echo   + conventions.md copied from AGENTS.md
    ) else (
        echo   + conventions.md -^> AGENTS.md
    )
)

:skip_links

:: 4. Done
echo [4/4] Done!
echo.
echo ========================================
echo  Project initialized with Vibe Coding harness
echo ========================================
echo.
echo Next steps:
echo   1. Open AGENTS.md and replace all ^<...^> placeholders
echo   2. Create docs/REQ-*.md with product requirements
echo   3. Create docs/PROG-*.md to start progress tracking
echo.
echo Compatible with:
echo   Codex  Cursor  Copilot  Cline  Zed  (read AGENTS.md natively)
echo   Claude Code  Windsurf  Gemini CLI  Aider  (via hardlink)
echo   OpenCode  (via opencode skill)
echo.

endlocal
