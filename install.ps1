# install.ps1 — Instalator claude-project-kit dla Windows.
# Kopiuje skille do %USERPROFILE%\.claude\skills\
$ErrorActionPreference = 'Stop'

$source = Join-Path $PSScriptRoot 'skills'
$target = Join-Path $env:USERPROFILE '.claude\skills'

if (-not (Test-Path $source)) {
    Write-Host "Nie znaleziono folderu 'skills/' obok install.ps1." -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Force -Path $target | Out-Null

foreach ($skill in @('init-project', 'update-memory', 'generator-raportow')) {
    $src = Join-Path $source $skill
    $dst = Join-Path $target $skill
    if (Test-Path $dst) {
        $answer = Read-Host "Skill '$skill' juz istnieje w $target. Nadpisac? (t/n)"
        if ($answer -notmatch '^[tTyY]') {
            Write-Host "  pominieto: $skill" -ForegroundColor Yellow
            continue
        }
        Remove-Item -Recurse -Force $dst
    }
    Copy-Item -Recurse -Force $src $dst
    Write-Host "  zainstalowano: $skill -> $dst" -ForegroundColor Green
}

Write-Host ""
Write-Host "Gotowe. Uruchom ponownie Claude Code, aby skille zostaly wykryte." -ForegroundColor Cyan
