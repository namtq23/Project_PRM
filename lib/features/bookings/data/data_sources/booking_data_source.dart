import 'package:riverpod_annotation/riverpod_annotation.dart';
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
      var tourTitle = booking.tourTitle;
      if (tourTitle == null || tourTitle.isEmpty) {
        final tourRows = await database.query(
          DatabaseConstants.toursTable,
          columns: ['title'],
          where: 'id = ?',
          whereArgs: [booking.tourId],
          limit: 1,
        );
        if (tourRows.isNotEmpty) {
          tourTitle = tourRows.first['title'] as String?;
        }
      }

      var customerName = booking.customerName;
      var customerEmail = booking.customerEmail;
      if ((customerName == null || customerName.isEmpty) ||
          (customerEmail == null || customerEmail.isEmpty)) {
        final userRows = await database.query(
          DatabaseConstants.usersTable,
          columns: ['full_name', 'email'],
          where: 'id = ?',
          whereArgs: [booking.userId],
          limit: 1,
        );
        if (userRows.isNotEmpty) {
          customerName = (customerName != null && customerName.isNotEmpty)
              ? customerName
              : (userRows.first['full_name'] as String?);
          customerEmail = (customerEmail != null && customerEmail.isNotEmpty)
              ? customerEmail
              : (userRows.first['email'] as String?);
        }
      }

      final enrichedBooking = BookingModel(
        bookingId: booking.bookingId,
        userId: booking.userId,
        tourId: booking.tourId,
        tourTitle: tourTitle,
        customerName: customerName,
        customerEmail: customerEmail,
        bookingDate: booking.bookingDate,
        totalCost: booking.totalCost,
        paymentMethod: booking.paymentMethod,
        status: booking.status,
        passengerQuantity: booking.passengerQuantity,
        specialNotes: booking.specialNotes,
        promoCode: booking.promoCode,
        confirmationCode: booking.confirmationCode,
        createdAt: booking.createdAt,
        updatedAt: booking.updatedAt,
      );

      final id = await database.insert(
        DatabaseConstants.bookingsTable,
        enrichedBooking.toMap(includeId: false),
      );
      return BookingModel.fromMap({...enrichedBooking.toMap(), 'id': id});
    } on DatabaseException catch (error) {
      throw BookingDataException('Không thể lưu đơn đặt tour.', error);
    }
  }

  @override
  Future<List<BookingModel>> getBookingHistory(int userId) async {
    try {
      final database = await appDatabase.database;
      final rows = await database.rawQuery(
        '''
        SELECT b.*,
               COALESCE(NULLIF(b.tour_title, ''), t.title) AS tour_title,
               COALESCE(NULLIF(b.customer_name, ''), u.full_name) AS customer_name,
               COALESCE(NULLIF(b.customer_email, ''), u.email) AS customer_email,
               CASE WHEN b.total_cost > 0 THEN b.total_cost ELSE b.total_price END AS total_cost
        FROM ${DatabaseConstants.bookingsTable} b
        LEFT JOIN ${DatabaseConstants.toursTable} t ON b.tour_id = t.id
        LEFT JOIN ${DatabaseConstants.usersTable} u ON b.user_id = u.id
        WHERE b.user_id = ?
        ORDER BY b.created_at DESC
      ''',
        [userId],
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
      final rows = await database.rawQuery(
        '''
        SELECT b.*,
               COALESCE(NULLIF(b.tour_title, ''), t.title) AS tour_title,
               COALESCE(NULLIF(b.customer_name, ''), u.full_name) AS customer_name,
               COALESCE(NULLIF(b.customer_email, ''), u.email) AS customer_email,
               CASE WHEN b.total_cost > 0 THEN b.total_cost ELSE b.total_price END AS total_cost
        FROM ${DatabaseConstants.bookingsTable} b
        LEFT JOIN ${DatabaseConstants.toursTable} t ON b.tour_id = t.id
        LEFT JOIN ${DatabaseConstants.usersTable} u ON b.user_id = u.id
        WHERE b.id = ? AND b.user_id = ?
        LIMIT 1
      ''',
        [bookingId, userId],
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
