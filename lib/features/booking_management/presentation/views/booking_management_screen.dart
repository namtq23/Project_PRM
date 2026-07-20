import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../view_models/booking_management_view_model.dart';
import '../../models/booking_management_model.dart';

class BookingManagementScreen extends ConsumerStatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  ConsumerState<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState
    extends ConsumerState<BookingManagementScreen> {
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingManagementViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Quản lý đặt chỗ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _StatusChip(
                  label: 'Tất cả',
                  isSelected: _selectedStatus == 'All',
                  onSelected: () => setState(() => _selectedStatus = 'All'),
                ),
                _StatusChip(
                  label: 'Chờ duyệt',
                  isSelected: _selectedStatus == 'pending',
                  onSelected: () => setState(() => _selectedStatus = 'pending'),
                ),
                _StatusChip(
                  label: 'Đã duyệt',
                  isSelected: _selectedStatus == 'approved',
                  onSelected: () =>
                      setState(() => _selectedStatus = 'approved'),
                ),
                _StatusChip(
                  label: 'Hoàn thành',
                  isSelected: _selectedStatus == 'completed',
                  onSelected: () =>
                      setState(() => _selectedStatus = 'completed'),
                ),
                _StatusChip(
                  label: 'Đã hủy',
                  isSelected: _selectedStatus == 'canceled',
                  onSelected: () =>
                      setState(() => _selectedStatus = 'canceled'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          final filteredBookings = _selectedStatus == 'All'
              ? bookings
              : bookings.where((b) => b.status == _selectedStatus).toList();

          if (filteredBookings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Không có đặt chỗ nào',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filteredBookings.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _BookingCard(booking: filteredBookings[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Lỗi: $error')),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
        checkmarkColor: const Color(0xFF0EA5E9),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF036B99) : const Color(0xFF64748B),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? const Color(0xFF0EA5E9)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends ConsumerWidget {
  const _BookingCard({required this.booking});

  final BookingManagementModel booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.tourTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                _StatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.person_outline, text: booking.customerName),
            const SizedBox(height: 4),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              text: 'Ngày đi: ${dateFormat.format(booking.bookingDate)}',
            ),
            const SizedBox(height: 4),
            _InfoRow(
              icon: Icons.group_outlined,
              text: '${booking.passengers} khách',
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tổng cộng',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                    ),
                    Text(
                      currencyFormat.format(booking.totalPrice),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0EA5E9),
                      ),
                    ),
                  ],
                ),
                _ActionButtons(booking: booking),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Color(0xFF475569), fontSize: 14),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case 'pending':
        color = const Color(0xFFF59E0B);
        text = 'Chờ duyệt';
        break;
      case 'approved':
        color = const Color(0xFF0EA5E9);
        text = 'Đã duyệt';
        break;
      case 'completed':
        color = const Color(0xFF22C55E);
        text = 'Hoàn thành';
        break;
      case 'canceled':
        color = const Color(0xFFEF4444);
        text = 'Đã hủy';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  const _ActionButtons({required this.booking});

  final BookingManagementModel booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(bookingManagementViewModelProvider.notifier);

    if (booking.status == 'pending') {
      return Row(
        children: [
          TextButton(
            onPressed: () => viewModel.cancelBooking(booking.id),
            child: const Text(
              'Từ chối',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => viewModel.approveBooking(booking.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Duyệt'),
          ),
        ],
      );
    } else if (booking.status == 'approved') {
      return ElevatedButton(
        onPressed: () => viewModel.completeBooking(booking.id),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0EA5E9),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Hoàn thành'),
      );
    }

    return IconButton(
      onPressed: () => _showDeleteDialog(context, ref, booking.id),
      icon: const Icon(Icons.delete_outline, color: Color(0xFF94A3B8)),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa đặt chỗ?'),
        content: const Text('Bạn có chắc chắn muốn xóa bản ghi này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(bookingManagementViewModelProvider.notifier)
                  .deleteBooking(id);
              Navigator.pop(context);
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }
}
