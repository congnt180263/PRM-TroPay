# Flutter Project Refactoring - Terminal Commands Reference

## Commands Used for Reorganization

### 1. Create Directory Structure

```powershell
# Navigate to lib folder
cd c:\Users\DELL\Desktop\Flutter-TroPay\PRM-TroPay\tropay_app\lib

# Create all directories at once
New-Item -ItemType Directory -Force -Path `
  core\constants, `
  core\theme, `
  core\utils, `
  core\widgets, `
  core\services, `
  features\auth\data\models, `
  features\auth\data\repositories, `
  features\auth\data\datasources, `
  features\auth\domain\entities, `
  features\auth\domain\repositories, `
  features\auth\domain\usecases, `
  features\auth\presentation\pages, `
  features\auth\presentation\widgets, `
  features\auth\presentation\providers, `
  features\home\presentation\pages, `
  features\home\presentation\widgets, `
  routes
```

### 2. View Directory Structure

```powershell
# Display folder tree
tree /F lib
```

### 3. Verify Code Quality

```powershell
# Run Flutter analyzer
flutter analyze

# Format all Dart files
dart format lib/

# Run tests
flutter test
```

### 4. Clean and Get Dependencies (if needed)

```powershell
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Files Created

### Core Files
- `lib/app.dart` - Root app widget
- `lib/core/constants/app_colors.dart` - Color constants
- `lib/core/constants/app_strings.dart` - String constants
- `lib/core/theme/app_theme.dart` - Theme configuration

### Feature Files
- `lib/features/home/presentation/pages/home_page.dart` - Home page

### Routing
- `lib/routes/app_router.dart` - App navigation

### Placeholder Files (.gitkeep)
Created in empty directories to preserve structure:
- Auth data, domain, presentation folders
- Home widgets folder
- Core utils, widgets, services folders

## Files Modified

- `lib/main.dart` - Updated to import from `app.dart`
- `test/widget_test.dart` - Updated import path

## No Files Deleted

All original files were preserved. The default demo code from `main.dart` was extracted into:
- `app.dart` (MyApp widget)
- `features/home/presentation/pages/home_page.dart` (HomePage widget)

## Quick Commands for Daily Use

```powershell
# Navigate to project
cd c:\Users\DELL\Desktop\Flutter-TroPay\PRM-TroPay\tropay_app

# Check for issues
flutter analyze

# Format code
dart format .

# Run app
flutter run

# Run tests
flutter test

# Hot reload (when app is running)
# Press 'r' in terminal

# Hot restart (when app is running)
# Press 'R' in terminal
```

## Adding a New Feature

```powershell
# Example: Adding a "profile" feature
cd lib\features
New-Item -ItemType Directory -Force -Path `
  profile\data\models, `
  profile\data\repositories, `
  profile\data\datasources, `
  profile\domain\entities, `
  profile\domain\repositories, `
  profile\domain\usecases, `
  profile\presentation\pages, `
  profile\presentation\widgets, `
  profile\presentation\providers
```

## Git Commands (Optional)

```powershell
# Initialize git (if not done)
git init

# Add all files
git add .

# Commit the refactored structure
git commit -m "Refactor: Reorganize project with Clean Architecture"

# View changes
git status
```
