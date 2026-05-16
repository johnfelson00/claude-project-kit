# install.ps1 — Instalator claude-project-kit dla Windows.
# Kopiuje skille do %USERPROFILE%\.claude\skills\ i tlumaczy krok po kroku, co dalej.
# Komunikaty sa w ASCII (bez polskich znakow) — polska konsola czesto uzywa cp1250.
$ErrorActionPreference = 'Stop'

$source = Join-Path $PSScriptRoot 'skills'
$target = Join-Path $env:USERPROFILE '.claude\skills'

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Instalator claude-project-kit" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $source)) {
    Write-Host "Blad: nie znaleziono folderu 'skills/' obok install.ps1." -ForegroundColor Red
    Write-Host "Uruchom skrypt z katalogu sklonowanego repozytorium." -ForegroundColor Red
    exit 1
}

# Sprawdzenie, czy Claude Code jest zainstalowany.
$claudeHome = Join-Path $env:USERPROFILE '.claude'
if (-not (Test-Path $claudeHome)) {
    Write-Host "Uwaga: nie znaleziono folderu $claudeHome." -ForegroundColor Yellow
    Write-Host "Prawdopodobnie Claude Code nie jest jeszcze zainstalowany." -ForegroundColor Yellow
    Write-Host "Skille i tak skopiuje - zadzialaja po instalacji Claude Code." -ForegroundColor Yellow
    Write-Host ""
}

New-Item -ItemType Directory -Force -Path $target | Out-Null

Write-Host "Kopiowanie skilli do:" -ForegroundColor Cyan
Write-Host "  $target" -ForegroundColor Cyan
Write-Host ""
foreach ($skill in @('init-project', 'update-memory', 'generator-raportow')) {
    $src = Join-Path $source $skill
    $dst = Join-Path $target $skill
    if (Test-Path $dst) {
        $answer = Read-Host "  Skill '$skill' juz istnieje. Nadpisac? (t/n)"
        if ($answer -notmatch '^[tTyY]') {
            Write-Host "  pominieto: $skill" -ForegroundColor Yellow
            continue
        }
        Remove-Item -Recurse -Force $dst
    }
    Copy-Item -Recurse -Force $src $dst
    Write-Host "  OK  $skill" -ForegroundColor Green
}

$guide = @(
    "",
    "============================================================",
    " INSTALACJA ZAKONCZONA - CO DALEJ, KROK PO KROKU",
    "============================================================",
    "",
    "Zainstalowano 3 skille:",
    "  1. init-project       - zaklada strukture nowego projektu",
    "  2. update-memory      - zapisuje stan na koniec sesji",
    "  3. generator-raportow - buduje akademickie raporty .docx",
    "",
    "------------------------------------------------------------",
    "",
    "KROK 1. Zrestartuj Claude Code.",
    "   Zamknij go i otworz na nowo - skille wykrywane sa przy starcie.",
    "",
    "KROK 2. Zaloz pamiec projektu (robisz to RAZ na kazdy projekt).",
    "   Otworz folder projektu w Claude Code i wpisz:",
    "       /init-project",
    "   Claude zada 7 pytan (nazwa, cel, stack...) i utworzy plik",
    "   CLAUDE.md oraz folder memory/ z 6 plikami stanu projektu.",
    "",
    "KROK 3. Pracuj normalnie.",
    "   Na poczatku kazdej sesji Claude czyta CLAUDE.md i memory/,",
    "   wiec wie, gdzie poprzednio skonczyliscie.",
    "",
    "KROK 4. Na koniec KAZDEJ sesji wpisz:",
    "       /update-memory",
    "   Claude spisze co zrobiono, jakie zapadly decyzje i co dalej.",
    "",
    "KROK 5. (opcjonalnie) Raport akademicki.",
    "   Powiedz Claude'owi 'zbuduj raport' i podaj dane oraz wytyczne.",
    "   Skill generator-raportow potrzebuje Pythona z pakietami:",
    "       pip install --user python-docx matplotlib openpyxl numpy",
    "",
    "------------------------------------------------------------",
    " OBSIDIAN? NIE JEST POTRZEBNY",
    "------------------------------------------------------------",
    "Ta wersja skilli NIE integruje sie z Obsidianem ani z zadnym",
    "innym zewnetrznym narzedziem. Pamiec projektu to zwykle pliki",
    ".md w folderze projektu - otworzysz je czym chcesz i niczego",
    "nie musisz konfigurowac.",
    "",
    "============================================================"
)
foreach ($line in $guide) {
    Write-Host $line -ForegroundColor White
}
