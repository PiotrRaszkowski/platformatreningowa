# Definition of Ready (DoR)

Issue jest **Ready** gdy spełnia WSZYSTKIE poniższe kryteria:

## 1. Tytuł
Jasny, konkretny — wiadomo co robimy bez czytania opisu.

## 2. Opis
- Co robimy i dlaczego (user story, spec, lub kontekst)
- Scope — co jest IN, co jest OUT

## 3. Acceptance Criteria
Lista konkretnych, **testowalnych** warunków. Każde kryterium musi odpowiadać na pytanie: **"Jak to zweryfikować?"**

Wzór:
```
- [ ] [Kryterium] → Test: [jak sprawdzić]
```

Przykład:
```
- [ ] Użytkownik może się zarejestrować emailem → Test: POST /api/register z nowym emailem zwraca 201 + tworzy rekord w DB
- [ ] Walidacja formularza blokuje puste pola → Test: submit z pustym emailem pokazuje błąd, request nie wychodzi
- [ ] Po rejestracji redirect na /onboarding → Test: po 201 przeglądarka przenosi na /onboarding
```

## 4. Labels
- Typ: `frontend`, `backend`, `ai`, `legal`, `design`
- Priorytet: `mvp` jeśli dotyczy
- Nie: `epic` (epiki nie idą do devów)

## 5. Brak blockerów
- Żadne wymagane zależności nie są w stanie "Open" bez implementacji
- Jeśli zależy od innego taska — ten task musi być ukończony lub wyraźnie oznaczony jako niezależny

---

## Riker Checklist

Agent Riker sprawdza każdy issue przed przypisaniem:

| # | Sprawdzenie | Fail → |
|---|------------|--------|
| 1 | Ma tytuł? | Komentarz: brak tytułu |
| 2 | Ma opis z kontekstem? | Komentarz: brak opisu |
| 3 | Ma AC z testami? | Komentarz: AC niekompletne — brak sposobu weryfikacji |
| 4 | Każde AC jest testowalne? | Komentarz: wskazuje które AC nie ma testu |
| 5 | Ma labels (typ)? | Dodaje brakujące |
| 6 | Brak blockerów? | Komentarz: wskazuje blokery |

**Pass** = issue dostaje label `ready` i może być przypisany.
**Fail** = Riker komentuje co poprawić, dodaje label `needs-refinement`.
