#!/usr/bin/env bash
# install.sh — Instalator claude-project-kit dla macOS / Linux.
# Kopiuje skille do ~/.claude/skills/ i tlumaczy krok po kroku, co dalej.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/skills"
TARGET="$HOME/.claude/skills"

echo ""
echo "============================================================"
echo " Instalator claude-project-kit"
echo "============================================================"
echo ""

if [ ! -d "$SOURCE" ]; then
  echo "Blad: nie znaleziono folderu 'skills/' obok install.sh." >&2
  echo "Uruchom skrypt z katalogu sklonowanego repozytorium." >&2
  exit 1
fi

# Sprawdzenie, czy Claude Code jest zainstalowany.
if [ ! -d "$HOME/.claude" ]; then
  echo "Uwaga: nie znaleziono folderu $HOME/.claude."
  echo "Prawdopodobnie Claude Code nie jest jeszcze zainstalowany."
  echo "Skille i tak skopiuje - zadzialaja po instalacji Claude Code."
  echo ""
fi

mkdir -p "$TARGET"

echo "Kopiowanie skilli do:"
echo "  $TARGET"
echo ""
for skill in init-project update-memory generator-raportow; do
  src="$SOURCE/$skill"
  dst="$TARGET/$skill"
  if [ -d "$dst" ]; then
    read -r -p "  Skill '$skill' juz istnieje. Nadpisac? (t/n) " answer
    case "$answer" in
      [tTyY]*) rm -rf "$dst" ;;
      *) echo "  pominieto: $skill"; continue ;;
    esac
  fi
  cp -R "$src" "$dst"
  echo "  OK  $skill"
done

cat <<'GUIDE'

============================================================
 INSTALACJA ZAKONCZONA - CO DALEJ, KROK PO KROKU
============================================================

Zainstalowano 3 skille:
  1. init-project       - zaklada strukture nowego projektu
  2. update-memory      - zapisuje stan na koniec sesji
  3. generator-raportow - buduje akademickie raporty .docx

------------------------------------------------------------

KROK 1. Zrestartuj Claude Code.
   Zamknij go i otworz na nowo - skille wykrywane sa przy starcie.

KROK 2. Zaloz pamiec projektu (robisz to RAZ na kazdy projekt).
   Otworz folder projektu w Claude Code i wpisz:
       /init-project
   Claude zada 7 pytan (nazwa, cel, stack...) i utworzy plik
   CLAUDE.md oraz folder memory/ z 6 plikami stanu projektu.

KROK 3. Pracuj normalnie.
   Na poczatku kazdej sesji Claude czyta CLAUDE.md i memory/,
   wiec wie, gdzie poprzednio skonczyliscie.

KROK 4. Na koniec KAZDEJ sesji wpisz:
       /update-memory
   Claude spisze co zrobiono, jakie zapadly decyzje i co dalej.

KROK 5. (opcjonalnie) Raport akademicki.
   Powiedz Claude'owi "zbuduj raport" i podaj dane oraz wytyczne.
   Skill generator-raportow potrzebuje Pythona z pakietami:
       pip install --user python-docx matplotlib openpyxl numpy

------------------------------------------------------------
 OBSIDIAN? NIE JEST POTRZEBNY
------------------------------------------------------------
Ta wersja skilli NIE integruje sie z Obsidianem ani z zadnym
innym zewnetrznym narzedziem. Pamiec projektu to zwykle pliki
.md w folderze projektu - otworzysz je czym chcesz i niczego
nie musisz konfigurowac.

============================================================
GUIDE
