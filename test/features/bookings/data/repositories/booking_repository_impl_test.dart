import 'package:flutter_test/flutter_test.dart';
import 'package:project_prm/core/database/app_database.dart';
import 'package:project_prm/core/database/database_constants.dart';
import 'package:project_prm/features/bookings/data/data_sources/booking_data_source.dart';
import 'package:project_prm/features/bookings/data/repositories/booking_repository.dart';
import 'package:project_prm/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:project_prm/features/bookings/models/booking_flow_models.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late AppDatabase appDatabase;
  late BookingRepository repository;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    appDatabase = AppDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
      seedDemoData: false,
    );
    repository = BookingRepositoryImpl(BookingLocalDataSource(appDatabase));
    await _seedUserAndTour(appDatabase);
  });

  tearDown(() => appDatabase.close());

  test('database initialization creates all declared tables', () async {
    final database = await appDatabase.database;
    final rows = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table'",
    );
    final tableNames = rows.map((row) => row['name']).toSet();

    expect(
      tableNames,
      containsAll(<String>{
        DatabaseConstants.usersTable,
        DatabaseConstants.categoriesTable,
        DatabaseConstants.toursTable,
        DatabaseConstants.bookingsTable,
        DatabaseConstants.reviewsTable,
      }),
    );
  });

  test(
    'createBooking persists authoritative price and promo discount',
    () async {
      final result = await repository.createBooking(
        BookingRequest(
          userId: 1,
          draft: _validDraft(
            basePrice: 999,
            adultCount: 2,
            childCount: 1,
            promoCode: 'VIETTRAVEL10',
            discountAmount: 999,
          ),
        ),
      );

      expect(result.success, isTrue);
      expect(result.confirmationCode, startsWith('VT-'));
      expect(result.booking?.status, 'pending');
      expect(result.booking?.passengerQuantity, 3);
      expect(result.booking?.paymentMethod, 'bank_transfer');
      expect(result.booking?.totalCost, closeTo(243, 0.001));

      final history = await repository.getBookingHistory(1);
      expect(history, hasLength(1));
      expect(history.single.bookingId, isNotNull);
      expect(history.single.totalCost, closeTo(243, 0.001));
    },
  );

  test('createBooking rejects invalid input and inactive tours', () async {
    final invalidInput = await repository.createBooking(
      BookingRequest(
        userId: 1,
        draft: _validDraft().copyWith(
          travelerInfo: _validDraft().travelerInfo.copyWith(contactName: ''),
        ),
      ),
    );
    expect(invalidInput.success, isFalse);
    expect(invalidInput.message, contains('họ và tên'));

    final database = await appDatabase.database;
    await database.update(
      DatabaseConstants.toursTable,
      {'status': 'inactive'},
      where: 'id = ?',
      whereArgs: [1],
    );
    final inactiveTour = await repository.createBooking(
      BookingRequest(userId: 1, draft: _validDraft()),
    );
    expect(inactiveTour.success, isFalse);
    expect(inactiveTour.message, contains('không nhận đặt chỗ'));
  });

  test(
    'review requires completed owned booking and prevents duplicates',
    () async {
      final bookingResult = await repository.createBooking(
        BookingRequest(userId: 1, draft: _validDraft()),
      );
      final booking = bookingResult.booking!;
      final review = ReviewRequest(
        bookingId: booking.bookingId!,
        tourId: booking.tourId,
        userId: booking.userId,
        rating: 5,
        comment: 'Chuyến đi rất tốt.',
      );

      expect(
        () => repository.submitReview(review),
        throwsA(
          isA<BookingException>().having(
            (error) => error.message,
            'message',
            contains('hoàn thành'),
          ),
        ),
      );

      final database = await appDatabase.database;
      await database.update(
        DatabaseConstants.bookingsTable,
        {
          'status': 'completed',
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [booking.bookingId],
      );

      expect(await repository.submitReview(review), isTrue);
      final reviews = await database.query(DatabaseConstants.reviewsTable);
      expect(reviews, hasLength(1));
      expect(reviews.single['rating'], 5);

      expect(
        () => repository.submitReview(review),
        throwsA(
          isA<BookingException>().having(
            (error) => error.message,
            'message',
            contains('đã đánh giá'),
          ),
        ),
      );
    },
  );
}

BookingDraft _validDraft({
  double basePrice = 500,
  int adultCount = 1,
  int childCount = 0,
  String? promoCode,
  double discountAmount = 0,
}) {
  return BookingDraft(
    tourId: 1,
    basePrice: basePrice,
    travelerInfo: TravelerInfo(
      contactName: 'Nguyễn Văn A',
      contactPhone: '0912345678',
      adultCount: adultCount,
      childCount: childCount,
      selectedDate: DateTime.now().add(const Duration(days: 7)),
      specialNotes: 'Phòng tầng thấp',
    ),
    paymentMethod: PaymentMethodType.bankTransfer,
    promoCode: promoCode,
    discountAmount: discountAmount,
  );
}

Future<void> _seedUserAndTour(AppDatabase appDatabase) async {
  final database = await appDatabase.database;
  final now = DateTime.now().toUtc().toIso8601String();
  await database.insert(DatabaseConstants.usersTable, <String, Object?>{
    'id': 1,
    'email': 'booking@example.com',
    'full_name': 'Booking Tester',
    'auth_provider': 'local',
    'role': 'user',
    'status': 'active',
    'created_at': now,
    'updated_at': now,
  });
  await database.insert(DatabaseConstants.toursTable, <String, Object?>{
    'id': 1,
    'title': 'Hạ Long 3 ngày 2 đêm',
    'description': 'Tour dùng cho kiểm thử.',
    'price': 100.0,
    'duration_days': 3,
    'status': 'active',
    'created_at': now,
    'updated_at': now,
  });
}
