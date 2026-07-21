import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../tours/presentation/theme/tours_theme.dart';
import '../../../../../tours/presentation/widgets/admin_layout.dart';
import '../../data/data_sources/tour_stats_data_source.dart';
import '../view_models/analytics_viewmodel.dart';

class TourStatisticsScreen extends ConsumerStatefulWidget {
  const TourStatisticsScreen({super.key});

  @override
  ConsumerState<TourStatisticsScreen> createState() => _TourStatisticsScreenState();
}

class _TourStatisticsScreenState extends ConsumerState<TourStatisticsScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    // Refresh statistics dynamically when the page mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsViewModelProvider.notifier).loadAnalytics();
    });
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ToursTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
          border: Border.all(color: ToursTheme.outlineVariant, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: ToursTheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: ToursTheme.onSurfaceVariant.withOpacity(0.7),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ToursTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
        border: Border.all(color: ToursTheme.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(child: child),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsViewModelProvider);

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ToursTheme.background,
        colorScheme: const ColorScheme.dark(
          primary: ToursTheme.primary,
          secondary: ToursTheme.secondary,
          surface: ToursTheme.surface,
        ),
      ),
      child: AdminLayout(
        currentMenu: 'Analytics',
        child: SafeArea(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator(color: ToursTheme.primary))
              : state.errorMessage != null
                  ? Center(child: Text('Lỗi: ${state.errorMessage}', style: const TextStyle(color: ToursTheme.danger)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          const Text(
                            'Phân Tích & Thống Kê',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Theo dõi doanh thu, số lượng đơn hàng, và hiệu năng bán hàng của các tour du lịch.',
                            style: TextStyle(
                              color: ToursTheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 4 KPI Stat Cards
                          Row(
                            children: [
                              _buildStatCard(
                                title: 'TỔNG DOANH THU',
                                value: _currencyFormat.format(state.grossRevenue),
                                subtitle: 'Đã thanh toán & xác nhận',
                                icon: Icons.monetization_on_outlined,
                                color: ToursTheme.primary,
                              ),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                title: 'ĐƠN ĐẶT HOẠT ĐỘNG',
                                value: '${state.activeBookings}',
                                subtitle: 'Chờ xử lý / Đã xác nhận',
                                icon: Icons.receipt_long_outlined,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                title: 'ĐƠN HÀNG TRUNG BÌNH',
                                value: _currencyFormat.format(state.avgTicketSize),
                                subtitle: 'Giá trị trung bình mỗi đơn',
                                icon: Icons.analytics_outlined,
                                color: Colors.purple,
                              ),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                title: 'GIÁ TRỊ VÒNG ĐỜI (LTV)',
                                value: _currencyFormat.format(state.customerLtv),
                                subtitle: 'Doanh thu bình quân mỗi khách',
                                icon: Icons.supervised_user_circle_outlined,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Bento Grid Charts & Lists
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final double blockHeight = 320;
                              return Column(
                                children: [
                                  // Row 1: Bar Chart (Monthly Revenue) & Doughnut Chart (Acquisition Source)
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: SizedBox(
                                          height: blockHeight,
                                          child: _buildCardContainer(
                                            title: 'Doanh Thu Hàng Tháng (VNĐ)',
                                            child: _buildBarChart(state.monthlyRevenue),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          height: blockHeight,
                                          child: _buildCardContainer(
                                            title: 'Nguồn Tiếp Cận Khách Hàng',
                                            child: _buildDoughnutChart(state.acquisitionSources),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Row 2: Area Chart (Booking Trends) & Top Performing Tours List
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: SizedBox(
                                          height: blockHeight,
                                          child: _buildCardContainer(
                                            title: 'Xu Hướng Đơn Đặt (Theo Tuần)',
                                            child: _buildAreaChart(state.weeklyBookings),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        flex: 6,
                                        child: SizedBox(
                                          height: blockHeight,
                                          child: _buildCardContainer(
                                            title: 'Top Tour Bán Chạy Nhất',
                                            child: _buildTopToursList(state.topTours),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Row 3: Realtime Booking Feed (Full width)
                                  SizedBox(
                                    height: 400,
                                    child: _buildCardContainer(
                                      title: 'Luồng Đơn Đặt Tour Mới Nhất (Realtime Feed)',
                                      child: _buildBookingFeedTable(state.recentBookings),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  // Monthly Revenue Bar Chart
  Widget _buildBarChart(List<double> data) {
    double maxVal = 10000000.0;
    for (final v in data) {
      if (v > maxVal) maxVal = v;
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal * 1.15,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => ToursTheme.surfaceContainerHigh,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                _currencyFormat.format(rod.toY),
                const TextStyle(color: ToursTheme.primary, fontWeight: FontWeight.bold, fontSize: 11),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];
                if (value >= 0 && value < 12) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(months[value.toInt()], style: const TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 10)),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(12, (index) {
          final val = data.length > index ? data[index] : 0.0;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: val,
                width: 14,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                gradient: LinearGradient(
                  colors: [
                    ToursTheme.primary,
                    ToursTheme.primary.withOpacity(0.4),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Acquisition Sources Doughnut Chart
  Widget _buildDoughnutChart(Map<String, double> sources) {
    if (sources.isEmpty) return const Center(child: Text('Không có dữ liệu', style: TextStyle(color: ToursTheme.onSurfaceVariant)));

    final entries = sources.entries.toList();
    final colors = [ToursTheme.primary, Colors.blue, Colors.orange];

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 36,
              sections: List.generate(entries.length, (idx) {
                final entry = entries[idx];
                final col = colors[idx % colors.length];
                return PieChartSectionData(
                  value: entry.value,
                  title: '${entry.value.toStringAsFixed(0)}%',
                  color: col,
                  radius: 24,
                  titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                );
              }),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(entries.length, (idx) {
              final entry = entries[idx];
              final col = colors[idx % colors.length];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: col, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.value.toStringAsFixed(1)}%',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // Booking Trends Area Chart
  Widget _buildAreaChart(List<double> weeklyData) {
    double maxVal = 5.0;
    for (final v in weeklyData) {
      if (v > maxVal) maxVal = v;
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value >= 0 && value < 4) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text('Tuần ${value.toInt() + 1}', style: const TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 10)),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(4, (index) {
              final count = weeklyData.length > index ? weeklyData[index] : 0.0;
              return FlSpot(index.toDouble(), count);
            }),
            isCurved: true,
            color: ToursTheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  ToursTheme.primary.withOpacity(0.2),
                  ToursTheme.primary.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Top Performing Tours list
  Widget _buildTopToursList(List<TopTourData> tours) {
    if (tours.isEmpty) return const Center(child: Text('Không có dữ liệu', style: TextStyle(color: ToursTheme.onSurfaceVariant)));

    return ListView.builder(
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tour.title,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${tour.salesCount} lượt bán',
                    style: const TextStyle(color: ToursTheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: SizedBox(
                        height: 4,
                        child: LinearProgressIndicator(
                          value: tour.progress,
                          backgroundColor: ToursTheme.surfaceContainerHigh,
                          valueColor: const AlwaysStoppedAnimation<Color>(ToursTheme.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _currencyFormat.format(tour.totalSales),
                    style: TextStyle(color: ToursTheme.onSurfaceVariant.withOpacity(0.8), fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Realtime Booking Feed Table
  Widget _buildBookingFeedTable(List<RecentBookingData> feeds) {
    if (feeds.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.feed_outlined, size: 48, color: ToursTheme.outline),
            SizedBox(height: 12),
            Text('Chưa có lịch sử giao dịch nào.', style: TextStyle(color: ToursTheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: ToursTheme.surface,
        borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
        border: Border.all(color: ToursTheme.outlineVariant, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header Row
          Container(
            color: ToursTheme.surfaceContainerHigh,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('TOUR / TRẢI NGHIỆM', style: TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('KHÁCH HÀNG', style: TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('THỜI GIAN', style: TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('TỔNG TIỀN', style: TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text('TRẠNG THÁI', style: TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
          // Rows
          Expanded(
            child: ListView.builder(
              itemCount: feeds.length,
              itemBuilder: (context, index) {
                final feed = feeds[index];
                final isEven = index % 2 == 0;

                // Status Badge Color
                Color statusColor = Colors.grey;
                String statusLabel = 'Chờ xử lý';
                if (feed.status.toLowerCase() == 'completed') {
                  statusColor = ToursTheme.success;
                  statusLabel = 'Hoàn thành';
                } else if (feed.status.toLowerCase() == 'confirmed') {
                  statusColor = Colors.blue;
                  statusLabel = 'Đã xác nhận';
                } else if (feed.status.toLowerCase() == 'cancelled') {
                  statusColor = ToursTheme.danger;
                  statusLabel = 'Đã hủy';
                }

                // Date Formatting
                String dateStr = feed.bookingDate;
                try {
                  final dt = DateTime.parse(feed.bookingDate).toLocal();
                  dateStr = DateFormat('dd/MM/yyyy HH:mm').format(dt);
                } catch (_) {}

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isEven ? Colors.transparent : ToursTheme.surfaceContainerLow.withOpacity(0.3),
                    border: const Border(bottom: BorderSide(color: ToursTheme.outlineVariant, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          feed.tourTitle,
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          feed.userName,
                          style: const TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          dateStr,
                          style: const TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          _currencyFormat.format(feed.totalCost),
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: statusColor.withOpacity(0.4), width: 0.8),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
