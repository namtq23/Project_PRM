# AGENTS.md

## 1. Project Overview

This repository is a Flutter Tour Booking Application for a course project. It serves two roles: Customer and Admin. Keep the architecture clear, readable, easy to divide among students, and no more complex than the feature requires.

Current repository state: this is an early Flutter starter scaffold. The package is currently named `project_prm`; `lib/` contains only `main.dart`. Riverpod, go_router, Firebase, SharedPreferences, and SQLite are not currently declared in `pubspec.yaml`, and the planned feature-first structure has not yet been created. Treat the rules below as the target standard, but do not add dependencies or scaffold features unless the task explicitly requires it.

Target technologies are Flutter, Dart, `flutter_riverpod`, `go_router`, Firebase Authentication, Cloud Firestore, and `shared_preferences`. Use `sqflite` or `sqflite_common_ffi` only when structured local data is genuinely needed. Stitch MCP may be used for UI work. `DESIGN.md`, once present, is the source of truth for UI/UX.

## 2. Architecture

Use feature-first organization, simple MVVM, and the Repository pattern. The required dependency direction is:

```text
View -> ViewModel -> Repository -> Data Source
```

- Views must not call Firebase Authentication, Firestore, SharedPreferences, or SQLite directly.
- ViewModels must not store or depend on `BuildContext`.
- ViewModels manage UI state with Riverpod.
- Repositories decide whether data comes from remote or local sources.
- Data sources communicate with Firebase, Firestore, SharedPreferences, or SQLite.
- Do not add domain, use-case, or other abstraction layers for simple features unless they solve a demonstrated need.
- Keep business logic out of widgets and widget `build` methods.

## 3. Folder Structure

Use this target feature-first structure as features are implemented:

```text
lib/
  app/
    router/
    theme/
  core/
    constants/
    errors/
    services/
    utils/
    widgets/
  features/
    authentication/
      data/
      models/
      presentation/
      routes/
    tours/
      data/
      models/
      presentation/
      routes/
    bookings/
      data/
      models/
      presentation/
      routes/
    profile/
    reviews/
    admin/
```

Within each feature, prefer:

```text
feature/
  data/
    data_sources/
    repositories/
  models/
  presentation/
    view_models/
    views/
    widgets/
  routes/
```

Place code in the feature that owns it. Do not move feature-specific code into global folders. Promote a component to `core/` only when it is genuinely shared by multiple features.

## 4. Riverpod Rules

- Use `Provider` for dependency injection.
- Use `Notifier` or `AsyncNotifier` for mutable state.
- Keep state and providers close to the feature that uses them.
- Do not use global mutable variables.
- Do not scatter arbitrary `ref.read` or `ref.watch` calls through child widgets; pass focused values or callbacks when that keeps dependencies clear.
- Do not use Riverpod code generation unless the task explicitly requests it.
- ViewModels must represent loading, data/success, empty, and error states where applicable.
- Do not put business logic in widget `build` methods.

## 5. go_router Rules

- Each feature declares its own routes in its `routes/` directory.
- The central router only composes routes supplied by features.
- Do not duplicate hard-coded route strings; use route names or constants.
- Authentication redirects must derive from authentication state.
- Route Customer and Admin users according to their role.
- Do not edit the central router unless the task requires it.

## 6. Firebase Rules

- Access Firebase Authentication only through an authentication data source or repository.
- Access Firestore only through a data source or repository, never directly from a screen.
- Never store passwords in local storage.
- Catch `FirebaseException` at the data boundary and map it to UI-friendly application errors.
- Use Firebase Authentication for sign-in, registration, sign-out, and authentication state.
- Use Firestore for shared data such as `users`, `tours`, `categories`, `bookings`, and `reviews`.
- Do not put secrets, private API keys, credentials, or service-account files in source code or Git.

## 7. Local Storage Rules

Use SharedPreferences only for simple key-value settings such as theme, language, onboarding state, and notification preferences.

Use SQLite only for structured caches, offline data, or an explicit course requirement. Do not use SQLite as the sole store for tours or bookings shared among multiple users.

## 8. UI and Stitch MCP Rules

