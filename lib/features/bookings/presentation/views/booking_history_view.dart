import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../view_models/booking_view_model.dart';
import '../../../../app/router/route_paths.dart';
import '../../models/booking_model.dart';

class BookingHistoryView extends ConsumerWidget {
  const BookingHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(bookingHistoryViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đặt chỗ'),
      ),
      body: historyAsync.when(
        data: (bookings) => bookings.isEmpty
            ? _buildEmptyState(context)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index] as BookingModel;
                  return _buildBookingCard(context, booking);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Lỗi: $err')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Bạn chưa có đơn đặt chỗ nào'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(RoutePaths.home),
            child: const Text('Khám phá tour ngay'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingModel booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push(
          RoutePaths.bookingDetail.replaceAll(':bookingId', booking.bookingId.toString()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mã: ${booking.confirmationCode}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildStatusChip(booking.status),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(DateFormat('dd/MM/yyyy').format(booking.bookingDate)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('${booking.passengerQuantity} hành khách'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng tiền:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${booking.totalCost.toStringAsFixed(0)} USD',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
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

  Widget _buildStatusChip(String status) {
    Color color = Colors.grey;
    String label = status;
    
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = Colors.blue;
        label = 'Đã xác nhận';
        break;
      case 'completed':
        color = Colors.green;
        label = 'Hoàn thành';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'Chờ xử lý';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Đã hủy';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
