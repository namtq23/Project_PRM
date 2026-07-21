import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_constants.dart';
import '../../models/booking_management_model.dart';

part 'booking_management_repository.g.dart';

class BookingManagementRepository {
  BookingManagementRepository(this._db);
  final AppDatabase _db;

  Future<List<BookingManagementModel>> getAllBookings() async {
    final db = await _db.database;
    final maps = await db.query(
      DatabaseConstants.bookingsTable,
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => BookingManagementModel.fromMap(map)).toList();
  }

  Future<void> updateBookingStatus(int id, String status) async {
    final db = await _db.database;
    await db.update(
      DatabaseConstants.bookingsTable,
      {'status': status, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBooking(int id) async {
    final db = await _db.database;
    await db.delete(
      DatabaseConstants.bookingsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> createBooking(BookingManagementModel booking) async {
    final db = await _db.database;
    return db.insert(DatabaseConstants.bookingsTable, booking.toMap());
  }

  // Seed data from Stitch design if empty
  Future<void> seedIfEmpty() async {
    final db = await _db.database;
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.bookingsTable}',
    );
    final count = countResult.first['count'] as int;
    if (count == 0) {
      final bookings = [
        BookingManagementModel(
          id: 0,
          userId: 1,
          tourId: 101,
          customerName: 'Elena Jensen',
          customerEmail: 'elena.j@corporate.com',
          tourTitle: 'Icelandic Northern Lights',
          bookingDate: DateTime(2023, 10, 24),
          status: 'completed', // Confirmed
          totalPrice: 4250.00,
          passengers: 2,
          createdAt: DateTime(2023, 10, 20),
          updatedAt: DateTime(2023, 10, 24),
        ),
        BookingManagementModel(
          id: 0,
          userId: 2,
          tourId: 102,
          customerName: 'Robert Kincaid',
          customerEmail: 'r.kincaid@globex.com',
          tourTitle: 'Amalfi Coast Yacht Charter',
          bookingDate: DateTime(2023, 10, 28),
          status: 'pending', // Pending
          totalPrice: 12800.00,
          passengers: 4,
          createdAt: DateTime(2023, 10, 22),
          updatedAt: DateTime(2023, 10, 22),
        ),
        BookingManagementModel(
          id: 0,
          userId: 3,
          tourId: 103,
          customerName: 'Sarah Connor',
          customerEmail: 's.connor@cyber.net',
          tourTitle: 'Kyoto Cherry Blossom Tour',
          bookingDate: DateTime(2023, 11, 2),
          status: 'canceled', // Cancelled
          totalPrice: 6100.00,
          passengers: 2,
          createdAt: DateTime(2023, 10, 25),
          updatedAt: DateTime(2023, 10, 26),
        ),
        BookingManagementModel(
          id: 0,
          userId: 4,
          tourId: 104,
          customerName: 'David Miller',
          customerEmail: 'david.m@techflow.io',
          tourTitle: 'Swiss Alps Heli-Skiing',
          bookingDate: DateTime(2023, 11, 15),
          status: 'approved', // Confirmed
          totalPrice: 9400.00,
          passengers: 1,
          createdAt: DateTime(2023, 10, 27),
          updatedAt: DateTime(2023, 10, 27),
        ),
      ];

      for (final b in bookings) {
        await db.insert(DatabaseConstants.bookingsTable, b.toMap());
      }
    }
  }
}

@Riverpod(keepAlive: true)
BookingManagementRepository bookingManagementRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return BookingManagementRepository(db);
}
