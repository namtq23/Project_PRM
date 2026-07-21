import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../view_models/tour_detail_view_model.dart';
import '../widgets/tour_detail_widgets.dart';

class TourDetailScreen extends ConsumerWidget {
  final int tourId;

  const TourDetailScreen({super.key, required this.tourId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tourState = ref.watch(tourDetailViewModelProvider(tourId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: tourState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Lỗi: $error'),
              TextButton(
                onPressed: () =>
                    ref.invalidate(tourDetailViewModelProvider(tourId)),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
        data: (tour) {
          if (tour == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Không tìm thấy tour này'),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Quay lại'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  TourDetailAppBar(images: tour.images),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TourDetailHeader(tour: tour),
                          const SizedBox(height: 32),
                          TourDetailOverview(
                            description: tour.description ?? '',
                          ),
                          const SizedBox(height: 32),
                          if (tour.itinerary.isNotEmpty) ...[
                            TourDetailItinerary(itinerary: tour.itinerary),
                            const SizedBox(height: 32),
                          ],
                          TourDetailInclusionsExclusions(
                            inclusions: tour.inclusions,
                            exclusions: tour.exclusions,
                          ),
                          const SizedBox(height: 32),
                          TourDetailMap(
                            locationName: tour.locationName ?? 'Đang cập nhật',
                          ),
                          const SizedBox(height: 32),
                          TourDetailPolicies(
                            policy:
                                tour.cancellationPolicy ??
                                'Theo quy định công ty',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Sticky Bottom CTA
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: TourDetailBottomBar(price: tour.price),
              ),
            ],
          );
        },
      ),
    );
  }
}
