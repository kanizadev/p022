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
## ⭐ Show Your Support

If you like this project, **give it a star on GitHub** to show your support and help others discover it.

## 📧 Contact

For questions or suggestions, please **open an issue on GitHub** in this repository.

---

Made with **Flutter** 💙 · Designed with **Nature** 🌿
