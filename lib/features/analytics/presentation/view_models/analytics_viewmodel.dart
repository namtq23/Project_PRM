import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';

part 'analytics_viewmodel.g.dart';

class TopTourData {
  final String title;
  final int salesCount;
  final double totalSales;
  final double progress;

  const TopTourData({
    required this.title,
    required this.salesCount,
    required this.totalSales,
    required this.progress,
  });
}

class RecentBookingData {
  final int id;
  final String tourTitle;
  final String userName;
  final String bookingDate;
  final double totalCost;
  final String status;

  const RecentBookingData({
    required this.id,
    required this.tourTitle,
    required this.userName,
    required this.bookingDate,
    required this.totalCost,
    required this.status,
  });
}

class AnalyticsState {
  final bool isLoading;
  final double grossRevenue;
  final int activeBookings;
  final double avgTicketSize;
  final double customerLtv;
  final List<double> monthlyRevenue; // 12 elements
  final Map<String, double> acquisitionSources; // Direct, Social, Affiliates
  final List<double> weeklyBookings; // 4 elements
  final List<TopTourData> topTours;
  final List<RecentBookingData> recentBookings;
  final String? errorMessage;

  const AnalyticsState({
    this.isLoading = false,
    this.grossRevenue = 0.0,
    this.activeBookings = 0,
    this.avgTicketSize = 0.0,
    this.customerLtv = 0.0,
    this.monthlyRevenue = const [],
    this.acquisitionSources = const {},
    this.weeklyBookings = const [],
    this.topTours = const [],
    this.recentBookings = const [],
    this.errorMessage,
  });

