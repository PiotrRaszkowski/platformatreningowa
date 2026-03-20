# AGENTS.md — Platforma Treningowa

This file provides guidance to AI coding agents (Claude Code, Codex, etc.) when working on this project.

---

## Architecture Patterns

### Backend: BCE Pattern (Spring Boot)

All backend code follows **BCE (Boundary-Control-Entity)** organized by domain:

```
pl.platformatreningowa.<domain>/
├── boundary/ → REST controllers ONLY (*Controller.java)
├── control/ → Services, Repositories, Mappers (*Service, *Repository, *Mapper)
└── entity/ → JPA Entities (*Entity), DTOs, Requests/Responses, Enums
```

**Rules:**
- Dependencies flow: Boundary → Control → Entity
- Controllers should be thin — delegate immediately to services
- JPA entities have `Entity` suffix; DTOs do NOT have `DTO` suffix
- Use MapStruct for mapping between entities and DTOs
- Constructor injection (no `@Autowired` on fields)
- All endpoints return proper HTTP status codes and error responses

### Mobile: ECB Pattern (Flutter)

```
lib/business/<feature>/
├── entity/ → Models, BLoC events/states
├── boundary/ → BLoCs (business logic)
└── control/ → Repositories, API clients
```

**Rules:**
- State management: flutter_bloc (BLoC pattern)
- Proper Event/State classes per feature
- Repositories handle API communication
- Models are immutable

### Web: Component-based (React)

```
src/
├── components/ → Reusable UI components (Bootstrap-based)
├── pages/ → Page-level components (one per route)
├── services/ → API clients, auth service
├── hooks/ → Custom React hooks
├── types/ → TypeScript interfaces/types
└── utils/ → Helper functions
```

**Rules:**
- Functional components with hooks (no class components)
- TypeScript for all files (no `.js`)
- Bootstrap 5 for styling — use Bootstrap classes, don't reinvent
- Custom hooks for shared logic
- API calls in `services/` only — components don't call APIs directly
- Props interfaces defined in same file or `types/`

---

## Domain Alignment

All projects organize code by the same business domains:

| Domain | Purpose |
|--------|---------|
| `auth` | Authentication and registration |
| `onboarding` | User questionnaire, initial assessment |
| `profile` | User profile and settings |
| `plans` | Training plans (ready-made + AI-generated) |
| `training` | Training log, workout execution |
| `adaptation` | Weekly AI adaptation of plans |
| `diet` | Diet recommendations (future) |
| `subscription` | Payment and subscription management |

---

## Development Commands

### Backend (Spring Boot)
```bash
cd backend
./gradlew bootRun                              # Dev mode
./gradlew test                                 # All tests
./gradlew test --tests "ClassName.methodName"   # Single test
./gradlew build                                # Build
```

### Mobile (Flutter)
```bash
cd mobile
flutter pub get           # Install dependencies
flutter run               # Run app
flutter test              # Unit tests
flutter analyze           # Static analysis
flutter build apk         # Build Android
flutter build ios         # Build iOS
```

### Web (React)
```bash
cd web
npm install               # Install dependencies
npm run dev               # Dev server
npm test                  # Tests
npm run build             # Production build
npm run lint              # Linting
```

---

## Coding Standards

### Java (Backend)

1. **Java version**: 21+
2. **Line length**: Max 150 characters
3. **Injection**: Constructor injection only (no field `@Autowired`)
4. **Naming**:
   - Entities: `*Entity` (e.g., `TrainingPlanEntity`)
   - DTOs: No suffix (e.g., `TrainingPlan`, not `TrainingPlanDTO`)
   - Services: `*Service`
   - Controllers: `*Controller`
   - Mappers: `*Mapper`
   - Repositories: `*Repository`
5. **Logging**: SLF4J with `@Slf4j` (Lombok)
6. **Exceptions**: Custom exceptions extending `RuntimeException`, handled by `@ControllerAdvice`

### Dart (Mobile)

1. **Line length**: Max 150 characters
2. **State**: flutter_bloc with proper Event/State classes
3. **Naming**: Dart conventions (camelCase methods, PascalCase classes)
4. **Imports**: Organized (dart, packages, project)

### TypeScript (Web)

1. **Strict mode**: enabled
2. **Components**: Functional with hooks
3. **Naming**: PascalCase for components, camelCase for functions/variables
4. **CSS**: Bootstrap classes primarily, custom CSS only when Bootstrap doesn't cover it
5. **State management**: React Context + useReducer for global state, useState for local

---

## Database: Flyway Rules

**CRITICAL:**
- **NEVER** modify existing migrations
- **ALWAYS** create new migration files for changes
- **Naming**: `V{number}__{description}.sql` (e.g., `V1__create_users_table.sql`)
- Each migration should do ONE thing only
- Include rollback comments where practical

---

## Testing Requirements

### Backend
- Unit test every class (excluding POJOs/entities)
- JUnit 5 + Mockito
- Test naming: `{ClassName}Test`
- Integration tests with `@SpringBootTest` for critical flows

### Mobile
- Unit tests for BLoCs and repositories
- Widget tests for key UI components

### Web
- Unit tests for hooks and services
- Component tests with React Testing Library
- Test naming: `{Component}.test.tsx`

---

## Git Workflow

1. **Branch naming**: `feature/issue-{N}-{slug}` (e.g., `feature/issue-3-registration`)
2. **Commits**: Descriptive messages (1-3 sentences)
3. **NO** AI attribution comments in commits or code
4. **PR required** — never push directly to `main`
5. **PR links issue**: `Closes #{N}` in PR description

---

## Security

- Spring Security with JWT
- Password hashing: BCrypt
- All endpoints require authentication by default
- Public endpoints explicitly annotated
- CORS configured per environment
- Input validation on all endpoints (`@Valid`)

---

## Project Links

- [CLAUDE.md](CLAUDE.md) — Project overview and quick start
- [docs/DEV_AGENT_WORKFLOW.md](docs/DEV_AGENT_WORKFLOW.md) — Dev agent workflow
- [docs/DEFINITION_OF_READY.md](docs/DEFINITION_OF_READY.md) — Issue readiness criteria
- [Kanban Board](https://github.com/users/PiotrRaszkowski/projects/3/views/1)
