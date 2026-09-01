# ZEVO

A premium community-based fitness platform designed to help users stay motivated and consistent through teamwork, social accountability, and friendly competition.

---

## 🚀 Current Progress

### Phase 1 — Foundation & Authentication ✅

- Feature-first architecture with scalable local packages
- BLoC state management with Repository/Service abstraction
- Supabase + PostgreSQL backend integration
- Row Level Security (RLS) configured
- ZEVO design system with premium black and royal-purple theme
- Splash screen with authentication session checking
- Login and account creation with email/password authentication
- Session persistence and logout
- Automatic profile creation through PostgreSQL trigger
- Git/GitHub version control and team workflow configured

### Phase 2 — Onboarding & Core UI 🚧

- Solo or Squad journey selection
- Solo dashboard
- Solo Division empty/locked state
- Solo Squad empty/locked state
- Squad dashboard UI
- Role-based Home dashboard routing
- Bottom navigation
- Dashboard, Division, Squad and Journey routing
- UI tests for routing and major screens
- Mock data for Squad dashboard UI

> Phase 2 is currently focused on establishing the core user journeys and UI structure. Some Squad and Workout functionality still uses placeholders/mock data.

---

## 🗺️ Project Roadmap

### 📋 Phase 2 — Onboarding

- [x] Solo or Squad journey selection
- [x] Solo user flow
- [x] Locked Squad features for Solo users
- [x] Onboarding state management
- [x] Solo dashboard UI
- [x] Division empty state
- [x] Squad empty state
- [x] Core navigation and routing

### 👥 Phase 3 — Squad System

- [ ] Create squads
- [ ] Join squads
- [ ] Squad dashboard and members
- [ ] Invitations and squad roles
- [ ] Squad capacity and success flows
- [ ] Connect Squad UI to backend data

### 🏋️ Phase 4 — Workout System

- [ ] Workout logging
- [ ] Workout history
- [ ] Point calculation
- [ ] Weekly contribution tracking
- [ ] 300-point weekly competitive cap

### 🏆 Phase 5 — Divisions & Leaderboards

- [ ] Rookie → Athlete → Pro → Elite → Legend
- [ ] Weekly squad rankings
- [ ] Division leaderboard
- [ ] Promotion/relegation rules

### 👑 Phase 6 — Squad Champion

- [ ] Weekly Squad Champion
- [ ] Champion celebration
- [ ] Shareable 1:1 Champion card
- [ ] Native social sharing

### ✨ Phase 7 — Integration & Polish

- [ ] Complete feature integration
- [ ] Animations and transitions
- [ ] Loading, error and empty states
- [ ] Responsive UI
- [ ] Performance optimization

### 🧪 Phase 8 — Testing & Security

- [ ] Unit testing
- [ ] Integration testing
- [ ] RLS and backend security verification
- [ ] Edge-case testing
- [ ] Performance testing

### 🚀 Phase 9 — Production Release

- [ ] Production configuration
- [ ] Android release build and signing
- [ ] Final testing
- [ ] Google Play Store deployment

---

## 🏗️ Architecture

ZEVO uses a feature-first Flutter architecture with reusable local packages.

```text
zevo/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   ├── errors/
│   │   ├── router/
│   │   └── theme/
│   │
│   └── features/
│       ├── auth/
│       ├── dashboard/
│       ├── division/
│       ├── journey/
│       └── squad/
│
├── packages/
│   ├── auth/
│   ├── division/
│   ├── squad/
│   └── workout/
│
└── test/