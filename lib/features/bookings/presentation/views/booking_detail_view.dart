import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_paths.dart';
import '../../models/booking_model.dart';
import '../view_models/booking_view_model.dart';
import '../widgets/booking_currency.dart';

class BookingDetailView extends ConsumerWidget {
  const BookingDetailView({required this.bookingId, super.key});

  final int bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(bookingDetailViewModelProvider(bookingId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        actions: [
          IconButton(
            tooltip: 'Về trang chủ',
            onPressed: () => context.go(RoutePaths.home),
            icon: const Icon(Icons.home_outlined),
          ),
        ],
      ),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      ref.invalidate(bookingDetailViewModelProvider(bookingId)),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
        data: (booking) => booking == null
            ? const Center(child: Text('Không tìm thấy thông tin đơn hàng'))
            : _BookingDetailContent(booking: booking),
      ),
    );
  }
}

class _BookingDetailContent extends StatelessWidget {
  const _BookingDetailContent({required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildInfoSection(context, 'Thông tin chuyến đi', [
            _buildDetailRow(
              'Ngày đi:',
              DateFormat('dd/MM/yyyy').format(booking.bookingDate),
            ),
            _buildDetailRow('Số khách:', '${booking.passengerQuantity} người'),
          ]),
          const SizedBox(height: 16),
          _buildInfoSection(context, 'Thanh toán', [
            _buildDetailRow('Phương thức:', booking.paymentMethod),
            _buildDetailRow(
              'Tổng cộng:',
              formatBookingCurrency(booking.totalCost),
              isBold: true,
            ),
          ]),
          const SizedBox(height: 48),
          if (booking.status.toLowerCase() == 'completed')
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => context.push(
                  RoutePaths.reviewTour.replaceAll(
                    ':bookingId',
                    booking.bookingId.toString(),
                  ),
                  extra: booking,
                ),
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text('Gửi đánh giá tour'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Mã xác nhận'),
          const SizedBox(height: 8),
          Text(
            booking.confirmationCode ?? '-',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            booking.status.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
