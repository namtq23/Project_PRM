abstract final class DatabaseConstants {
  static const databaseName = 'tour_booking.db';
  static const databaseVersion = 2;
  static const usersTable = 'users';
  static const bookingsTable = 'bookings';

  static const createUsersTable = '''
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  firebase_uid TEXT UNIQUE,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT,
  full_name TEXT NOT NULL,
  phone TEXT,
  avatar_url TEXT,
  auth_provider TEXT NOT NULL DEFAULT 'local',
  role TEXT NOT NULL DEFAULT 'user',
  status TEXT NOT NULL DEFAULT 'active',
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''';

  static const createBookingsTable = '''
CREATE TABLE bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  tour_id INTEGER NOT NULL,
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  tour_title TEXT NOT NULL,
  booking_date TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  total_price REAL NOT NULL,
  passengers INTEGER NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id)
)
''';
}
