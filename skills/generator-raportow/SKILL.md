---
name: generator-raportow
description: Buduje skrypty Python generujące akademickie raporty studenckie (.docx, opcjonalnie + .xlsx z obliczeniami) według powtarzalnego pipeline'u. Używaj gdy użytkownik chce nowy raport z laboratorium lub projektu, mówi "zbuduj raport", "wygeneruj raport", "skrypt do raportu"; gdy ma dane do wpisania w kod oraz wytyczne (PDF / instrukcja) z wymaganą strukturą sekcji. NIE używaj do edycji gotowego .docx bez regeneracji ze skryptu.
license: MIT
---

# Generator Raportów — Pipeline Raportów Akademickich

Skill buduje skrypty Python generujące akademickie raporty studenckie (`.docx`,
opcjonalnie + `.xlsx` z obliczeniami) wg powtarzalnego pipeline'u. Liczby liczone
w kodzie, raport regenerowalny jednym poleceniem `python <skrypt>.py`.

## Zasada nadrzędna

Każdy raport powstaje z **kopii** szablonu `references/szablon-raportu.py` — nie
edytuj szablonu w miejscu. Gdy masz już działający generator danego przedmiotu,
traktuj go jako wzorzec referencyjny i kopiuj jego zamiast szablonu, budując
kolejny raport tego samego typu.

## Kiedy XLSX, kiedy tylko DOCX

- **DOCX + załącznik XLSX** — raport ma obliczenia do przeliczenia (prognozy,
  metryki, tabele liczbowe). Skrypt liczy wszystko w Pythonie i wpisuje te same
  liczby do DOCX i do XLSX.
- **DOCX z osadzonymi wykresami PNG** — raport ilustruje wyniki wykresami, nie
  potrzebuje arkusza. Wykresy w matplotlib → PNG do `wykresy/` → osadzone w DOCX.

Jeśli niejasne — zapytaj użytkownika, czy raport ma być przeliczalny w Excelu.

## Workflow

1. **Zbierz wejścia:** przedmiot, numer/temat raportu, dane liczbowe, wytyczne
   (PDF / instrukcja), skład zespołu, prowadzący. Zapytaj użytkownika, gdzie ma
   powstać skrypt i artefakty raportu — lokalizacji nie zgaduj.
2. **Parser wytycznych** → checklista wymaganych sekcji (sekcja niżej).
3. **Skopiuj szablon:** `references/szablon-raportu.py` → lokalizacja wskazana
   przez użytkownika, np. `_build_raport_<XX>.py`. Ustaw blok KONFIGURACJA STYLU
   pod wymagania przedmiotu (font, interlinia, kolory nagłówków i tabel).
4. **Wstaw dane:** wypełnij sekcję `DANE WEJŚCIOWE` tablicami i funkcjami
   obliczeniowymi specyficznymi dla raportu.
5. **Złóż sekcje merytoryczne** helperami z szablonu, w kolejności z checklisty.
6. **Uruchom:** `python <skrypt>.py`. Sprawdź, że `.docx` (i `.xlsx` /
   `wykresy/`) powstały.
7. **Self-review** wg `references/checklista-raportu.md`.

## Parser wytycznych

Przed pisaniem raportu wyciągnij z wytycznych jego wymaganą strukturę:

1. Przeczytaj wytyczne (PDF wytycznych, instrukcja laboratoryjna). Jeśli `Read`
   nie czyta PDF — fallback `pdftotext` (np. z Git for Windows:
   `C:\Program Files\Git\mingw64\bin\pdftotext.exe -layout in.pdf out.txt`).
2. Wypisz listę wymaganych sekcji i podsekcji + twarde wymogi (min. liczba
   pozycji bibliografii, wymagane tabele, „metoda z wykorzystaniem AI" itp.).
3. Zwróć użytkownikowi checklistę `[ ]` per wymagana sekcja — to szkielet
   kroku 5 workflow.

## Konwencje obowiązkowe

Pełna lista w `references/checklista-raportu.md`. Najważniejsze:
- Neutralny język AI — „model językowy klasy LLM", nigdy nazw dostawców.
- `print()` tylko ASCII (`->`, nie `→`) — polska konsola często używa cp1250.
- Liczby w tekście raportu — przecinek dziesiętny (helper `fmt`).
- Skrypt idempotentny — ponowne uruchomienie nadpisuje artefakty.
- Wszystkie liczby liczone w kodzie — żadnej liczby wpisanej ręcznie do treści.

## Pułapki techniczne

- Czytanie PDF bywa zawodne — używaj `pdftotext` zamiast narzędzi renderujących
  strony do obrazu.
- `pip install` bywa zawodny (brak Internetu) — ponawiaj, dodawaj `--user`.
- Tablice obliczeń z zapasem na prognozę ex ante (rozmiar `N+2`, nie `N+1`),
  jeśli raport zawiera prognozowanie.

## Niejasne przypadki

- Dane wejściowe niepewne lub przyjęte projektowo → zaznacz to użytkownikowi.
- Brak wytycznych → zapytaj użytkownika o wymaganą strukturę, nie zgaduj.
