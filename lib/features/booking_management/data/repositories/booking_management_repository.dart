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

  // Seed some data for testing if empty
  Future<void> seedIfEmpty() async {
    final db = await _db.database;
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.bookingsTable}',
    );
    final count = countResult.first['count'] as int;
    if (count == 0) {
      final now = DateTime.now();
      final bookings = [
        BookingManagementModel(
          id: 0,
          userId: 1,
          tourId: 1,
          customerName: 'Nguyễn Văn A',
          customerEmail: 'vana@example.com',
          tourTitle: 'Hà Nội - Hạ Long 2 ngày 1 đêm',
          bookingDate: now.add(const Duration(days: 7)),
          status: 'pending',
          totalPrice: 2500000,
          passengers: 2,
          createdAt: now,
          updatedAt: now,
        ),
        BookingManagementModel(
          id: 0,
          userId: 2,
          tourId: 2,
          customerName: 'Trần Thị B',
          customerEmail: 'thib@example.com',
          tourTitle: 'Đà Nẵng - Hội An - Bà Nà Hills',
          bookingDate: now.add(const Duration(days: 14)),
          status: 'approved',
          totalPrice: 4500000,
          passengers: 3,
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
        BookingManagementModel(
          id: 0,
          userId: 3,
          tourId: 3,
          customerName: 'Lê Văn C',
          customerEmail: 'vanc@example.com',
          tourTitle: 'Sapa - Fansipan Legend',
          bookingDate: now.subtract(const Duration(days: 2)),
          status: 'completed',
          totalPrice: 3200000,
          passengers: 1,
          createdAt: now.subtract(const Duration(days: 10)),
          updatedAt: now.subtract(const Duration(days: 2)),
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
