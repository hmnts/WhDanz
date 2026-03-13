# AGENTS.md - WhDanz Development Guide

## Overview
WhDanz is a Flutter mobile app for dance correction with AI and social features. The main project is in the `whdanz/` subdirectory.

---

## Build, Lint, and Test Commands

### Flutter Commands (run from `whdanz/` directory)

| Command | Description |
|---------|-------------|
| `flutter pub get` | Install dependencies |
| `flutter run` | Run the app |
| `flutter run -d <device_id>` | Run on specific device |
| `flutter build ios` | Build iOS app |
| `flutter build apk` | Build Android APK |
| `flutter build web` | Build web version |

### Code Analysis & Linting
```bash
flutter analyze              # Run static analysis (equivalent to linting)
flutter analyze --no-fatal-infos   # Run without failing on info warnings
```

### Testing
```bash
flutter test                  # Run all tests
flutter test test/widget_test.dart         # Run single test file
flutter test --name="test name"  # Run tests matching name pattern
flutter test test/widget_test.dart --name="App smoke test"
```

---

## Code Style Guidelines

### Project Structure
```
whdanz/lib/
  core/           # Shared services, theme, constants, widgets, router
  features/       # Feature-based modules
    <feature>/
      domain/     # Models, business logic, providers
      data/       # Data sources, repositories implementation
      presentation/  # UI screens, widgets
```

### Imports
- Use package imports: `import 'package:package_name/path.dart';`
- Group imports in this order: dart: -> package: -> relative
- Group external packages first, then relative imports
```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/user_model.dart';
```

### Naming Conventions
- **Files**: snake_case (e.g., `user_model.dart`, `auth_notifier.dart`)
- **Classes**: PascalCase (e.g., `UserModel`, `AuthNotifier`)
- **Functions/variables**: camelCase (e.g., `signIn`, `currentUser`)
- **Constants**: camelCase with k prefix (e.g., `kDefaultTimeout`)
- **Enums**: PascalCase, values UPPER_SNAKE_CASE

### Types and Type Safety
- Use explicit types for function parameters and return values
- Prefer `const` constructors when possible
- Use `final` for variables that are assigned once
- Nullable types (`?`) should be explicit: `String? photoURL`
- Use type inference for local variables when obvious

### Widgets and UI
- Use `const` for stateless widgets
- Prefer builder constructors for widgets with dependencies
- Extract widgets into separate files for reusability
- Use `Key` for widgets that need stable identity

### State Management (Riverpod)
- Use `StateNotifier` for complex state with actions
- Use `Provider` for simple computed values
- Use `FutureProvider` for async data
- Follow pattern: `AuthState` + `AuthNotifier` + `authProvider`

### Error Handling
- Use try-catch blocks for async operations
- Catch specific exceptions (e.g., `FirebaseAuthException`)
- Store error messages in state for UI display
- Provide user-friendly error messages

```dart
try {
  final user = await _firebaseService.signInWithEmailAndPassword(email, password);
  state = state.copyWith(user: user);
} on FirebaseAuthException catch (e) {
  state = state.copyWith(error: e.message);
}
```

### Model Classes
- Use immutable classes with `final` fields
- Implement `fromJson` factory constructor for deserialization
- Implement `toJson` method for serialization
- Include `copyWith` method for immutable updates

```dart
class UserModel {
  final String id;
  final String email;
  
  const UserModel({required this.id, required this.email});
  
  factory UserModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
  UserModel copyWith({String? id}) => UserModel(id: id ?? this.id, ...);
}
```

### Firebase Specific
- Use singleton pattern for services: `FirebaseService.instance`
- Use Firestore timestamps: `Timestamp.fromDate(createdAt)`
- Handle nullability for optional fields with defaults

### Repository Pattern
- Define abstract repositories in `domain/`
- Implement in `data/`
- Inject via Riverpod providers

---

## Common Development Tasks

### Adding a New Feature
1. Create folder: `lib/features/<feature>/`
2. Add domain layer (models, repository interfaces)
3. Add data layer (repository implementations)
4. Add presentation layer (screens, widgets)
5. Add routes in `app_router.dart`
6. Add provider in appropriate domain file

### Running the App
```bash
cd whdanz
flutter run
```

### Debugging
- Use `debugPrint()` for logging (automatically disabled in release)
- Use Flutter DevTools for state inspection
- Check `.dart_tool/` for build artifacts

---

## Notes
- The project uses `flutter_lints` (included in pubspec.yaml dev_dependencies)
- Analysis is configured in `analysis_options.yaml`
- iOS builds require Xcode; Android builds require Android SDK
- Firebase configuration files are in the project root
