import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_constants.dart';
import '../../models/booking_flow_models.dart';
import '../../models/booking_model.dart';

part 'booking_data_source.g.dart';

abstract interface class BookingDataSource {
  Future<double?> getActiveTourPrice(int tourId);
  Future<BookingModel> createBooking(BookingModel booking);
  Future<List<BookingModel>> getBookingHistory(int userId);
  Future<BookingModel?> getBookingDetail({
    required int bookingId,
    required int userId,
  });
  Future<bool> reviewExists({required int userId, required int tourId});
  Future<void> createReview(ReviewRequest request);
}

class BookingLocalDataSource implements BookingDataSource {
  const BookingLocalDataSource(this.appDatabase);

  final AppDatabase appDatabase;

  @override
  Future<double?> getActiveTourPrice(int tourId) async {
    try {
      final database = await appDatabase.database;
      final rows = await database.query(
        DatabaseConstants.toursTable,
        columns: ['price'],
        where: 'id = ? AND LOWER(status) = ?',
        whereArgs: [tourId, 'active'],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      return (rows.single['price']! as num).toDouble();
    } on DatabaseException catch (error) {
      throw BookingDataException('Không thể kiểm tra thông tin tour.', error);
    }
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      final database = await appDatabase.database;
      final id = await database.insert(
        DatabaseConstants.bookingsTable,
        booking.toMap(includeId: false),
      );
      return BookingModel.fromMap({...booking.toMap(), 'id': id});
    } on DatabaseException catch (error) {
      throw BookingDataException('Không thể lưu đơn đặt tour.', error);
    }
  }

  @override
  Future<List<BookingModel>> getBookingHistory(int userId) async {
    try {
      final database = await appDatabase.database;
      final rows = await database.query(
        DatabaseConstants.bookingsTable,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      return rows.map(BookingModel.fromMap).toList(growable: false);
    } on DatabaseException catch (error) {
      throw BookingDataException('Không thể tải lịch sử đặt tour.', error);
    }
  }

  @override
  Future<BookingModel?> getBookingDetail({
    required int bookingId,
    required int userId,
  }) async {
    try {
      final database = await appDatabase.database;
      final rows = await database.query(
        DatabaseConstants.bookingsTable,
        where: 'id = ? AND user_id = ?',
        whereArgs: [bookingId, userId],
        limit: 1,
      );
      return rows.isEmpty ? null : BookingModel.fromMap(rows.single);
    } on DatabaseException catch (error) {
      throw BookingDataException('Không thể tải chi tiết đặt tour.', error);
    }
  }

  @override
  Future<bool> reviewExists({required int userId, required int tourId}) async {
    try {
      final database = await appDatabase.database;
      final rows = await database.query(
        DatabaseConstants.reviewsTable,
        columns: ['id'],
        where: 'user_id = ? AND tour_id = ?',
        whereArgs: [userId, tourId],
        limit: 1,
      );
      return rows.isNotEmpty;
    } on DatabaseException catch (error) {
      throw BookingDataException('Không thể kiểm tra đánh giá.', error);
    }
  }

  @override
  Future<void> createReview(ReviewRequest request) async {
    try {
      final database = await appDatabase.database;
      final now = DateTime.now().toUtc().toIso8601String();
      await database.insert(DatabaseConstants.reviewsTable, <String, Object?>{
        'user_id': request.userId,
        'tour_id': request.tourId,
        'rating': request.rating,
        'comment': request.comment.trim(),
        'created_at': now,
        'updated_at': now,
      });
    } on DatabaseException catch (error) {
      throw BookingDataException('Không thể lưu đánh giá.', error);
    }
  }
}

class BookingDataException implements Exception {
  const BookingDataException(this.message, [this.cause]);

  final String message;
  final Object? cause;
}

@Riverpod(keepAlive: true)
BookingDataSource bookingDataSource(Ref ref) {
  return BookingLocalDataSource(ref.watch(appDatabaseProvider));
}
