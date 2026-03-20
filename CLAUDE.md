# CLAUDE.md — Platforma Treningowa

> **For AI Agent Guidance:** See [AGENTS.md](AGENTS.md) — this file contains all coding standards, architecture patterns, and development workflows.

---

## Repository Overview

Platforma Treningowa is a personalized training platform for runners — training plans, AI-driven adaptation, diet, integrations.

| Component | Technology | Location |
|-----------|------------|----------|
| **Mobile** | Flutter (Dart) | `/mobile` |
| **Backend** | Java + Spring Boot 3.4.x | `/backend` |
| **Web** | React + Bootstrap | `/web` |

This is a **monorepo** — each project is self-contained with its own dependencies and build system.

---

## Quick Links

| Document | Purpose |
|----------|---------|
| [AGENTS.md](AGENTS.md) | **AI agent guidance** — coding standards, patterns, commands |
| [docs/DEV_AGENT_WORKFLOW.md](docs/DEV_AGENT_WORKFLOW.md) | Dev agent workflow (receive → PR) |
| [docs/DEFINITION_OF_READY.md](docs/DEFINITION_OF_READY.md) | Definition of Ready for issues |

---

## Technology Stack

**Mobile:**
- Flutter SDK (latest stable)
- State Management: BLoC pattern with flutter_bloc
- Authentication: OAuth/OIDC (provider TBD)

**Backend:**
- Java 21+ with Spring Boot 3.4.x
- Database: PostgreSQL
- Migrations: Flyway
- Security: Spring Security + JWT
- Build: Gradle

**Web:**
- React 18+ (Create React App or Vite)
- Bootstrap 5 for UI
- Authentication: shared JWT with backend

---

## Quick Start

### Backend
```bash
cd backend
./gradlew bootRun              # Start dev mode
./gradlew test                 # Run all tests
./gradlew build                # Build application
```

### Mobile
```bash
cd mobile
flutter pub get                # Install dependencies
flutter run                    # Run on connected device/emulator
flutter build apk              # Build Android APK
flutter build ios              # Build for iOS
```

### Web
```bash
cd web
npm install                    # Install dependencies
npm run dev                    # Start dev server
npm run build                  # Production build
npm test                       # Run tests
```

---

## Key Features

1. **Training Plans** — ready-made and AI-personalized plans (10km targets: 60/55/50/45/40/35 min)
2. **Onboarding** — questionnaire (age, weight, posture, goals, available days, equipment)
3. **Weekly Adaptation** — AI analyzes completed workouts, adjusts next week
4. **Training Log** — manual logging of completed workouts
5. **User Profile** — personal data, settings, preferences
6. **Subscription** — monthly (~39 PLN) / annual (~29-35 PLN/month)

---

## Architecture Overview

All projects follow **BCE (Boundary-Control-Entity)** pattern with clear separation of concerns.

### Backend (BCE)
```
pl.platformatreningowa.<domain>/
  ├── boundary/      → REST controllers (*Controller.java)
  ├── control/       → Services, repositories, mappers (*Service, *Repository, *Mapper)
  └── entity/        → JPA entities (*Entity), DTOs, Request/Response models
```

### Mobile (ECB)
```
lib/business/<feature>/
  ├── entity/        → Models, BLoC events/states
  ├── boundary/      → BLoCs (business logic)
  └── control/       → Repositories, API clients
```

### Web (Component-based)
```
src/
  ├── components/    → Reusable UI components
  ├── pages/         → Page-level components (routing)
  ├── services/      → API clients, auth
  ├── hooks/         → Custom React hooks
  └── types/         → TypeScript interfaces
```

**See [AGENTS.md](AGENTS.md) for detailed coding standards and patterns.**

---

## Cross-Project Development Order

When implementing features spanning multiple projects:

1. **Backend First** — Define domain model, implement BCE, create migration
2. **Test Backend** — Run tests, verify endpoints
3. **Mobile / Web** — Implement feature with matching architecture
4. **Integration** — End-to-end test
