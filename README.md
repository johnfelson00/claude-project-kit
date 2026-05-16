# claude-project-kit

Zestaw skilli dla [Claude Code](https://claude.com/claude-code). Rdzeń to
uniwersalny szkielet **pamięci projektu** — dwa skille, które dają każdemu
folderowi trwałą, ustrukturyzowaną pamięć. Dochodzi do tego skill generujący
akademickie raporty. Sklonuj, zainstaluj i używaj w dowolnym projekcie.

- **`init-project`** — bootstrapuje pusty folder: tworzy `CLAUDE.md` i folder `memory/`.
- **`update-memory`** — synchronizuje tę pamięć na koniec każdej sesji.
- **`generator-raportow`** — buduje skrypty Python generujące raporty `.docx` (opcjonalnie + `.xlsx`).

## Po co to jest

Claude Code zaczyna każdą sesję od zera. Bez zapisanego stanu projektu
asystent co rusz odbudowuje kontekst od nowa — i często myli się co do tego,
gdzie skończyliście. Ten kit rozwiązuje problem dwoma krokami:

1. Raz, na starcie projektu — `/init-project` zakłada `CLAUDE.md` (zwięzły
   opis projektu wg stałego schematu) oraz folder `memory/` z sześcioma
   plikami stanu.
2. Na końcu każdej sesji — `/update-memory` spisuje, co zostało zrobione,
   jakie zapadły decyzje i co dalej.

Następna sesja czyta `CLAUDE.md` + `memory/` i wie, gdzie jesteście.

## Co robi `init-project`

Uruchamiany w pustym folderze. Zadaje 7 pytań (nazwa, etap, cel, stack,
referencje, ewentualne nadpisania, czy zainstalować `/update-memory`), a potem
generuje:

**`CLAUDE.md`** wg sześciosekcyjnego schematu (maks. 200 linii):

| Sekcja | Zawartość |
|--------|-----------|
| A · What this folder is | czym jest folder + etap |
| B · The Goal | po co istnieje / jak wygląda "done" / co poza zakresem |
| C · Stack | języki, frameworki, hosting, komenda uruchomienia |
| D · Decisions | log decyzji, jedna linia każda |
| E · Memory Map | opis sześciu plików `memory/` |
| F · References | repo, Notion, tracker, produkcja, dashboardy |
| G · Overrides | tylko jeśli projekt nadpisuje ustawienia globalne |

**`memory/`** — sześć standardowych plików:

| Plik | Rola |
|------|------|
| `project-brief.md` | zamrożony brief startowy (odpowiedzi z `/init-project`) |
| `current-strategy.md` | bieżąca faza i fokus tygodnia |
| `decisions.md` | log decyzji architektonicznych (What / Why / Implications) |
| `next-actions.md` | lista zadań do zrobienia |
| `session-summaries.md` | datowane podsumowania sesji |
| `bugs-and-risks.md` | otwarte błędy, ryzyka, naprawione |

Opcjonalnie instaluje też komendę `/update-memory` w `.claude/commands/`.

## Co robi `update-memory`

Uruchamiany na koniec sesji (`/update-memory` lub frazy typu "wrap up").
Sprawdza, co zmieniło się w sesji (git diff lub pytanie do użytkownika) i:

- dopisuje wpis do `session-summaries.md` (co zrobiono / stan / następny krok),
- aktualizuje `next-actions.md` (zaznacza zrobione, dopisuje nowe),
- aktualizuje `current-strategy.md`, jeśli zmienił się fokus,
- dopisuje decyzje do `decisions.md`,
- aktualizuje `bugs-and-risks.md`,
- jeśli zapadły decyzje — dopisuje je do sekcji D w `CLAUDE.md` i odświeża datę.

Jeśli w sesji nic się nie wydarzyło — kończy bez zapisu (nie fabrykuje stanu).

## Co robi `generator-raportow`

Skill prowadzi przez budowę **akademickiego raportu studenckiego** metodą
"raport z kodu": dane i obliczenia trzymane są w skrypcie Python, a raport
`.docx` (opcjonalnie + załącznik `.xlsx` lub osadzone wykresy) powstaje jednym
poleceniem `python <skrypt>.py` — i można go regenerować bez ręcznych poprawek.

Co robi krok po kroku:

- czyta wytyczne przedmiotu (PDF / instrukcja) i wyciąga z nich checklistę
  wymaganych sekcji,
- kopiuje gotowy szablon `szablon-raportu.py` (helpery do stron tytułowych,
  tabel, wykresów matplotlib, formuł, bibliografii, arkusza XLSX),
- pomaga wstawić dane i złożyć sekcje merytoryczne w kolejności z wytycznych,
- pilnuje konwencji raportu akademickiego (`references/checklista-raportu.md`).

Wymaga Pythona z pakietem `python-docx` (oraz opcjonalnie `matplotlib`,
`openpyxl`, `numpy`). Lokalizację skryptu i artefaktów wskazujesz sam podczas
korzystania ze skilla.

## Instalacja

Sklonuj repozytorium i uruchom instalator dla swojego systemu.

```bash
git clone https://github.com/johnfelson00/claude-project-kit.git
cd claude-project-kit
```

**Windows (PowerShell):**

```powershell
.\install.ps1
```

**macOS / Linux:**

```bash
chmod +x install.sh && ./install.sh
```

Instalator kopiuje wszystkie skille do `~/.claude/skills/` (czyli
`%USERPROFILE%\.claude\skills\` na Windows). Po instalacji uruchom ponownie
Claude Code, aby skille zostały wykryte.

**Instalacja ręczna:** skopiuj foldery `skills/init-project/`,
`skills/update-memory/` oraz `skills/generator-raportow/` do `~/.claude/skills/`.

## Użycie

```
# w nowym, pustym folderze projektu:
/init-project
# odpowiedz na 7 pytań → powstaje CLAUDE.md + memory/

# ... pracujesz nad projektem ...

# na koniec sesji:
/update-memory
# memory/ zostaje zsynchronizowane
```

Aby zbudować raport — powiedz Claude'owi „zbuduj raport" / „wygeneruj raport"
i podaj dane oraz wytyczne; uruchomi się `generator-raportow`.

## Struktura repozytorium

```
claude-project-kit/
├── README.md
├── LICENSE
├── install.ps1            # instalator Windows
├── install.sh             # instalator macOS / Linux
└── skills/
    ├── init-project/
    │   ├── SKILL.md
    │   └── references/    # szablony CLAUDE.md, memory/, komendy
    ├── update-memory/
    │   └── SKILL.md
    └── generator-raportow/
        ├── SKILL.md
        └── references/    # checklista raportu + szablon-raportu.py
```

## Licencja

MIT — zob. [LICENSE](LICENSE).
