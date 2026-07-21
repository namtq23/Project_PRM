import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data_sources/tour_stats_data_source.dart';

part 'tour_stats_repository.g.dart';

abstract interface class TourStatsRepository {
  Future<AnalyticsDataResult> getAnalyticsData();
}

class TourStatsRepositoryImpl implements TourStatsRepository {
  TourStatsRepositoryImpl(this._dataSource);

  final TourStatsDataSource _dataSource;

  @override
  Future<AnalyticsDataResult> getAnalyticsData() async {
    try {
      return await _dataSource.fetchAnalyticsData();
    } catch (e) {
      throw Exception('Lỗi tải dữ liệu thống kê tour: $e');
    }
  }
}

@Riverpod(keepAlive: true)
TourStatsRepository tourStatsRepository(Ref ref) {
  return TourStatsRepositoryImpl(ref.watch(tourStatsDataSourceProvider));
}