  AnalyticsState copyWith({
    bool? isLoading,
    double? grossRevenue,
    int? activeBookings,
    double? avgTicketSize,
    double? customerLtv,
    List<double>? monthlyRevenue,
    Map<String, double>? acquisitionSources,
    List<double>? weeklyBookings,
    List<TopTourData>? topTours,
    List<RecentBookingData>? recentBookings,
    String? errorMessage,
  }) {
    return AnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      grossRevenue: grossRevenue ?? this.grossRevenue,
      activeBookings: activeBookings ?? this.activeBookings,
      avgTicketSize: avgTicketSize ?? this.avgTicketSize,
      customerLtv: customerLtv ?? this.customerLtv,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      acquisitionSources: acquisitionSources ?? this.acquisitionSources,
      weeklyBookings: weeklyBookings ?? this.weeklyBookings,
      topTours: topTours ?? this.topTours,
      recentBookings: recentBookings ?? this.recentBookings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class AnalyticsViewModel extends _$AnalyticsViewModel {
  @override
  AnalyticsState build() {
    // Load analytics on initialization
    Future.microtask(() => loadAnalytics());
    return const AnalyticsState(isLoading: true);
  }

  Future<void> loadAnalytics() async {
    try {
      state = state.copyWith(isLoading: true);
      final db = await ref.read(appDatabaseProvider).database;

      // 1. Gross Revenue (Total Cost of bookings that are not cancelled)
      final grossRevResult = await db.rawQuery(
        "SELECT SUM(total_cost) as total FROM bookings WHERE status != 'cancelled'"
      );
      final double grossRevenue = (grossRevResult.first['total'] as num?)?.toDouble() ?? 0.0;

      // 2. Active Bookings (Count of bookings that are pending or confirmed)
      final activeCountResult = await db.rawQuery(
        "SELECT COUNT(*) as count FROM bookings WHERE status IN ('pending', 'confirmed')"
      );
      final int activeBookings = activeCountResult.first['count'] as int? ?? 0;

      // 3. Avg. Ticket Size (Average total cost of bookings that are not cancelled)
      final avgTicketResult = await db.rawQuery(
        "SELECT AVG(total_cost) as avg_cost FROM bookings WHERE status != 'cancelled'"
      );
      final double avgTicketSize = (avgTicketResult.first['avg_cost'] as num?)?.toDouble() ?? 0.0;

      // 4. Customer LTV (Revenue per unique traveler user)
      final ltvResult = await db.rawQuery(
        "SELECT SUM(total_cost) / COUNT(DISTINCT user_id) as ltv FROM bookings WHERE status != 'cancelled'"
      );
      final double customerLtv = (ltvResult.first['ltv'] as num?)?.toDouble() ?? 0.0;

      // 5. Monthly Revenue (Jan - Dec)
      final monthlyRows = await db.rawQuery('''
        SELECT strftime('%m', booking_date) as month, SUM(total_cost) as revenue
        FROM bookings
        WHERE status != 'cancelled'
        GROUP BY month
      ''');
      final monthlyRevenue = List<double>.filled(12, 0.0);
      for (final row in monthlyRows) {
        final monthStr = row['month'] as String?;
        if (monthStr != null) {
          final monthIdx = int.tryParse(monthStr);
          if (monthIdx != null && monthIdx >= 1 && monthIdx <= 12) {
            monthlyRevenue[monthIdx - 1] = (row['revenue'] as num).toDouble();
          }
        }
      }

      // 6. Acquisition Sources (Mapped dynamically from payment methods)
      final sourceRows = await db.rawQuery('''
        SELECT payment_method, COUNT(*) as count
        FROM bookings
        GROUP BY payment_method
      ''');
      int directCount = 0;
      int socialCount = 0;
      int affiliateCount = 0;
      for (final row in sourceRows) {
        final pm = (row['payment_method'] as String?)?.toLowerCase() ?? '';
        final count = row['count'] as int? ?? 0;
        if (pm.contains('credit') || pm.contains('card') || pm.contains('visa')) {
          directCount += count;
        } else if (pm.contains('bank') || pm.contains('transfer')) {
          socialCount += count;
        } else {
          affiliateCount += count;
        }
      }
      final totalSourcesCount = directCount + socialCount + affiliateCount;
      final Map<String, double> acquisitionSources = {
        'Tìm kiếm trực tiếp': totalSourcesCount > 0 ? (directCount / totalSourcesCount) * 100 : 45.0,
        'Mạng xã hội': totalSourcesCount > 0 ? (socialCount / totalSourcesCount) * 100 : 35.0,
        'Tiếp thị liên kết': totalSourcesCount > 0 ? (affiliateCount / totalSourcesCount) * 100 : 20.0,
      };

      // 7. Booking Trends (4 Weeks based on day of month)
      final weeklyRows = await db.rawQuery('''
        SELECT strftime('%d', booking_date) as day, COUNT(*) as count
        FROM bookings
        GROUP BY day
      ''');
      final weeklyBookings = List<double>.filled(4, 0.0);
      for (final row in weeklyRows) {
        final dayStr = row['day'] as String?;
        final count = (row['count'] as num?)?.toDouble() ?? 0.0;
        if (dayStr != null) {
          final day = int.tryParse(dayStr);
          if (day != null) {
            if (day <= 7) {
              weeklyBookings[0] += count;
            } else if (day <= 14) {
              weeklyBookings[1] += count;
            } else if (day <= 21) {
              weeklyBookings[2] += count;
            } else {
              weeklyBookings[3] += count;
            }
          }
        }
      }

      // 8. Top Performing Tours
      final topToursRows = await db.rawQuery('''
        SELECT t.id, t.title, COUNT(b.id) as sales_count, SUM(b.total_cost) as total_sales
        FROM tours t
        LEFT JOIN bookings b ON t.id = b.tour_id AND b.status != 'cancelled'
        GROUP BY t.id
        ORDER BY sales_count DESC
        LIMIT 5
      ''');
      
      // Calculate max sales to calculate progression bar
      int maxSales = 1;
      for (final row in topToursRows) {
        final count = row['sales_count'] as int? ?? 0;
        if (count > maxSales) maxSales = count;
      }

      final List<TopTourData> topTours = topToursRows.map((row) {
        final salesCount = row['sales_count'] as int? ?? 0;
        return TopTourData(
          title: row['title'] as String? ?? 'Chưa xác định',
          salesCount: salesCount,
          totalSales: (row['total_sales'] as num?)?.toDouble() ?? 0.0,
          progress: salesCount / maxSales,
        );
      }).toList();

      // 9. Real-time Booking Feed
      final feedRows = await db.rawQuery('''
        SELECT b.id, b.booking_date, b.total_cost, b.status, t.title as tour_title, u.full_name as user_name
        FROM bookings b
        INNER JOIN tours t ON b.tour_id = t.id
        INNER JOIN users u ON b.user_id = u.id
        ORDER BY b.created_at DESC
        LIMIT 10
      ''');

      final List<RecentBookingData> recentBookings = feedRows.map((row) {
        return RecentBookingData(
          id: row['id'] as int? ?? 0,
          tourTitle: row['tour_title'] as String? ?? 'Chưa xác định',
          userName: row['user_name'] as String? ?? 'Khách vãng lai',
          bookingDate: row['booking_date'] as String? ?? '',
          totalCost: (row['total_cost'] as num?)?.toDouble() ?? 0.0,
          status: row['status'] as String? ?? 'pending',
        );
      }).toList();

      state = AnalyticsState(
        isLoading: false,
        grossRevenue: grossRevenue,
        activeBookings: activeBookings,
        avgTicketSize: avgTicketSize,
        customerLtv: customerLtv,
        monthlyRevenue: monthlyRevenue,
        acquisitionSources: acquisitionSources,
        weeklyBookings: weeklyBookings,
        topTours: topTours,
        recentBookings: recentBookings,
      );
    } catch (e) {
      state = AnalyticsState(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}
