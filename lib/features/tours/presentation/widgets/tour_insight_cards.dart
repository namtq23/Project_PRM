import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../presentation/view_models/tours_viewmodel.dart';
import '../theme/tours_theme.dart';

class TourInsightCards extends ConsumerWidget {
  const TourInsightCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(toursViewModelProvider);

    // Dynamic calculations
    final totalValue = state.allTours.fold<double>(
      0.0,
      (sum, tour) => sum + tour.price,
    );
    final priceFormat = NumberFormat('#,###', 'en_US');
    final valueString =
        '${priceFormat.format(totalValue).replaceAll(',', '.')} đ';

    final mostPopularTour = state.allTours.isNotEmpty
        ? state.allTours
              .reduce((curr, next) => curr.price > next.price ? curr : next)
              .title
        : 'Serengeti Sky Safari';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        final card1 = _InsightCard(
          title: 'Tổng giá trị kho tour',
          value: valueString,
          sub: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.trending_up, color: Color(0xFF10B981), size: 14),
              const SizedBox(width: 4),
              const Text(
                '+12% tháng này',
                style: TextStyle(color: Color(0xFF34D399), fontSize: 12),
              ),
            ],
          ),
          icon: Icons.payments_outlined,
        );

        final card2 = _InsightCard(
          title: 'Tour phổ biến nhất',
          value: mostPopularTour,
          sub: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: ToursTheme.accent, size: 14),
              SizedBox(width: 4),
              Text(
                'Đánh giá 4.9/5.0',
                style: TextStyle(
                  color: ToursTheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          icon: Icons.workspace_premium_outlined,
        );

        final card3 = _OpportunityCard(isMobile: isMobile);

        if (isMobile) {
          return Column(
            children: [
              card1,
              const SizedBox(height: ToursTheme.stackMd),
              card2,
              const SizedBox(height: ToursTheme.stackMd),
              card3,
            ],
          );
        } else {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 1, child: card1),
                const SizedBox(width: ToursTheme.gutter),
                Expanded(flex: 1, child: card2),
                const SizedBox(width: ToursTheme.gutter),
                Expanded(flex: 2, child: card3),
              ],
            ),
          );
        }
      },
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.title,
    required this.value,
    required this.sub,
    required this.icon,
  });

  final String title;
  final String value;
  final Widget sub;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ToursTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
        border: Border.all(color: ToursTheme.outlineVariant, width: 1),
      ),
      child: Stack(
        children: [
          // Background Icon
          Positioned(
            right: -16,
            bottom: -16,
            child: Icon(
              icon,
              size: 96,
              color: Colors.white.withValues(alpha: 0.03),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: ToursTheme.textLabel.copyWith(
                      color: ToursTheme.onSurfaceVariant,
                      fontSize: 11,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              sub,
            ],
          ),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  const _OpportunityCard({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final opportunityContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Cơ Hội Mới',
          style: TextStyle(
            color: ToursTheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Xu hướng thị trường gợi ý mức tăng trưởng 24% đối với các chuyến thám hiểm cực địa riêng tư. Hãy cân nhắc tạo gói tour mới.',
          style: TextStyle(
            color: ToursTheme.onSurface.withValues(alpha: 0.8),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );

    final exploreButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ToursTheme.primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        elevation: 4,
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Đang khám phá xu hướng thị trường du lịch mới nhất...',
            ),
            backgroundColor: ToursTheme.primary,
          ),
        );
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Khám Phá Xu Hướng',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 16),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ToursTheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
        border: Border.all(
          color: ToursTheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                opportunityContent,
                const SizedBox(height: 16),
                exploreButton,
              ],
            )
          : Row(
              children: [
                Expanded(child: opportunityContent),
                const SizedBox(width: 24),
                exploreButton,
              ],
            ),
    );
  }
}
