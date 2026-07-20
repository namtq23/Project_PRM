abstract final class DatabaseConstants {
  static const databaseName = 'tour_booking.db';
  static const databaseVersion = 1;

  // Table Names
  static const usersTable = 'users';
  static const categoriesTable = 'categories';
  static const toursTable = 'tours';
  static const bookingsTable = 'bookings';
  static const reviewsTable = 'reviews';

  // Create Table SQLs
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

  static const createCategoriesTable = '''
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  firestore_id TEXT UNIQUE,
  title TEXT NOT NULL,
  description TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''';

  static const createToursTable = '''
CREATE TABLE tours (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  firestore_id TEXT UNIQUE,
  category_id INTEGER,
  title TEXT NOT NULL,
  description TEXT,
  price REAL NOT NULL,
  duration_days INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL
)
''';

  static const createBookingsTable = '''
CREATE TABLE bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  firestore_id TEXT UNIQUE,
  user_id INTEGER NOT NULL,
  tour_id INTEGER NOT NULL,
  booking_date TEXT NOT NULL,
  total_cost REAL NOT NULL,
  payment_method TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  passenger_quantity INTEGER NOT NULL DEFAULT 1,
  special_notes TEXT,
  promo_code TEXT,
  confirmation_code TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (tour_id) REFERENCES tours (id) ON DELETE CASCADE
)
''';

  static const createReviewsTable = '''
CREATE TABLE reviews (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  firestore_id TEXT UNIQUE,
  user_id INTEGER NOT NULL,
  tour_id INTEGER NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (tour_id) REFERENCES tours (id) ON DELETE CASCADE
)
''';

  static const List<String> allTables = [
    createUsersTable,
    createCategoriesTable,
    createToursTable,
    createBookingsTable,
    createReviewsTable,
  ];
}
