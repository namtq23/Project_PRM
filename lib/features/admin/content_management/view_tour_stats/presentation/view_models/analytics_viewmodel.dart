import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/data_sources/tour_stats_data_source.dart';
import '../../data/repositories/tour_stats_repository.dart';

part 'analytics_viewmodel.g.dart';

class AnalyticsState {
  final bool isLoading;
  final double grossRevenue;
  final int activeBookings;
  final double avgTicketSize;
  final double customerLtv;
  final List<double> monthlyRevenue;
  final Map<String, double> acquisitionSources;
  final List<double> weeklyBookings;
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
    Future.microtask(() => loadAnalytics());
    return const AnalyticsState(isLoading: true);
  }

  Future<void> loadAnalytics() async {
    try {
      state = state.copyWith(isLoading: true);
      final repository = ref.read(tourStatsRepositoryProvider);
      final data = await repository.getAnalyticsData();

      state = AnalyticsState(
        isLoading: false,
        grossRevenue: data.grossRevenue,
        activeBookings: data.activeBookings,
        avgTicketSize: data.avgTicketSize,
        customerLtv: data.customerLtv,
        monthlyRevenue: data.monthlyRevenue,
        acquisitionSources: data.acquisitionSources,
        weeklyBookings: data.weeklyBookings,
        topTours: data.topTours,
        recentBookings: data.recentBookings,
      );
    } catch (e) {
      state = AnalyticsState(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}
