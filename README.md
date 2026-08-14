# ZEVO — Social Fitness Platform

TRAIN TOGETHER. RISE TOGETHER.

ZEVO is a premium social fitness mobile application designed for squad-based accountability, weekly division competition, and fitness motivation. 

This repository is organized as a clean, scalable monorepo using feature-first principles and local Dart/Flutter packages to enforce a strict boundary between UI presentation and data/domain services.

---

## Architecture Overview

```
                      ZEVO APP
                         │
                  FEATURE UI / VIEW
                         │
                       BLoC
                         │
                FEATURE REPOSITORY
                         │
                 FEATURE SERVICE
                         │
                DATABASE CLIENT
                         │
                     SUPABASE
                         │
            ┌────────────┴────────────┐
            │                         │
      PostgreSQL                Supabase Auth
            │
      Secure RPC /
      DB Functions
```

- **Strict Dependency Direction**: View → BLoC → Repository → Service → Database Client → Supabase. The presentation layer never queries the database client directly, keeping data concern changes decoupled from widgets.
- **Supabase Backend**: Real-time database and secure PostgreSQL functions/triggers to prevent client-side score manipulation.
- **BLoC State Management**: Clean loading, success, and failure states for all reactive workflows.

---

## Monorepo Layout

```
zevo/
├── apps/
│   └── zevo_app/                # Main Flutter application (Theme, Router, BLoC UI)
└── packages/
    ├── database_client/         # Centralized Supabase initialization & config
    ├── auth/                    # Auth repository & UserProfile models
    ├── squad/                   # Squad creation, invite, and member services
    ├── workout/                 # Workout logging & point calculations
    └── division/                # Divisions leaderboard & Squad Champion services
```

---

## Development Setup

### Prerequisite Environment Variables
Before running the application, make sure to set the Supabase keys via Flutter's compile-time `--dart-define` flags. 

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
2. Feed these variables to the compiler at run time:
   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key
   ```

---

## Commands

### 1. Resolve Dependencies
From the root directory, resolve package paths:
```bash
# In each package and app folder:
flutter pub get
```

### 2. Static Analysis
Run static analysis to verify Dart guidelines:
```bash
flutter analyze
```

### 3. Run Unit Tests
Run testing suites:
```bash
flutter test
```
