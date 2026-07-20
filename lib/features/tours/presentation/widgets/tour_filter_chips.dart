import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/view_models/tours_viewmodel.dart';
import '../theme/tours_theme.dart';

class TourFilterChips extends ConsumerWidget {
  const TourFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(toursViewModelProvider);
    final notifier = ref.read(toursViewModelProvider.notifier);

    final allCount = state.allTours.length;
    final activeCount = state.allTours.where((t) => t.status.toLowerCase() == 'active').length;
    final draftCount = state.allTours.where((t) => t.status.toLowerCase() == 'draft').length;
    final inactiveCount = state.allTours.where((t) => t.status.toLowerCase() == 'inactive').length;

    Widget buildChip(String label, String filterValue, int count) {
      final isSelected = state.selectedFilter.toLowerCase() == filterValue.toLowerCase();

      return GestureDetector(
        onTap: () => notifier.filterTours(filterValue),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? ToursTheme.primary : ToursTheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(ToursTheme.radiusFull),
            border: Border.all(
              color: isSelected ? Colors.transparent : ToursTheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Text(
            '$label ($count)',
            style: ToursTheme.textLabel.copyWith(
              color: isSelected ? Colors.black : ToursTheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: ToursTheme.stackSm,
      runSpacing: ToursTheme.stackSm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        buildChip('All Tours', 'all', allCount),
        buildChip('Active', 'active', activeCount),
        buildChip('Draft', 'draft', draftCount),
        buildChip('Inactive', 'inactive', inactiveCount),
      ],
    );
  }
}
