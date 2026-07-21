import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/router/route_paths.dart';
import '../../models/booking_model.dart';
import 'booking_currency.dart';
import 'booking_design.dart';

enum BookingHistoryGroup {
  upcoming('Sắp tới'),
  completed('Đã hoàn thành'),
  cancelled('Đã hủy');

  const BookingHistoryGroup(this.label);

  final String label;
}

List<BookingModel> filterBookings(
  List<BookingModel> bookings,
  BookingHistoryGroup group,
) {
  return bookings
      .where((booking) {
        final status = booking.status.trim().toLowerCase();
        return switch (group) {
          BookingHistoryGroup.upcoming =>
            status != 'completed' &&
                status != 'cancelled' &&
                status != 'canceled',
          BookingHistoryGroup.completed => status == 'completed',
          BookingHistoryGroup.cancelled =>
            status == 'cancelled' || status == 'canceled',
        };
      })
      .toList(growable: false);
}

class BookingHistoryTabBar extends StatelessWidget {
  const BookingHistoryTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: BookingDesign.background,
        border: Border(
          bottom: BorderSide(color: BookingDesign.surfaceContainer),
        ),
      ),
      child: TabBar(
        tabs: BookingHistoryGroup.values
            .map((group) => Tab(text: group.label, height: 54))
            .toList(growable: false),
        labelColor: BookingDesign.primary,
        unselectedLabelColor: BookingDesign.mutedText,
        labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        indicatorColor: BookingDesign.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 2,
        dividerHeight: 0,
        overlayColor: WidgetStatePropertyAll(
          BookingDesign.primary.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}

class BookingHistoryList extends StatelessWidget {
  const BookingHistoryList({
    super.key,
    required this.bookings,
    required this.group,
  });

  final List<BookingModel> bookings;
  final BookingHistoryGroup group;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return _BookingHistoryEmpty(group: group);
    }

    return ListView.separated(
      key: PageStorageKey<String>('booking-history-${group.name}'),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
      itemCount: bookings.length,
      separatorBuilder: (_, _) => const SizedBox(height: 24),
      itemBuilder: (context, index) => _BookingCard(booking: bookings[index]),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final bookingId = booking.bookingId;

    return Material(
      color: BookingDesign.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: BookingDesign.outline.withValues(alpha: 0.48)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: bookingId == null
            ? null
            : () => context.push(RoutePaths.bookingDetailFor('$bookingId')),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Mã đơn hàng: ${_displayConfirmationCode(booking)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: BookingDesign.subtleText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _BookingStatusChip(status: booking.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                bookingTourTitle(booking.tourId),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: BookingDesign.text,
                  fontSize: 18,
                  height: 1.32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              _BookingMetadataRow(
                icon: Icons.calendar_month_outlined,
                label:
                    'Khởi hành: ${DateFormat('dd/MM/yyyy').format(booking.bookingDate)}',
              ),
              const SizedBox(height: 12),
              _BookingMetadataRow(
                icon: Icons.person_outline,
                label:
                    'Khách hàng: ${booking.passengerQuantity.toString().padLeft(2, '0')} hành khách',
              ),
              const SizedBox(height: 24),
              Divider(
                height: 1,
                color: BookingDesign.outline.withValues(alpha: 0.38),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tổng tiền',
                          style: TextStyle(
                            color: BookingDesign.subtleText,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatBookingCurrency(booking.totalCost),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: BookingDesign.warning,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: bookingId == null
                          ? null
                          : () => context.push(
                              RoutePaths.bookingDetailFor('$bookingId'),
                            ),
                      style: FilledButton.styleFrom(
                        backgroundColor: BookingDesign.primary,
                        foregroundColor: BookingDesign.onPrimary,
                        disabledBackgroundColor: BookingDesign.surfaceHigh,
                        disabledForegroundColor: BookingDesign.subtleText,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Chi tiết'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _displayConfirmationCode(BookingModel booking) {
  final confirmationCode = booking.confirmationCode?.trim();
  final rawCode = confirmationCode == null || confirmationCode.isEmpty
      ? 'TRV-${booking.bookingId ?? '---'}'
      : confirmationCode;
  return rawCode.startsWith('#') ? rawCode : '#$rawCode';
}

class _BookingMetadataRow extends StatelessWidget {
  const _BookingMetadataRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: BookingDesign.mutedText),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: BookingDesign.mutedText,
              fontSize: 14,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _BookingStatusChip extends StatelessWidget {
  const _BookingStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.trim().toLowerCase();
    final (
      backgroundColor,
      foregroundColor,
      label,
    ) = switch (normalizedStatus) {
      'completed' => (
        const Color(0xFF123D36),
        BookingDesign.success,
        'Hoàn thành',
      ),
      'cancelled' ||
      'canceled' => (const Color(0xFF4C1D24), BookingDesign.danger, 'Đã hủy'),
      _ => (const Color(0xFF005B7A), const Color(0xFFC9E6FF), 'Sắp tới'),
    };

    return Container(
      constraints: const BoxConstraints(minHeight: 38),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class BookingHistoryLoading extends StatelessWidget {
  const BookingHistoryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: BookingDesign.surface,
      highlightColor: BookingDesign.surfaceHigh,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
        itemCount: 2,
        separatorBuilder: (_, _) => const SizedBox(height: 24),
        itemBuilder: (_, _) => Container(
          height: 260,
          decoration: BoxDecoration(
            color: BookingDesign.surface,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _BookingHistoryEmpty extends StatelessWidget {
  const _BookingHistoryEmpty({required this.group});

  final BookingHistoryGroup group;

  @override
  Widget build(BuildContext context) {
    final message = switch (group) {
      BookingHistoryGroup.upcoming => 'Bạn chưa có chuyến đi sắp tới',
      BookingHistoryGroup.completed => 'Bạn chưa hoàn thành chuyến đi nào',
      BookingHistoryGroup.cancelled => 'Bạn chưa hủy chuyến đi nào',
    };

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 96),
        Container(
          width: 88,
          height: 88,
          decoration: const BoxDecoration(
            color: BookingDesign.surface,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.confirmation_number_outlined,
            size: 42,
            color: BookingDesign.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: BookingDesign.text,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Các đơn đặt tour của bạn sẽ được hiển thị tại đây.',
          textAlign: TextAlign.center,
          style: TextStyle(color: BookingDesign.subtleText, fontSize: 14),
        ),
        const SizedBox(height: 24),
        Center(
          child: FilledButton.icon(
            onPressed: () => context.go(RoutePaths.home),
            style: FilledButton.styleFrom(
              backgroundColor: BookingDesign.primary,
              foregroundColor: BookingDesign.onPrimary,
            ),
            icon: const Icon(Icons.explore_outlined),
            label: const Text('Khám phá tour'),
          ),
        ),
      ],
    );
  }
}

class BookingHistoryError extends StatelessWidget {
  const BookingHistoryError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF4C1D24),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: BookingDesign.danger,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Không thể tải lịch sử đặt chỗ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: BookingDesign.text,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: BookingDesign.subtleText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: BookingDesign.primary,
                foregroundColor: BookingDesign.onPrimary,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
