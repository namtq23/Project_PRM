import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/booking_view_model.dart';
import '../widgets/booking_design.dart';
import '../widgets/booking_history_content.dart';
import '../widgets/booking_history_navigation.dart';

class BookingHistoryView extends ConsumerWidget {
  const BookingHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(bookingHistoryViewModelProvider);

    return DefaultTabController(
      length: BookingHistoryGroup.values.length,
      child: Scaffold(
        backgroundColor: BookingDesign.background,
        drawer: const BookingMenuDrawer(),
        appBar: const BookingHistoryAppBar(),
        body: Column(
          children: [
            const BookingHistoryTabBar(),
            Expanded(
              child: history.when(
                data: (bookings) => TabBarView(
                  children: BookingHistoryGroup.values
                      .map(
                        (group) => BookingHistoryList(
                          bookings: filterBookings(bookings, group),
                          group: group,
                        ),
                      )
                      .toList(growable: false),
                ),
                loading: () => const BookingHistoryLoading(),
                error: (error, _) => BookingHistoryError(
                  message: error.toString(),
                  onRetry: () =>
                      ref.invalidate(bookingHistoryViewModelProvider),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BookingHistoryNavigationBar(),
      ),
    );
  }
}
