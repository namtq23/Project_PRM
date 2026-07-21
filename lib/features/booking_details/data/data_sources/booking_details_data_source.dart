import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_constants.dart';
import '../../models/admin_booking_detail_model.dart';

part 'booking_details_data_source.g.dart';

abstract interface class BookingDetailsDataSource {
  Future<AdminBookingDetailModel?> getBookingDetailById(int id);
  Future<void> updateBookingStatus(int id, String newStatus);
}

class BookingDetailsLocalDataSource implements BookingDetailsDataSource {
  BookingDetailsLocalDataSource(this.appDatabase);

  final AppDatabase appDatabase;

  @override
  Future<AdminBookingDetailModel?> getBookingDetailById(int id) async {
    final db = await appDatabase.database;
    final rows = await db.rawQuery(
      '''
      SELECT b.*,
             COALESCE(NULLIF(b.tour_title, ''), t.title) AS tour_title,
             COALESCE(NULLIF(b.customer_name, ''), u.full_name) AS customer_name,
             COALESCE(NULLIF(b.customer_email, ''), u.email) AS customer_email,
             CASE WHEN b.total_price > 0 THEN b.total_price ELSE b.total_cost END AS total_price
      FROM ${DatabaseConstants.bookingsTable} b
      LEFT JOIN ${DatabaseConstants.toursTable} t ON b.tour_id = t.id
      LEFT JOIN ${DatabaseConstants.usersTable} u ON b.user_id = u.id
      WHERE b.id = ?
      LIMIT 1
    ''',
      [id],
    );

    final sampleDetail = AdminBookingDetailModel(
      id: id > 0 ? id : 8829,
      bookingCode: 'BK-${id > 0 ? id : 8829}-2024',
      tourTitle:
          rows.isNotEmpty &&
              (rows.first['tour_title'] as String?)?.isNotEmpty == true
          ? (rows.first['tour_title'] as String)
          : 'Amalfi Coast Executive Tour',
      tourImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB3INqjiVge76Wrh_frF5PDMbS39_WXXvCk-8hVN93cjj7dVD41i1SZT2ZaYJk9ZPjRhqHARh-GrrC_UMynQ4CrJXgLcyuiMNjORmOERT7GwEb2ywz3xi4k0wan77wMzn4iXKgS-u65EaRG11p5hrzeDJI3AphFLLKszkSrj3cQHPxxm8MGo3CkAO6BVJFzb3JaNUn3LeSXfoim4GFvKOwYbkmy2FfMNaU9WJjIVe3iwWQXD09b2oLL',
      status: rows.isNotEmpty ? (rows.first['status'] as String) : 'confirmed',
      startDate: DateTime(2024, 10, 14),
      endDate: DateTime(2024, 10, 21),
      travelerCount: rows.isNotEmpty && rows.first['passengers'] != null
          ? (rows.first['passengers'] as num).toInt()
          : 4,
      customerEmail:
          rows.isNotEmpty &&
              (rows.first['customer_email'] as String?)?.isNotEmpty == true
          ? (rows.first['customer_email'] as String)
          : 'j.dalton@tech-corp.com',
      customerPhone: '+1 (555) 293-0192',
      billingAddress: '402 Madison Ave, Suite 1200\nNew York, NY 10017',
      subtotal:
          rows.isNotEmpty &&
              (rows.first['total_price'] as num?) != null &&
              (rows.first['total_price'] as num) > 0
          ? ((rows.first['total_price'] as num).toDouble() * 0.9)
          : 12450.00,
      luxurySurcharge:
          rows.isNotEmpty &&
              (rows.first['total_price'] as num?) != null &&
              (rows.first['total_price'] as num) > 0
          ? ((rows.first['total_price'] as num).toDouble() * 0.1)
          : 1200.00,
      totalPrice:
          rows.isNotEmpty &&
              (rows.first['total_price'] as num?) != null &&
              (rows.first['total_price'] as num) > 0
          ? (rows.first['total_price'] as num).toDouble()
          : 13650.00,
      depositPaid: 2000.00,
      balanceDue:
          rows.isNotEmpty &&
              (rows.first['total_price'] as num?) != null &&
              (rows.first['total_price'] as num) > 0
          ? ((rows.first['total_price'] as num).toDouble() - 2000.00)
          : 11650.00,
      itinerary: const [
        ItineraryItem(
          iconName: 'flight_takeoff',
          title: 'Flight: JFK → NAP',
          subtitle: 'Emirates Airlines • Business Class • Flight EK-204',
        ),
        ItineraryItem(
          iconName: 'hotel',
          title: 'Stay: Belmond Hotel Caruso',
          subtitle: 'Ravello, Italy • Junior Suite • 7 Nights',
        ),
        ItineraryItem(
          iconName: 'directions_car',
          title: 'Transfer: Private Chauffeur',
          subtitle: 'Mercedes S-Class • Airport Pickup & Local Tours',
        ),
      ],
      travelers: [
        TravelerDetail(
          name:
              rows.isNotEmpty &&
                  (rows.first['customer_name'] as String?)?.isNotEmpty == true
              ? (rows.first['customer_name'] as String)
              : 'James Dalton',
          initials: 'JD',
          isLead: true,
          documentId: 'P-8821902',
          preferences: const ['Vegan', 'Window Seat'],
          status: 'Verified',
        ),
        const TravelerDetail(
          name: 'Sarah Dalton',
          initials: 'SD',
          isLead: false,
          documentId: 'P-8821903',
          preferences: ['Late Checkout'],
          status: 'Verified',
        ),
      ],
      timeline: const [
        ActivityTimelineItem(
          title: 'Payment Verified',
          timestamp: 'Oct 12, 2024 • 14:30',
          note: '"System: Wire transfer confirmed by finance suite."',
          isPrimary: true,
        ),
        ActivityTimelineItem(
          title: 'Documents Sent',
          timestamp: 'Oct 11, 2024 • 09:12',
        ),
        ActivityTimelineItem(
          title: 'Booking Initialized',
          timestamp: 'Oct 10, 2024 • 16:45',
        ),
      ],
    );

    return sampleDetail;
  }

  @override
  Future<void> updateBookingStatus(int id, String newStatus) async {
    final db = await appDatabase.database;
    await db.update(
      DatabaseConstants.bookingsTable,
      {'status': newStatus, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

@Riverpod(keepAlive: true)
BookingDetailsLocalDataSource bookingDetailsDataSource(Ref ref) {
  return BookingDetailsLocalDataSource(ref.watch(appDatabaseProvider));
}
