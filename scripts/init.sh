#!/usr/bin/env bash
# ============================================================
# vibe-coding-init.sh — Initialize a project with Vibe Coding
# engineering harness (AGENTS.md + docs/ + multi-tool links)
#
# Usage:
#   bash ~/.config/opencode/skills/vibe-coding/scripts/init.sh
#   bash init.sh my-project-name
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/../templates"
PROJECT_NAME="${1:-}"

if [ -z "$PROJECT_NAME" ]; then
  read -rp "Enter project name: " PROJECT_NAME
fi

echo ""
echo "========================================"
echo " Vibe Coding Harness - Project Init"
echo "========================================"
echo ""

# 1. Create docs/ directory
echo -e "\033[33m[1/4] Creating docs/ directory...\033[0m"
if [ ! -d "docs" ]; then
  mkdir -p docs
  echo -e "  \033[32m+ Created docs/\033[0m"
else
  echo -e "  \033[90m- docs/ already exists\033[0m"
fi

# 2. Copy AGENTS.md template
echo -e "\033[33m[2/4] Creating AGENTS.md...\033[0m"
TEMPLATE="$TEMPLATE_DIR/AGENTS.md"

if [ -f "$TEMPLATE" ]; then
  if [ -f "AGENTS.md" ]; then
    echo -e "  \033[90m- AGENTS.md already exists\033[0m"
  else
    sed "s/<项目名称>/$PROJECT_NAME/g" "$TEMPLATE" > AGENTS.md
    echo -e "  \033[32m+ Created AGENTS.md (replace <...> placeholders with your project details)\033[0m"
  fi
else
  echo -e "  \033[31m! Template not found at $TEMPLATE\033[0m"
  echo "    Download from: https://github.com/obviousworks/vibe-coding-ai-rules"
fi

# 3. Create multi-tool symlinks
echo -e "\033[33m[3/4] Creating multi-tool symlinks...\033[0m"

declare -A LINKS=(
  ["CLAUDE.md"]="Claude Code"
  ["GEMINI.md"]="Gemini CLI"
  [".windsurfrules"]="Windsurf"
  [".clinerules"]="Cline"
  ["conventions.md"]="Aider"
)

for target_file in "${!LINKS[@]}"; do
  tool_name="${LINKS[$target_file]}"
  if [ -e "$target_file" ]; then
    echo -e "  \033[90m- $target_file already exists (for $tool_name)\033[0m"
  else
    if [ -f "AGENTS.md" ]; then
      ln -sf AGENTS.md "$target_file"
      echo -e "  \033[32m+ $target_file -> AGENTS.md (for $tool_name)\033[0m"
    else
      echo -e "  \033[31m! Cannot create $target_file: AGENTS.md not found\033[0m"
    fi
  fi
done

# 4. Summary
echo -e "\033[33m[4/4] Done!\033[0m"
echo ""
echo "========================================"
echo " Project initialized with Vibe Coding harness"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Open AGENTS.md and replace all <...> placeholders"
echo "  2. Create docs/REQ-*.md with product requirements"
echo "  3. Create docs/PROG-*.md to start progress tracking"
echo ""
echo "Compatible with:"
echo "  Codex  Cursor  Copilot  Cline  Zed  (read AGENTS.md natively)"
echo "  Claude Code  Windsurf  Gemini CLI  Aider  (via symlink)"
echo "  OpenCode  (via opencode skill)"
echo ""
