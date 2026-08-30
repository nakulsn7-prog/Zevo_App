# ZEVO

A modern, high-performance Flutter mobile application featuring clean architecture, reactive state management with Bloc, and a robust Supabase backend integration.

---

## 🚀 What's Completed So Far (Phase 1: Core & Authentication)

We have built a production-ready authentication pipeline and foundation:

### 1. Architecture & Packages
- **Multi-package Architecture**: Modularized into sub-packages (`auth` and `database_client`) to keep core logic isolated and highly testable.
- **Routing**: Configured declarative routing using `go_router` supporting seamless redirects (`/`, `/login`, `/signup`, `/authenticated`).
- **State Management**: Built on `flutter_bloc` for structured auth state flow.

### 2. User Interfaces & Flows
- **Splash Screen**: Checks live session persistence on app cold launch to auto-redirect authenticated users to the home dashboard.
- **Login Screen**: Clean input handling, interactive form states, and robust error handling.
- **Create Account Screen**: 
  - Complete signup registration flow.
  - Custom scrollable **Terms & Conditions** interactive bottom-sheet modal.
- **Authenticated Hub**: A landing screen with an active logout trigger.

### 3. Custom Branding & Launcher Setup
- Set app launcher name to **ZEVO**.
- Formatted and generated responsive Android app icons from the custom purple emblem, centered perfectly on a premium solid black background.

---

## 🗺️ Project Roadmap (Remaining Phases)

### 📋 Phase 2: Core Dashboard & Navigation
- [ ] **Home Interface**: Category listings, featured products carousel, and personalized greeting dashboard.
- [ ] **Global Navigation**: Sleek persistent bottom navigation bar or custom drawer.
- [ ] **Search & Filter Engine**: Interactive search bar with instant autocomplete suggestions and category tags.

### 🛒 Phase 3: Product Discovery & Cart
- [ ] **Product Details Screen**: High-quality image viewer, detailed product specifications, reviews, and interactive "Add to Cart" button.
- [ ] **Shopping Cart Management**: Quantity increments, real-time total calculator, item removal, and promotion code validations.
- [ ] **Order Checkout Pipeline**: Address forms, order summary validations, and initial payment gateway stubs.

### 🔔 Phase 4: Notifications & Real-Time Sync
- [ ] **Live Notifications**: Setup Firebase/Supabase push notifications for promotions, updates, and reminders.
- [ ] **Order Status Tracker**: Real-time updates of order processing, shipping, and delivery milestones.

### 🧪 Phase 5: Testing, Optimizations & Release
- [ ] **Code Quality**: Unit tests for Blocs and repository layers.
- [ ] **Performance Audit**: Optimization of heavy images, code shrinking, and memory leak analysis.
- [ ] **App Store Readiness**: Preparing icons, metadata, and bundle configurations for production releases.

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (v3.22.0 or higher recommended)
- Dart SDK
- Supabase account with configured database tables

### Local Development Setup
1. **Initialize Project Dependencies**:
   ```bash
   flutter pub get
   ```
2. **Generate Launcher Icons**:
   ```bash
   dart run flutter_launcher_icons
   ```
3. **Launch Project**:
   ```bash
   flutter run
   ```
