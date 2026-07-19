# ARCHITECTURE.md

## 1. Purpose

This document defines the architecture of the Flutter Tour Booking application.

The project is a university course project. The architecture must therefore be:

- Simple enough for students to understand
- Clear enough for multiple team members to work together
- Compatible with coding agents such as Codex
- Easy to test and maintain
- Not over-engineered

The project uses:

- Flutter
- Dart
- Feature-first folder organization
- MVVM
- Repository pattern
- Riverpod
- go_router
- Firebase Authentication
- Cloud Firestore (optional for future synchronization)
- SharedPreferences
- SQLite through `sqflite_common_ffi` for local application data
- Stitch MCP for UI generation

## 2. Architecture Summary

The application follows this dependency direction:

```text
View
  ↓
ViewModel
  ↓
Repository
  ↓
Data Source
  ↓
Firebase / Firestore / SharedPreferences / SQLite
```

Dependencies must only point downward. A lower layer must never depend on a higher layer.

```text
Allowed:
View -> ViewModel
ViewModel -> Repository
Repository -> Data Source
Data Source -> Firebase

Not allowed:
Repository -> View
Data Source -> ViewModel
View -> Firebase
View -> Firestore
View -> SharedPreferences
```

## 3. Main Architectural Style

The project uses:

```text
Feature-first + MVVM + Repository
```

### Feature-first

Code is grouped by business feature instead of technical type.

Examples:

- authentication
- tours
- bookings
- profile
- reviews
- admin

This helps team members work on separate features with fewer Git conflicts.

### MVVM

Each feature contains:

- View
- ViewModel
- Model

The View renders UI and forwards user actions. The ViewModel manages presentation state and calls repositories. The Model represents application data.

### Repository Pattern

Repositories provide data to ViewModels. A repository may use Firebase Authentication, Cloud Firestore, SharedPreferences, or SQLite. The ViewModel must not know the implementation details of the data source.

## 4. Project Structure

```text
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   ├── route_names.dart
│   │   └── route_paths.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_spacing.dart
│       ├── app_radius.dart
│       ├── app_text_styles.dart
│       └── app_theme.dart
├── core/
│   ├── constants/
│   ├── errors/
│   │   ├── app_exception.dart
│   │   └── failure.dart
│   ├── services/
│   │   ├── preferences_service.dart
│   │   └── database_service.dart
│   ├── utils/
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── loading_view.dart
│       ├── empty_view.dart
│       └── error_view.dart
├── features/
│   ├── authentication/
│   ├── tours/
│   ├── bookings/
│   ├── profile/
│   ├── reviews/
│   └── admin/
└── firebase_options.dart
```

Each feature should follow this structure:

```text
feature_name/
├── data/
│   ├── data_sources/
│   └── repositories/
├── models/
├── presentation/
│   ├── view_models/
│   ├── views/
│   └── widgets/
└── routes/
```

## 5. Layer Responsibilities

### 5.1 View

The View is responsible for:

- Rendering UI
- Displaying state
- Receiving user input
- Calling ViewModel actions
- Showing loading, empty, error, and success states
- Navigating through callbacks or approved routing helpers

The View must not:

- Call Firebase directly
- Call Firestore directly
- Call SharedPreferences directly
- Call SQLite directly
- Contain business rules
- Contain long asynchronous workflows
- Own shared mutable application state

### 5.2 ViewModel

The ViewModel is responsible for:

- Managing UI state
- Handling user actions
- Validating input when appropriate
- Calling repositories
- Transforming repository results into presentation state
- Handling loading and errors

The ViewModel must not:

- Import UI widgets
- Store BuildContext
- Show dialogs directly
- Show snackbars directly
- Call Firebase SDK directly
- Call Firestore SDK directly
- Call SharedPreferences directly
- Call SQLite directly

Recommended Riverpod types:

- `Notifier`
- `AsyncNotifier`
- `StateNotifier` only when needed for existing code

Riverpod code generation is optional and should not be used unless the team explicitly decides to use it.

### 5.3 Repository

The Repository is responsible for:

- Providing a simple API to ViewModels
- Coordinating one or more data sources
- Converting raw data into application models
- Deciding whether data comes from remote or local storage
- Mapping low-level errors into application errors

Repositories must not:

- Import Flutter UI packages
- Depend on Views
- Depend on ViewModels
- Show UI messages
- Contain Widget code

### 5.4 Data Source

A Data Source is responsible for direct communication with external systems.

Examples:

- FirebaseAuthDataSource
- FirestoreTourDataSource
- SharedPreferencesDataSource
- SQLiteBookingCacheDataSource

A Data Source may call SDK methods, read and write raw data, convert Firebase documents to maps, and throw low-level exceptions. It must not render UI or depend on Views or ViewModels.

### 5.5 Models

Models represent application data.

Examples:

- AppUser
- Tour
- Category
- Booking
- Review

Models should be immutable where possible, use clear field names, provide `fromMap` and `toMap` when stored in Firestore or SQLite, and avoid UI-specific properties.

## 6. Riverpod Architecture

