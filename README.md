
# MY-COIN-POLL

A Crypto launchpad platform designed to support community-driven token launches. Enabled IDO participation, staking, vesting, and voting features, empowering investors to access early-stage blockchain projects within the ECM ecosystem.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Repository Setup](#repository-setup)
- [Running the App](#running-the-app)
- [Building Release Artifacts](#building-release-artifacts)
- [Debugging & Tips](#debugging--tips)
- [CI / CD Recommendations](#ci--cd-recommendations)
- [Code Style & Contributing](#code-style--contributing)
- [Common Issues & Fixes](#common-issues--fixes)
- [Project Module Guide](#project-module-guide)

---

## Prerequisites

Install the following before working on the project:

- Git
- Flutter SDK (stable channel recommended). Install: https://flutter.dev/docs/get-started/install
- Dart (bundled with Flutter)
- Android Studio or VS Code (with Flutter & Dart extensions)
- Xcode (macOS only, for iOS builds)
- For web: Chrome recommended
- Optional: CocoaPods for iOS (`sudo gem install cocoapods` or `brew install cocoapods`)

Firebase setup (required to use Firebase Services Events)
- Download `google-services.json` and place it in `android/app/`.
- Add the Firebase Gradle plugin to `android/build.gradle` and `android/app/build.gradle` as documented by Firebase.

Verify environment:
```bash
flutter doctor
```

---

## Repository Setup

1. Clone the repository:
```bash
git clone https://github.com/devhimuBlockVerse/myCoinPollMetaMask.git
cd myCoinPollMetaMask
```

2. Checkout the main branch (or the branch your team uses):
```bash
git checkout main
```

3. Install dependencies:
```bash
flutter pub get
```

4. If present, initialize submodules:
```bash
git submodule update --init --recursive
```
 
---

## Running the App

Run on default connected device/emulator:
```bash
flutter run
```

List devices:
```bash
flutter devices
```

Run on a specific device:
```bash
flutter run -d <device-id>
```

Run for web:
```bash
flutter run -d chrome
```

For flavors/alternate entrypoints:
```bash
flutter run --flavor staging -t lib/main_staging.dart
```

---

## Building Release Artifacts

Android APK:
```bash
flutter build apk --release
```

Android App Bundle:
```bash
flutter build appbundle --release
```

---

## Debugging & Tips

- Hot reload: press `r` in terminal or use IDE shortcut.
- Hot restart: press `R`.
- Clean and reinstall:
```bash
flutter clean
flutter pub get
```
---

## CI / CD Recommendations

- Use CI to run `flutter analyze`, `flutter pub get`, and build steps.
- Store secrets (keystore, service files, env vars) in CI secrets and inject at runtime.
- Cache pub and Gradle dependencies for faster runs.

---

## Code Style & Contributing

- Format code:
```bash
dart format .
```
- Static analysis:
```bash
flutter analyze
```
- Branch naming: `feat/`, `fix/`, `chore/` etc.
- Submit PRs against `main` (or your project's primary branch).

---

## Common Issues & Fixes

- Pod install fails:
```bash
cd ios
pod install --repo-update
```
- Device not found:
```bash
flutter devices
```
- Gradle build failures:
```bash
cd android
./gradlew clean
```
---
## Project Module Guide

This Document describes the purpose and contents of each directory indside lib/ to help new developers understand the project layout and where to find or add code. It focuses only on the directories present in the repository root `lib/`

Contents 
- lib/application/
  - lib/application/data/
  - lib/application/domain/
  - lib/application/module/
  - lib/application/presentation/
- lib/connectivity/
- lib/framework/
  - lib/framework/components/
  - lib/framework/res/
  - lib/framework/utils/
  - lib/framework/widgets/
- lib/generated/
- lib/logrocket/

Guiding Principles 
- Keep UI (Presentation) seperate from business/domain logic and data access .
- Use the framework/ area for reusable widgets, styles , assets, and utility helpers used across the app.
- Keep connectivity and enviroment/dependency wiring isolated so tests can replace implementations easily.
- Generated/ contains tools-generated code — do not edit manually, regenerate from the source tool when needed.
---
Directory Details 

1) lib/application/
Purpose
- Application-level structure for the app's features and flows. This is the "feature/application" layer that coordinates domain logic, modules, data and presentation.

Subdirectories
- lib/application/data/
  - Purpose: Data layer implementations (Repositories , Data sources , DTOs, Mappers). Code here interacts with remote APIs, Local Persistence, or other External Systems.
  - What to put here : Repository implementations, API clients, cache adapters, serialization helpers.
  - Testing: Unit-test repositories and data transformations. Provide mocks for remote clients.

- lib/application/domain/
  - Purpose: Domain models, interfaces , use-cases (Business logic). This is where pure logic and core entities live.
  - What to put here: entities, value objects, domain services, repository interfaces, use-case classes.
  - Testing: Focus on pure unit tests without external dependencies.
 
- lib/application/module/
  - Purpose: feature/Modile wiring (dependecy injection per feature), and grouping of feature-specific providers.
  - What to put here: DI providers/factories for the module, registration code, module-level configuration.
  - Testing: Provide test helpers to create a module with test/mocked dependencies.

- lib/application/presentation/
  - Purpose: Feature UI code — screens, view models/controllers, state management for the feature.
  - What to put here: Widgets, pages, view-models, controllers, widget-specific bindings.
  - Testing: Widget tests and controller/view-model unit tests. Use mocked domain/use-case implementations.
---
2) lib/connectivity.
Purpose
- Centralized connectivity and coffline/online handling for the application. This module handles network status detection and exposes it to the rest of the app.
---
3) lib/framework/
Purpose
- Shared , app-wide building blocks: design system widgets, resource constants, helper utils, and UI components that are resed accross features.
---
Subdirectories
- lib/framework/components/
  - Reusable, composite UI compoenents (cards, form rows, list items) used across multiple features.

- lib/framework/res/
  - Static resources: color palettes, text styles, dimension constants, theme definitions and other resource constants.

- lib/framework/utils/
  - Cross-cutting utility functions/helpers (formatters, validators, data helpers).

- lib/framework/widgets/
  - Small, reusable widgets (buttons, inputs, layout helpers) intended for app consistency.
---
4) lib/generated/
Purpose
- Auto-generated assets and other code produced by build tools (asset codegen, localization, or API clients).
- Example file:
  - lib/generated/assets.dart — generated asset references for compile-time-safe usage of images/fonts/etc.
---
Do not edit by hand:
- Treat these files as generated artifacts. If you need ti change content, change the source (e.g., asset files, codegen config) and re-run the generation step.
---
5) lib/logrocket/
Purpose
- Helpers and wrappers for LogRocket (or other analytics / session replay tooling). Centralizes logging and event tracking integration.

---
Known file
- lib/logrocket/logrocket_utils.dart — utilities to initialize LogRocket, record events, adn convert app errors into tracked events.

- File-to-check quickly when debugging startup or environment issues:
  - main.dart (app bootstrap)
  - lib/firebase_options.dart (Firebase Configuration)
  - lib/permission_handler_widget.dart (Permission Flow)
  - lib/version-service.dart (Versioning/ Updates)


---
