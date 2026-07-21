---
description: Initialize a new project with Vibe Coding engineering harness — docs/ structure, AGENTS.md (behavior rules + project config), scope freezing, and phase tracking.
agent: general
---

Initialize this project for Vibe Coding with full engineering harness. Follow these steps:

## Step 1: Understand the Project

ASK the user about their project before creating anything:
- What does this project do? Target users?
- What's the tech stack? (language, framework, database, etc.)
- What's in v1 scope? What's explicitly NOT in v1?

## Step 2: Create docs/ Directory

```
docs/
├── REQ-{today}-01-项目需求.md
├── PROG-{today}.md
```

## Step 3: Create AGENTS.md

Use the full template from the vibe-coding skill — it has TWO parts:

**Part 1: Behavior Rules** (sections 1-8):
- Basic behavior, authoritative docs, pre-task queries, Vibe Coding workflow, safety/permissions, completion criteria, git conventions, handling uncertainty.

**Part 2: Project Configuration** (filled with user's answers from Step 1):
- Project overview (architecture, domain, scale)
- Tech stack (language, frameworks, database, ORM, package manager)
- Dev tools (linter, formatter, type checker, test framework)
- Common commands (install, env setup, migrations, dev server)
- Code style (naming conventions, formatting rules, do's and don'ts)
- Project directory structure
- Testing requirements (framework, coverage target, naming)
- Security requirements (input validation, param queries, bcrypt, HTTPS, no secrets in git)

## Step 4: Write REQ Document

Include:
- Project vision and target users
- **v1 scope**: what's included, with acceptance criteria per feature
- **Explicitly NOT in v1**: scope freeze — list features pushed to future
- Page/route structure
- Tech stack decisions

## Step 5: Write PROG Document

Record:
- Current phase: Phase 0 (documentation initialization)
- Progress: docs/ and AGENTS.md created
- Open issues: none
- Next: Phase 1 — backend skeleton

## Step 6: Multi-Tool Symlinks

After creating AGENTS.md, create hard links (or copies as fallback) so it works across all AI IDEs:

On macOS/Linux:
```bash
ln -sf AGENTS.md CLAUDE.md
ln -sf AGENTS.md GEMINI.md
ln -sf AGENTS.md .windsurfrules
ln -sf AGENTS.md .clinerules
ln -sf AGENTS.md conventions.md
```

On Windows PowerShell:
```powershell
New-Item -ItemType HardLink -Path "CLAUDE.md" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path "GEMINI.md" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path ".windsurfrules" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path ".clinerules" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path "conventions.md" -Target "AGENTS.md" -Force
```

If hard link fails (cross-drive), fall back to `Copy-Item`.

## Step 7: Remind User

After initialization, remind:
- Add `.env*`, `node_modules/`, `.rulebook-ai/` etc. to `.gitignore`
- The AGENTS.md and its symlinks work with: Codex, Cursor, Claude Code, Windsurf, Copilot, Cline, Gemini CLI, Zed, Aider
- Restart opencode for AGENTS.md to take effect
- Frontend first, backend second when coding
- Max 3-4 requirements per conversation
- Update PROG daily