Riverpod is used for dependency injection, ViewModel state management, authentication state, feature state, and app settings state.

Recommended provider hierarchy:

```text
SDK provider
  ↓
Data source provider
  ↓
Repository provider
  ↓
ViewModel provider
  ↓
View
```

Rules:

- Providers should live close to the feature that uses them.
- Do not create global mutable variables.
- Do not perform expensive work in widget `build` methods.
- Do not call repositories directly from Views.
- Use `ref.watch` for reactive state.
- Use `ref.read` for actions.
- Avoid deeply nested provider dependencies without need.

## 7. Routing Architecture

The project uses `go_router`.

Each feature should define its own routes:

```text
features/authentication/routes/auth_routes.dart
features/tours/routes/tour_routes.dart
features/bookings/routes/booking_routes.dart
```

The central router combines feature routes.

Rules:

- Avoid hardcoding route strings throughout the project.
- Use route constants or route names.
- Authentication redirects must depend on auth state.
- Role-based redirects must distinguish Customer and Admin.
- Avoid placing feature-specific route configuration in unrelated files.
- Only designated team members should frequently edit `app_router.dart`.

Suggested route groups:

```text
Guest:
- /login
- /register
- /forgot-password

Customer:
- /home
- /search
- /tours/:tourId
- /wishlist
- /bookings
- /profile
- /settings

Admin:
- /admin
- /admin/tours
- /admin/categories
- /admin/bookings
- /admin/users
- /admin/reviews
- /admin/settings
```

## 8. Firebase Architecture

Firebase Authentication is used for register, login, logout, auth state, and optional Google Sign-In.

Cloud Firestore is not the primary data source for the current offline-first
implementation. It may be introduced later when cross-device synchronization
is required, for example for:

```text
users
tours
categories
bookings
reviews
```

Recommended collection structure:

```text
users/{userId}
tours/{tourId}
categories/{categoryId}
bookings/{bookingId}
reviews/{reviewId}
```

Rules:

- Do not store user passwords.
- Do not call Firebase from UI widgets.
- Convert `FirebaseException` into application-friendly errors.
- Keep Firebase SDK code inside data sources.
- Do not commit secret credentials.
- `firebase_options.dart` is generated and must not be edited manually.

## 9. Local Storage Architecture

### 9.1 SharedPreferences

Use SharedPreferences only for simple key-value settings:

- Theme mode
- Language
- Onboarding completed
- Notification preferences
- Last selected tab
- Small UI preferences

Do not use SharedPreferences for tour lists, booking history, complex relational data, shared data between devices, passwords, or sensitive tokens.

### 9.2 SQLite

SQLite is the primary local data source for tours, bookings, and profile data
in the current Windows application. Repositories must access it through their
feature data sources; Views and ViewModels must never query SQLite directly.

Because the current application targets Windows, use `sqflite_common_ffi`.
If Android or iOS support is added later, the repository interface should stay
unchanged while the platform-specific SQLite initialization is adapted.

The current SQLite data is local to one installation. If Admin and Customer
must share data across devices later, add a remote data source such as
Firestore and let repositories coordinate local persistence and synchronization.

## 10. UI Architecture and Stitch MCP

`DESIGN.md` is the source of truth for UI and UX.

Stitch MCP may generate:

- Screens
- Reusable widgets
- Layouts
- UI states
- Presentation components

Stitch MCP must not generate:

- Firebase calls inside Views
- Firestore calls inside Views
- Repository implementations inside UI files
- Business logic inside widgets
- Global state
- Hardcoded navigation configuration
- Architecture outside the requested feature

Generated UI should be adapted to:

```text
presentation/
├── views/
├── widgets/
└── view_models/
```

Stitch should primarily generate `views/` and `widgets/`. Codex or team members should connect those widgets to ViewModels.

Every asynchronous screen should support:

- Loading
- Success
- Empty
- Error

Forms should support:

- Default state
- Focus state
- Validation state
- Submitting state
- Success state
- Failure state

All colors, spacing, typography, radius, and shadows should come from the app theme or design tokens.

## 11. Feature Responsibilities

### Authentication

Responsible for login, register, logout, forgot password, auth state, and role-based entry.

Primary data source: Firebase Authentication.

### Tours

Responsible for home tour sections, search, filtering, details, categories, and wishlist presentation.

Primary data source: SQLite through `sqflite_common_ffi`.

### Bookings

Responsible for traveler information, checkout, payment selection, booking creation, booking history, booking detail, and booking status.

Primary data source: SQLite through `sqflite_common_ffi`.

For a simple course project, payment can be simulated. Do not integrate a real payment gateway unless explicitly required.

### Profile

Responsible for viewing and editing profile, avatar, settings, theme, language, and notification preferences.

Primary data source: SQLite through `sqflite_common_ffi`. SharedPreferences is
used only for simple local settings such as theme and language. Firebase may be
added later if profile synchronization across devices is required.

### Reviews

Responsible for viewing reviews, submitting reviews, moderation, and rating summaries.

Primary data source: Cloud Firestore.

### Admin

