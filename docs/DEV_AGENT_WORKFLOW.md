# Dev Agent Workflow

Uniwersalny workflow dla agentów developerskich (Scotty, O'Brien, Torres). Każdy dev agent realizuje zadania end-to-end: od analizy issue do gotowego PR.

## Goal

Realizacja issue/story z GitHub — analiza AC, plan techniczny, implementacja via Claude Code/Codex, weryfikacja, PR.

**Success criteria:** PR jest zielony (build + unit testy pass), spełnia AC, zgodny z CLAUDE.md/AGENTS.md.

**Stopping conditions:**
- PR stworzony i zielony → sukces, przekaż dalej
- Brak CLAUDE.md/AGENTS.md w repo → eskalacja (Riker/człowiek)
- Build fail po 3 retry → eskalacja
- Niejasne AC / brak informacji → eskalacja

## Agent Loop

### 1. RECEIVE — Przyjmij zadanie

Źródło zadania określa ścieżkę zwrotną:
- **Od Rikera (agent-to-agent):** PR → wróć do Rikera (szuka reviewera)
- **Od człowieka (bezpośrednio):** PR → wróć do człowieka (zapytaj: PR czy push bezpośrednio?)

Zapamiętaj źródło — potrzebne na końcu.

### 2. ANALYZE — Analiza issue

1. Pobierz issue z GitHub (`gh issue view`)
2. Przeczytaj **Acceptance Criteria** — to twój kontrakt
3. Przeczytaj **docs projektu:**
   - `CLAUDE.md` / `AGENTS.md` — reguły dla implementacji
   - `docs/` — architektura, NFR, stos technologiczny, branching strategy
4. **Check:** Czy `CLAUDE.md` i `AGENTS.md` istnieją?
   - ❌ Nie → **STOP.** Zwróć zadanie do Rikera/człowieka: "Brak CLAUDE.md/AGENTS.md — potrzebuję wytycznych"
   - ✅ Tak → kontynuuj

### 3. PLAN — Plan techniczny

1. Zidentyfikuj pliki do zmiany/stworzenia
2. Zaplanuj architekturę zmian (zgodnie z docs)
3. Określ branch name (wg branching strategy z docs, domyślnie: `feature/issue-{N}-{slug}`)
4. Zaplanuj unit testy (obowiązkowe dla każdej klasy)
5. Oszacuj złożoność — czy zmieści się w jednej sesji Claude Code/Codex?

Raportuj na Telegram: "🔧 Zaczynam #{N}: {tytuł}. Plan: {krótki opis}"

### 4. IMPLEMENT — Implementacja

1. Upewnij się że repo jest aktualne (`git pull`)
2. Stwórz branch wg planu
3. Zlecaj implementację do **Claude Code/Codex:**
   - Przekaż: opis zadania, AC, plan techniczny, ścieżki plików
   - Claude Code/Codex pracuje wg `CLAUDE.md` / `AGENTS.md` z repo
   - Kontroluj postęp — sprawdzaj output
4. Po implementacji: **unit testy muszą istnieć** (reguła z CLAUDE.md)

### 5. VERIFY — Weryfikacja

1. **Build:** Czy projekt się kompiluje/buduje?
2. **Testy:** Czy unit testy przechodzą?
3. **AC:** Czy każde Acceptance Criterion jest pokryte?
4. **Reguły:** Czy CLAUDE.md/AGENTS.md spełnione?

**Jeśli build/testy FAIL:**
- Analizuj błąd
- Zlecaj naprawę do Claude Code/Codex
- Retry (max 3 próby)
- Po 3 failach → **STOP.** Eskalacja do Rikera/człowieka z diagnostyką

### 6. PR — Stwórz Pull Request

Dopiero gdy build jest **zielony**:
1. Push branch
2. Stwórz PR (`gh pr create`)
   - Tytuł: `[#{N}] {opis}`
   - Body: opis zmian, checklist AC, link do issue
   - Linkuj issue (`Closes #{N}`)
3. Raportuj na Telegram: "✅ PR ready: #{N} {tytuł} → {link}"

### 7. RETURN — Przekaż dalej

- **Task od Rikera:** Wróć do Rikera — "PR #{pr} gotowy do review"
- **Task od człowieka:** Wróć do człowieka — "PR #{pr} gotowy, zrobiłem X, Y, Z"

### 8. REVIEW FEEDBACK — Obsługa uwag z review

Gdy reviewer (inny agent lub człowiek) zgłasza uwagi:
1. Przeczytaj komentarze
2. Zaplanuj poprawki
3. Zlecaj poprawki do Claude Code/Codex
4. Upewnij się że build jest zielony
5. Resolve conflicts jeśli main się zmienił
6. Merge (jeśli approved)

## Eskalacja

| Sytuacja | Eskaluj do | Komunikat |
|----------|-----------|-----------|
| Brak CLAUDE.md/AGENTS.md | Riker/człowiek | "Brak wytycznych — potrzebuję CLAUDE.md/AGENTS.md" |
| Niejasne AC | Riker/człowiek | "AC #{n} niejasne — nie wiem jak przetestować" |
| Build fail po 3 retry | Riker/człowiek | "Build fail — diagnostyka: {opis}" |
| Issue za duże | Riker | "Issue #{N} za duże — proponuję podzielić na: ..." |
| Merge conflicts | Sam rozwiąż | Resolve + rebuild + verify |

## Guardrails

- **Nie push na main/master** — zawsze branch + PR
- **Unit testy obowiązkowe** — każda nowa klasa ma testy
- **Max 3 retry** na build fail
- **Raportuj na Telegram** — start, PR ready, eskalacja
- **Audit trail** — loguj do memory/YYYY-MM-DD.md
- **Czytaj docs projektu** — nie zgaduj architektury, stosu, konwencji
- **CLAUDE.md/AGENTS.md to prawo** — nie łam reguł z tych plików

## Flow stanów issue

```
Ready (od Rikera)
  → InProgress (agent pracuje)
    → PR Created (build zielony)
      → Review (reviewer sprawdza)
        → Poprawki? → InProgress (autor poprawia) → Review
        → Approved → Merge → QA (człowiek testuje manualnie)
```
