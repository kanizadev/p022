# SQLite Users – Flutter + sqflite demo

A simple but polished Flutter app that demonstrates **CRUD with SQLite** using `sqflite`/`sqflite_common_ffi`, with widget and database tests ready to run. This README is structured for GitHub so others can understand, run, and extend the project quickly.

## Features

- **User management (CRUD)**: create, read, update, delete users (name, email, age).
- **SQLite persistence**: local database via `sqflite`, desktop/testing via `sqflite_common_ffi`.
- **Modern UI**:
  - Material 3 theming with light/dark mode.
  - Card-based user list with avatars.
  - Improved add/edit form with validation and clear actions.
- **Quality & tests**:
  - Unit-style DB test for CRUD.
  - Widget tests for `MyApp` and `HomeScreen`.

## Tech stack

- **Flutter** (Material 3)
- **sqflite** for SQLite on device
- **sqflite_common_ffi** for desktop/tests
- **path**, **path_provider** (runtime only) for paths

## Getting started

### Prerequisites

- Flutter SDK installed and on your `PATH`.
- A supported device/emulator/simulator (Android, iOS, web, desktop – depending on your Flutter setup).

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

By default this launches the app named **“SQLite Users”**, which shows the `HomeScreen` user list.

## Project structure

- `lib/main.dart` – app entry point and theming.
- `lib/models/user.dart` – `User` model and mapping helpers.
- `lib/database/database_helper.dart` – SQLite helper (open DB, create table, CRUD methods).
- `lib/screens/home_screen.dart` – users list, search, sorting, and small stats.
- `lib/screens/add_edit_user_screen.dart` – add/edit user form with validation.
- `test/database_helper_test.dart` – CRUD tests against the DB helper.
- `test/widget_test.dart` – basic widget tests for app structure.

## Running tests

The project includes unit and widget tests. Run all tests with:

```bash
flutter test
```

The tests:

- Initialize `sqflite_common_ffi` so SQLite works in a headless environment.
- Verify CRUD operations in `DatabaseHelper`.
- Assert that the app launches with the expected title and basic UI structure.

## Database details

- Database file: `users.db`
- Table: `users`
  - `id` – `INTEGER PRIMARY KEY AUTOINCREMENT`
  - `name` – `TEXT NOT NULL`
  - `email` – `TEXT NOT NULL`
  - `age` – `INTEGER NOT NULL`

`DatabaseHelper` exposes:

- `Future<int> createUser(User user)`
- `Future<List<User>> getAllUsers()`
- `Future<User?> getUser(int id)`
- `Future<int> updateUser(User user)`
- `Future<int> deleteUser(int id)`

## Extending the app

Ideas for next steps:

- Add pagination or infinite scrolling for large datasets.
- Add extra fields (e.g., phone, address, createdAt/updatedAt).
- Introduce state management (Provider, Riverpod, Bloc, etc.).
- Add localization and accessibility improvements.

## License

You can choose and add a license here (for example MIT, Apache 2.0, etc.), depending on how you plan to share this on GitHub.