
# myCoinPollMetaMask

A Flutter app for interacting with MetaMask and managing coin polls.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Repository Setup](#repository-setup)
- [Running the App](#running-the-app)
- [Building Release Artifacts](#building-release-artifacts)
- [Debugging & Tips](#debugging--tips)
- [CI / CD Recommendations](#ci--cd-recommendations)
- [Code Style & Contributing](#code-style--contributing)
- [Common Issues & Fixes](#common-issues--fixes)

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
