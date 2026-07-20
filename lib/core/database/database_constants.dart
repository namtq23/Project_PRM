abstract final class DatabaseConstants {
  static const databaseName = 'tour_booking.db';
  static const databaseVersion = 2;

  // Table Names
  static const usersTable = 'users';
  static const categoriesTable = 'categories';
  static const toursTable = 'tours';
  static const bookingsTable = 'bookings';
  static const reviewsTable = 'reviews';

  // Create Table SQLs
  static const createUsersTable = '''
CREATE TABLE IF NOT EXISTS users (
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
CREATE TABLE IF NOT EXISTS categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  firestore_id TEXT UNIQUE,
  title TEXT NOT NULL,
  description TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''';

  static const createToursTable = '''
CREATE TABLE IF NOT EXISTS tours (
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
CREATE TABLE IF NOT EXISTS bookings (
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
CREATE TABLE IF NOT EXISTS reviews (
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

  static const createBookingsUserIndex = '''
CREATE INDEX IF NOT EXISTS idx_bookings_user_created
ON bookings (user_id, created_at DESC)
''';

  static const createBookingsTourDateIndex = '''
CREATE INDEX IF NOT EXISTS idx_bookings_tour_date
ON bookings (tour_id, booking_date)
''';

  static const createConfirmationCodeIndex = '''
CREATE UNIQUE INDEX IF NOT EXISTS idx_bookings_confirmation_code
ON bookings (confirmation_code)
WHERE confirmation_code IS NOT NULL
''';

  static const createReviewsUserTourIndex = '''
CREATE INDEX IF NOT EXISTS idx_reviews_user_tour
ON reviews (user_id, tour_id)
''';

  static const List<String> allIndexes = [
    createBookingsUserIndex,
    createBookingsTourDateIndex,
    createConfirmationCodeIndex,
    createReviewsUserTourIndex,
  ];
}