Responsible for dashboard, tour management, category management, booking management, user management, review moderation, and system settings.

Admin access must be protected by user role.

## 12. Error Handling

Use application-level errors instead of exposing raw SDK exceptions to Views.

Rules:

- Data sources may throw technical exceptions.
- Repositories map technical exceptions to application failures.
- ViewModels map failures to UI state.
- Views display user-friendly messages.
- Do not display raw stack traces to users.

## 13. Validation

Validation should be placed according to responsibility.

View:

- Displays validation messages
- Highlights invalid fields

ViewModel:

- Coordinates form submission
- May perform cross-field validation
- May expose validation state

Repository:

- Enforces data-level requirements
- Does not manage field decoration or UI text layout

Typical rules:

```text
Email:
- Required
- Valid format

Password:
- Required
- Minimum length based on project rules

Confirm password:
- Must match password

Phone:
- Required for booking
- Valid format

Passenger count:
- Must be greater than zero
```

## 14. Testing Strategy

### Unit tests

Focus on:

- ViewModel success state
- ViewModel error state
- Repository mapping
- Validation logic

### Widget tests

Focus on:

- Login form validation
- Register form validation
- Checkout validation
- Important empty and error states

### Integration tests

Optional for the course project. Use only for important flows when time allows.

Rules:

- Mock repositories in ViewModel tests.
- Do not call real Firebase in unit tests.
- Do not call real network services in unit tests.
- Static display widgets do not require tests unless they contain important behavior.

## 15. Dependency Rules

Recommended production dependencies:

```text
flutter_riverpod
go_router
firebase_core
firebase_auth
cloud_firestore
shared_preferences
intl
cached_network_image
flutter_svg
```

Optional:

```text
sqflite
sqflite_common_ffi
shimmer
uuid
dio
```

Rules:

- Do not add a package without a clear need.
- Prefer Flutter SDK APIs when practical.
- Do not add multiple packages for the same responsibility.
- Do not add another state management package.
- Do not add another router package.
- Do not use code generation unless the team agrees.

## 16. Git Collaboration Boundaries

To reduce conflicts, feature developers should mainly edit files inside their assigned feature.

Shared files include:

```text
pubspec.yaml
pubspec.lock
lib/app/router/app_router.dart
lib/app/theme/**
lib/core/widgets/**
lib/firebase_options.dart
```

Changes to shared files should be small, reviewed, and coordinated with the team.

Recommended branch names:

```text
feature/auth-login
feature/tour-detail
feature/booking-checkout
feature/admin-tours
fix/profile-validation
```

Each pull request should focus on one feature or bug.

## 17. Typical Data Flows

### Login Flow

```text
LoginScreen
  ↓
AuthViewModel
  ↓
AuthRepository
  ↓
FirebaseAuthDataSource
  ↓
Firebase Authentication
  ↓
AuthViewModel updates state
  ↓
go_router redirects by role
```

### Home Tour Flow

```text
HomeScreen
  ↓
TourViewModel
  ↓
TourRepository
  ↓
SQLiteTourDataSource
  ↓
SQLite through `sqflite_common_ffi`
  ↓
TourViewModel updates state
  ↓
HomeScreen renders content
```

### Booking Flow

```text
TourDetailScreen
  ↓
CheckoutScreen
  ↓
BookingViewModel
  ↓
BookingRepository
  ↓
FirestoreBookingDataSource
  ↓
Cloud Firestore
  ↓
BookingResultScreen
```

### Theme Flow

```text
SettingsScreen
  ↓
SettingsViewModel
  ↓
PreferencesRepository
  ↓
SharedPreferencesDataSource
  ↓
SharedPreferences
  ↓
App theme state updates
```

## 18. Out of Scope

The following are out of scope unless explicitly required:

- Microservices
- Full Clean Architecture with use-case classes for every action
- Dependency injection frameworks other than Riverpod
- Multiple state management libraries
- Real payment gateway
- Complex offline synchronization
- Event sourcing
- CQRS
- Custom backend server
- Advanced analytics infrastructure
- Excessive code generation
- Unnecessary abstraction layers

## 19. Definition of Architectural Compliance

A feature follows this architecture when:

- Its UI is inside the feature presentation layer.
- Its state is managed through Riverpod.
- The View calls a ViewModel, not Firebase.
- The ViewModel calls a Repository.
- The Repository calls a Data Source.
- External SDK usage is isolated in Data Sources.
- Shared UI uses app theme and reusable core widgets.
- Loading and error states are handled.
- No unrelated feature files are modified.
- Tests exist for important logic.
- The feature follows `AGENTS.md` and `DESIGN.md`.

## 20. Final Architecture Decision

The official architecture for this project is:

```text
Feature-first
+
MVVM
+
Repository pattern
+
Riverpod
+
go_router
+
Firebase Authentication
+
Cloud Firestore
+
SharedPreferences
+
SQLite (`sqflite_common_ffi`) for tours, bookings, and profile
+
Stitch MCP for presentation UI
```

This structure is intentionally simple. Do not add additional layers unless there is a clear and documented project need.
