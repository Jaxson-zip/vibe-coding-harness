---
name: vibe-retrofit
description: Retrofit an existing project with Vibe Coding engineering harness. Use when the user has an existing codebase and wants to add engineering discipline — scans codebase, diagnoses issues, generates AGENTS.md and docs/, defines refactoring boundaries, locks scope. Triggers on: "retrofit", "existing project", "add engineering", "establish conventions", "/vibe-retrofit".
---

Retrofit this existing project with proper engineering harness. Do NOT create anything blindly — analyze first, then generate.

## Step 1: Scan the Codebase

Read and analyze the following, then present findings to the user:

1. **Tech stack detection**:
   - Read `package.json` (or `requirements.txt`, `Cargo.toml`, `go.mod`, `Gemfile`)
   - List all key dependencies and their versions

2. **Directory structure analysis**:
   - List top-level directories and key subdirectories
   - Identify the architectural pattern (MVC, layered, feature-based, etc.)

3. **Existing AI configs check**:
   - Look for existing `.cursor/rules/`, `CLAUDE.md`, `AGENTS.md`, `.windsurfrules`, `.clinerules`, `GEMINI.md`, `.github/copilot-instructions.md`
   - If found, note their contents for merging

4. **Commands extraction**:
   - Extract scripts from `package.json`, Makefile, `docker-compose.yml`
   - Find start/build/test/lint commands

5. **Testing status**:
   - Find test directories and files
   - Identify test framework from imports

6. **Code style config**:
   - Read `.eslintrc*`, `.prettierrc*`, `tsconfig.json`, `pyproject.toml`, `.editorconfig`

## Step 2: Diagnose Issues

Before generating any files, identify problems and present to user for confirmation:

- Directory structure issues (too deep, no separation of concerns, inconsistent naming)
- Duplicate or dead code
- Outdated/vulnerable dependencies
- `.env` or secrets accidentally in git history
- Over-coupled modules (changing one file breaks another)
- Missing tests or low coverage

Write findings to `docs/BIZ-{today}-01-现有问题诊断.md` but **ask user to confirm before making any changes**.

## Step 3: Generate AGENTS.md

Based on scan results, create `AGENTS.md` at project root:

- **Part 1 (Behavior Rules)**: Use standard vibe-coding template, keeping existing conventions (e.g., if the project uses 4-space indentation, don't write 2-space)
- **Part 2 (Project Configuration)**: Fill with auto-detected values from Step 1
- **Section 9 (Refactoring Boundaries)**: Add a "minefield map" section:
  - Modules that CANNOT be modified and why
  - Areas that need refactoring but require caution
  - External dependencies and their boundaries

If there were existing configs (`.cursorrules`, `CLAUDE.md`, etc.), merge their valuable content into AGENTS.md, note in PROG what was merged from where.

## Step 4: Create docs/ Structure

If not already present:
- `docs/CURRENT.md` — task handoff template (覆盖式,切换 agent 先读这个)
- `docs/PROG-{today}.md` — current actual state (what's built, what's broken)
- `docs/DEV-{today}-01-现有架构分析.md` — current architecture, DB schema, API endpoints
- Generate a **reverse PRD** from existing code: list all implemented features as if they were requirements. Present to user to confirm which are active, which are abandoned.

## Step 5: Define Boundaries

Ask user to confirm:
- **Do not touch**: stable core modules, shared components, tested code
- **Refactor needed**: coupled/duplicated code → create `docs/DEV-{today}-XX-{模块}重构方案.md` for each
- **Can be deleted**: dead code, abandoned routes, unused components
- **External service boundaries**: payment, SMS, OSS etc. — never change integration without explicit approval

## Step 6: Lock Scope

Document the scope freeze:
- **Current version (v1.x)** — bug fixes + approved refactoring only
- **Next version (v2.0)** — new features, major refactors go here

## Step 7: Multi-Tool Symlinks

Create hard links (or copies as fallback) so AGENTS.md works across all AI IDEs:

On macOS/Linux:
```bash
ln -sf AGENTS.md CLAUDE.md; ln -sf AGENTS.md GEMINI.md; ln -sf AGENTS.md .windsurfrules; ln -sf AGENTS.md .clinerules; ln -sf AGENTS.md conventions.md
```

On Windows PowerShell:
```powershell
New-Item -ItemType HardLink -Path "CLAUDE.md" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path "GEMINI.md" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path ".windsurfrules" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path ".clinerules" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path "conventions.md" -Target "AGENTS.md" -Force
```

If hard link fails (cross-drive), fall back to `Copy-Item`. Note: if old `.cursorrules` or `CLAUDE.md` already exist with different content, merge them into AGENTS.md first, then create the link.

## Step 8: Summary

After everything is done, present the user with:
- What files were created/modified
- What problems were diagnosed
- What boundaries are now in place
- What the next phase should be

For detailed retrofit reference, see the vibe-coding meta skill's [docs/retrofit.md](../vibe-coding/docs/retrofit.md).
