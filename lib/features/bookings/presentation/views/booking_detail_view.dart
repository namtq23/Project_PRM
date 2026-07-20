import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../view_models/booking_view_model.dart';
import '../../../../app/router/route_paths.dart';
import '../../models/booking_model.dart';

class BookingDetailView extends ConsumerWidget {
  final int bookingId;
  const BookingDetailView({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(bookingRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
      body: FutureBuilder<BookingModel?>(
        future: repository.getBookingDetail(bookingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Không tìm thấy thông tin đơn hàng'));
          }

          final booking = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, booking),
                const SizedBox(height: 24),
                _buildInfoSection(context, 'Thông tin chuyến đi', [
                  _buildDetailRow('Ngày đi:', DateFormat('dd/MM/yyyy').format(booking.bookingDate)),
                  _buildDetailRow('Số khách:', '${booking.passengerQuantity} người'),
                ]),
                const SizedBox(height: 16),
                _buildInfoSection(context, 'Thanh toán', [
                  _buildDetailRow('Phương thức:', booking.paymentMethod.split('.').last),
                  _buildDetailRow('Tổng cộng:', '${booking.totalCost.toStringAsFixed(0)} USD', isBold: true),
                ]),
                const SizedBox(height: 48),
                if (booking.status == 'completed' || booking.status == 'confirmed')
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(
                        RoutePaths.reviewTour.replaceAll(':bookingId', bookingId.toString()),
                        extra: booking,
                      ),
                      icon: const Icon(Icons.rate_review_outlined),
                      label: const Text('Gửi đánh giá tour'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BookingModel booking) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
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

  Widget _buildInfoSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
