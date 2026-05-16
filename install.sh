#!/usr/bin/env bash
# install.sh — Instalator claude-project-kit dla macOS / Linux.
# Kopiuje skille do ~/.claude/skills/
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/skills"
TARGET="$HOME/.claude/skills"

if [ ! -d "$SOURCE" ]; then
  echo "Nie znaleziono folderu 'skills/' obok install.sh." >&2
  exit 1
fi

mkdir -p "$TARGET"

for skill in init-project update-memory generator-raportow; do
  src="$SOURCE/$skill"
  dst="$TARGET/$skill"
  if [ -d "$dst" ]; then
    read -r -p "Skill '$skill' juz istnieje w $TARGET. Nadpisac? (t/n) " answer
    case "$answer" in
      [tTyY]*) rm -rf "$dst" ;;
      *) echo "  pominieto: $skill"; continue ;;
    esac
  fi
  cp -R "$src" "$dst"
  echo "  zainstalowano: $skill -> $dst"
done

echo ""
echo "Gotowe. Uruchom ponownie Claude Code, aby skille zostaly wykryte."
