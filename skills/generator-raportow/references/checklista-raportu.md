# Checklista raportu — struktura i konwencje

Reference dla skilla `generator-raportow`. Przejdź obie listy przed oddaniem raportu.

## A. Struktura raportu akademickiego

Wspólny szkielet. Dopasuj do wytycznych przedmiotu — część pozycji jest opcjonalna:

- [ ] Strona tytułowa — przedmiot, tytuł raportu, podtytuł (firma / system pracy)
- [ ] Dane studentów — skład zespołu, numery albumów, prowadzący
- [ ] Streszczenie PL (+ EN / abstract, jeśli wymaga przedmiot)
- [ ] Spis treści
- [ ] Wykaz oznaczeń / skrótów (jeśli raport używa symboli)
- [ ] Wstęp — cel raportu, kontekst, powiązanie z poprzednimi raportami
- [ ] Sekcje merytoryczne — w kolejności z wytycznych
- [ ] Wnioski / podsumowanie / rekomendacje
- [ ] Bibliografia
- [ ] Wykaz tabel i wykaz wykresów (jeśli wymaga przedmiot)
- [ ] Załączniki (np. arkusz `.xlsx`, karty pomiarowe)

## B. Konwencje obowiązkowe

- [ ] **Neutralny język AI** — jeśli raport powstał z pomocą AI, pisz „model
      językowy klasy LLM"; nie podawaj nazw dostawców („Claude", „GPT",
      „Anthropic", „OpenAI"). Wzmianka o AI tylko tam, gdzie wymagają wytyczne.
- [ ] Nazwy metod w tabelach/wykresach bez „AI"/nazw modeli (np. „Dekompozycja
      sezonowa", nie „AI — dekompozycja sezonowa").
- [ ] `print()` tylko ASCII — `->` zamiast `→` (polska konsola często cp1250).
- [ ] Liczby w tekście raportu — przecinek dziesiętny (helper `fmt`).
- [ ] Skrypt idempotentny — `python <skrypt>.py` nadpisuje artefakty, można
      uruchamiać wielokrotnie bez czyszczenia.
- [ ] Wszystkie liczby liczone w kodzie — żadnej liczby wpisanej ręcznie do treści.
- [ ] Liczby w DOCX i XLSX spójne — z tej samej tablicy danych wejściowych.
- [ ] Tablice obliczeń z zapasem na prognozę ex ante — rozmiar `N+2`, nie `N+1`
      (dotyczy raportów z prognozowaniem).
- [ ] Strona tytułowa — poprawny skład zespołu i prowadzący (sprawdź wytyczne
      i poprzednie raporty przedmiotu).
