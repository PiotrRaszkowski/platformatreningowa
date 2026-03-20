# Platforma Treningowa

Personalizowana platforma treningowa dla biegaczy i osób budujących zdrowe nawyki. Repozytorium jest monorepo z trzema aplikacjami przygotowanymi pod rozwój MVP.

## Struktura repo

```text
backend/   Spring Boot 3.4.x, Java 21, BCE, endpoint /api/health
mobile/    Flutter app scaffold, Android+iOS ready, flutter_bloc + ECB
web/       React + TypeScript + Bootstrap companion app
docs/     Dokumentacja produktu i workflow
```

## Architektura

- **Backend**: pakiety BCE per domena (`boundary`, `control`, `entity`)
- **Mobile**: ECB per feature w `lib/business/<feature>/`
- **Web**: komponenty, strony, hooki i serwisy w TypeScript

Startowy scaffold obejmuje moduł health, żeby wszystkie trzy aplikacje miały prosty wspólny kontrakt integracyjny.

## Quick start

### Backend
```bash
cd backend
./gradlew test
./gradlew bootRun
```

### Web
```bash
cd web
npm install
npm test
npm run build
npm run dev
```

### Mobile
```bash
cd mobile
flutter pub get
flutter analyze
flutter test
flutter build web
```

## Continuous Integration

Workflow `.github/workflows/ci.yml` uruchamia:
- backend: `./gradlew test build`
- web: `npm ci`, `npm test`, `npm run build`
- mobile: `flutter pub get`, `flutter analyze`, `flutter test`, `flutter build web`

## Co jest gotowe po issue #2

- backendowy szkielet Spring Boot 3.4.x z endpointem zdrowia
- webowy scaffold React + TypeScript + Bootstrap z testem renderowania
- mobilny scaffold Flutter z `flutter_bloc`, ECB i testami startowymi
- wspólny root README i `.gitignore` dla monorepo

## Linki

- [Kanban Board](https://github.com/users/PiotrRaszkowski/projects/3/views/1)
- [CLAUDE.md](CLAUDE.md)
- [AGENTS.md](AGENTS.md)