- `DESIGN.md` is the UI/UX source of truth once it exists. Do not invent design changes that conflict with it.
- Use Stitch MCP only to create or modify the presentation layer.
- Adapt Stitch-generated code to this repository's architecture.
- Stitch-generated UI must not call Firebase, repositories, or databases directly.
- Keep business logic out of widgets.
- Use existing design tokens for color, spacing, typography, and border radius instead of hard-coding values.
- Reuse suitable components from `lib/core/widgets`.
- Every asynchronous screen must handle loading, success, empty, and error states.
- Forms must provide inline validation.
- Support common mobile screen sizes and avoid overflow.

## 9. Coding Style

- Follow the Dart and Flutter style guides.
- Use meaningful names for classes, variables, and functions.
- Avoid excessively long files; extract focused widgets when useful.
- Prefer immutable models and `const` constructors where possible.
- Avoid `dynamic` and `Object?` when a clear type is available.
- Do not suppress lints without a documented reason.
- Remove unnecessary `debugPrint` calls and stale TODOs from completed work.
- Do not create an abstraction merely to wrap one trivial function.
- Prefer the simplest maintainable solution appropriate for a course project.

## 10. File Ownership and Safe Editing

Edit only files directly related to the task. Do not modify the following unless the task requires it:

- `pubspec.yaml`
- `pubspec.lock`
- `lib/app/router/app_router.dart`
- `lib/app/theme/**`
- `lib/firebase_options.dart`
- `android/**`, `ios/**`, `web/**`, `macos/**`, `windows/**`, or `linux/**`
- generated files
- files owned by unrelated features

If one of these files must change, explain why, keep the change as small as possible, and preserve teammates' work. Do not format the entire repository for a small feature change.

## 11. Generated Files

Do not manually edit:

- `*.g.dart`
- `*.freezed.dart`
- `firebase_options.dart`
- any file generated by a tool or package

Regenerate such files with the appropriate command when required.

## 12. Git Collaboration Rules

- Do not commit directly to `main`.
- Keep each task focused on one feature or one bug.
- Do not change unrelated code.
- Do not rename or move files in bulk unless requested.
- Do not delete a teammate's code unless it is confirmed unused.
- Keep pull requests small and easy to review.
- Never edit `pubspec.lock` manually.
- Never commit secrets, private API keys, or credentials.
- Do not run history-destructive commands such as `git reset --hard`, `git push --force`, or `git clean -fd` unless the user explicitly requests them.

## 13. Testing Rules

- Unit-test ViewModels that contain important logic.
- Test success and error states; test empty and loading behavior when meaningful.
- Add widget tests for validation in important forms.
- Mock repositories in unit tests.
- Do not call real Firebase services or real networks in unit tests.
- Static, presentation-only widgets do not require tests unless their behavior warrants them.

## 14. Required Validation Commands

Before reporting a code task complete, run as applicable:

```text
flutter pub get
dart format .
flutter analyze
flutter test
```

For a small change, format only edited Dart files if repository-wide formatting would touch unrelated files. Do not claim completion while analysis has errors, tests fail, edited code is unformatted, or unrelated files were changed. If Flutter, Firebase, dependencies, or environment constraints prevent a command from running, report the exact command and reason.

For documentation-only tasks that do not modify Dart or dependencies, inspect the diff and Markdown content; Flutter commands may be skipped as not applicable.

## 15. Definition of Done

A task is complete only when:

- The requested behavior works.
- Code is placed in the owning feature.
- MVVM and the required dependency direction are respected.
- UI follows `DESIGN.md` when available.
- Views contain no direct Firebase or database calls.
- Loading and error handling are present where needed.
- Edited code is formatted.
- `flutter analyze` and relevant tests pass, or blockers are explicitly reported.
- No unrelated files were modified.
- The response summarizes changed files.

## 16. Agent Response Format

After each task, respond concisely with:

- Summary
- Files changed
- Architecture decisions
- Validation performed
- Remaining issues

## 17. Initial Project Inspection

Before implementation work:

- Read `pubspec.yaml`.
- Inspect `lib/` and the relevant feature directories.
- Check whether Riverpod, go_router, Firebase, and required local-storage packages are actually installed.
- Read `DESIGN.md` before UI work when it exists.
- Do not add a dependency unless the task requires it; explain dependency changes before making them.
- Match new code to the repository's current structure while moving toward the target structure incrementally.
- If the repository remains an empty starter, use this document as the starting standard and create only the directories needed by the current task.
