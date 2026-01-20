# TroPay App - Clean Architecture Structure

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Root widget configuration
│
├── core/                     # Core utilities and shared resources
│   ├── constants/           # App-wide constants
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   ├── theme/               # App theming
│   │   └── app_theme.dart
│   ├── utils/               # Utility functions (validators, formatters, etc.)
│   ├── widgets/             # Reusable widgets across features
│   └── services/            # Core services (API, storage, navigation, etc.)
│
├── features/                # Feature modules (Clean Architecture)
│   ├── auth/                # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/    # Remote & local data sources
│   │   │   ├── models/         # Data transfer objects
│   │   │   └── repositories/   # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/       # Business objects
│   │   │   ├── repositories/   # Repository interfaces
│   │   │   └── usecases/       # Business logic
│   │   └── presentation/
│   │       ├── pages/          # UI pages
│   │       ├── widgets/        # Feature-specific widgets
│   │       └── providers/      # State management
│   │
│   └── home/                # Home feature
│       └── presentation/
│           ├── pages/
│           │   └── home_page.dart
│           └── widgets/
│
└── routes/                  # App navigation
    └── app_router.dart
```

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with feature-based organization:

### Layers

1. **Presentation Layer** (`presentation/`)
   - UI components (pages, widgets)
   - State management (providers, BLoC, etc.)
   - User interaction logic

2. **Domain Layer** (`domain/`)
   - Business entities
   - Repository contracts (interfaces)
   - Use cases (business logic)
   - Independent of frameworks and UI

3. **Data Layer** (`data/`)
   - Repository implementations
   - Data sources (remote API, local database)
   - Data models/DTOs
   - Data transformation logic

### Core Module

The `core/` directory contains:
- **constants/**: App-wide constants (colors, strings, routes, etc.)
- **theme/**: Application theming and styling
- **utils/**: Helper functions, validators, formatters
- **widgets/**: Reusable widgets used across features
- **services/**: Core services (API client, storage, etc.)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- VS Code or Android Studio

### Installation

1. Get dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

3. Run tests:
   ```bash
   flutter test
   ```

## 📝 Adding New Features

To add a new feature, follow this structure:

```
features/
└── your_feature/
    ├── data/
    │   ├── datasources/
    │   ├── models/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    └── presentation/
        ├── pages/
        ├── widgets/
        └── providers/
```

## 🧪 Testing

Tests are organized to mirror the `lib/` structure:
- Unit tests for domain layer
- Widget tests for presentation layer
- Integration tests for complete flows

## 📚 Best Practices

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Dependency Rule**: Dependencies point inward (presentation → domain ← data)
3. **Feature-based**: Code organized by features, not by type
4. **Testability**: Business logic is framework-independent and easy to test
5. **Reusability**: Common widgets and utilities in `core/`

## 🔄 Migration Notes

The project has been refactored from the default Flutter template to follow Clean Architecture:
- Original `MyApp` widget moved to `app.dart`
- Home page extracted to `features/home/presentation/pages/`
- Theme configuration in `core/theme/`
- Routing centralized in `routes/app_router.dart`

All existing functionality has been preserved while improving code organization and maintainability.
