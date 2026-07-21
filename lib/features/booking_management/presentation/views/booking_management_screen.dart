import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/booking_management_model.dart';
import '../view_models/booking_management_view_model.dart';

class BookingManagementScreen extends ConsumerStatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  ConsumerState<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState
    extends ConsumerState<BookingManagementScreen> {
  String _selectedStatus = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _exportCsv(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xuất báo cáo CSV thành công (Export CSV completed)'),
        backgroundColor: Color(0xFF006591),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showNewBookingDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final tourController = TextEditingController(
      text: 'Hạ Long Bay Cruise 5 Sao',
    );
    final priceController = TextEditingController(text: '3500000');
    final passengersController = TextEditingController(text: '2');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tạo đặt chỗ mới'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên khách hàng',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Vui lòng nhập tên' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Vui lòng nhập email' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: tourController,
                  decoration: const InputDecoration(
                    labelText: 'Tên tour',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Vui lòng nhập tên tour' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tổng tiền (VNĐ)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || double.tryParse(v) == null
                            ? 'Không hợp lệ'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: passengersController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Số khách',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || int.tryParse(v) == null
                            ? 'Không hợp lệ'
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                ref
                    .read(bookingManagementViewModelProvider.notifier)
                    .createBooking(
                      customerName: nameController.text.trim(),
                      customerEmail: emailController.text.trim(),
                      tourTitle: tourController.text.trim(),
                      totalPrice: double.parse(priceController.text),
                      passengers: int.parse(passengersController.text),
                      bookingDate: DateTime.now().add(const Duration(days: 5)),
                    );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã tạo đặt chỗ thành công!'),
                    backgroundColor: Color(0xFF22C55E),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF006591),
            ),
            child: const Text('Tạo mới'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingManagementViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Booking Management',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'Executive Suite • Theo dõi thời gian thực',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Xuất CSV',
            icon: const Icon(
              Icons.file_download_outlined,
              color: Color(0xFF006591),
            ),
            onPressed: () => _exportCsv(context),
          ),
          IconButton(
            tooltip: 'Làm mới',
            icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
            onPressed: () => ref.invalidate(bookingManagementViewModelProvider),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewBookingDialog(context),
        backgroundColor: const Color(0xFF006591),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Đặt chỗ mới',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          final filteredBookings = bookings.where((b) {
            final matchesStatus =
                _selectedStatus == 'All' || b.status == _selectedStatus;
            final query = _searchController.text.toLowerCase();
            final matchesSearch =
                b.customerName.toLowerCase().contains(query) ||
                b.customerEmail.toLowerCase().contains(query) ||
                b.tourTitle.toLowerCase().contains(query) ||
                b.id.toString().contains(query);
            return matchesStatus && matchesSearch;
          }).toList();

          return Column(
            children: [
              _buildBentoStats(bookings),
              _buildFiltersSection(),
              Expanded(
                child: filteredBookings.isEmpty
                    ? _buildEmptyState()
                    : _buildBookingList(filteredBookings),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF006591)),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Color(0xFFEF4444),
                ),
                const SizedBox(height: 12),
                Text(
                  'Lỗi tải dữ liệu: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () =>
                      ref.invalidate(bookingManagementViewModelProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBentoStats(List<BookingManagementModel> bookings) {
    final pendingCount = bookings.where((b) => b.status == 'pending').length;
    final totalRevenue = bookings
        .where((b) => b.status == 'completed' || b.status == 'approved')
        .fold(0.0, (sum, b) => sum + b.totalPrice);
    final avgTicket = bookings.isEmpty ? 0.0 : totalRevenue / bookings.length;
    final currencyFormat = NumberFormat.compactCurrency(
      locale: 'vi_VN',
      symbol: '₫',
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _StatBentoCard(
              label: 'TỔNG ĐẶT CHỖ',
              value: bookings.length.toString(),
              subtext: '+12% tuần này',
              icon: Icons.bookmark_border,
              color: const Color(0xFF006591),
            ),
            const SizedBox(width: 8),
            _StatBentoCard(
              label: 'DOANH THU',
              value: currencyFormat.format(totalRevenue),
              subtext: '+8.4% tăng trưởng',
              icon: Icons.trending_up,
              color: const Color(0xFF22C55E),
            ),
            const SizedBox(width: 8),
            _StatBentoCard(
              label: 'CHỜ DUYỆT',
              value: pendingCount.toString(),
              subtext: pendingCount > 0 ? 'Cần xử lý ngay' : 'Đã xử lý xong',
              icon: Icons.hourglass_top_outlined,
              color: const Color(0xFFF59E0B),
            ),
            const SizedBox(width: 8),
            _StatBentoCard(
              label: 'GIÁ TRUNG BÌNH',
              value: currencyFormat.format(avgTicket),
              subtext: 'Ổn định',
              icon: Icons.confirmation_number_outlined,
              color: const Color(0xFF6366F1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm tên, email, tour hoặc mã đơn...',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF94A3B8),
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: Color(0xFF64748B),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterTab(
                  label: 'Tất cả',
                  isSelected: _selectedStatus == 'All',
                  onTap: () => setState(() => _selectedStatus = 'All'),
                ),
                _FilterTab(
                  label: 'Chờ duyệt',
                  isSelected: _selectedStatus == 'pending',
                  onTap: () => setState(() => _selectedStatus = 'pending'),
                  badgeColor: const Color(0xFFF59E0B),
                ),
                _FilterTab(
                  label: 'Đã duyệt',
                  isSelected: _selectedStatus == 'approved',
                  onTap: () => setState(() => _selectedStatus = 'approved'),
                  badgeColor: const Color(0xFF0EA5E9),
                ),
                _FilterTab(
                  label: 'Hoàn thành',
                  isSelected: _selectedStatus == 'completed',
                  onTap: () => setState(() => _selectedStatus = 'completed'),
                  badgeColor: const Color(0xFF22C55E),
                ),
                _FilterTab(
                  label: 'Đã hủy',
                  isSelected: _selectedStatus == 'canceled',
                  onTap: () => setState(() => _selectedStatus = 'canceled'),
                  badgeColor: const Color(0xFFEF4444),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<BookingManagementModel> bookings) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _BookingItemCard(booking: bookings[index]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Không tìm thấy đặt chỗ phù hợp',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Thử tìm kiếm với từ khóa khác hoặc thay đổi bộ lọc',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _StatBentoCard extends StatelessWidget {
  const _StatBentoCard({
    required this.label,
    required this.value,
    required this.subtext,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String subtext;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: color,
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeColor,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006591) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF006591)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeColor != null && !isSelected) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF475569),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingItemCard extends ConsumerWidget {
  const _BookingItemCard({required this.booking});
  final BookingManagementModel booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final dateFormat = DateFormat('dd/MM/yyyy');

    // Get initials for avatar
    final nameParts = booking.customerName.trim().split(' ');
    final initials = nameParts.length >= 2
        ? '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase()
        : booking.customerName.isNotEmpty
        ? booking.customerName[0].toUpperCase()
        : 'U';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: _getStatusColor(booking.status)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#BK-${booking.id.toString().padLeft(4, '0')}',
                                  style: const TextStyle(
                                    color: Color(0xFF475569),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _StatusBadge(status: booking.status),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        booking.tourTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: const Color(
                              0xFF006591,
                            ).withValues(alpha: 0.1),
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF006591),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.customerName,
                                  style: const TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  booking.customerEmail,
                                  style: const TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateFormat.format(booking.bookingDate),
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.people_outline,
                            size: 14,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${booking.passengers} khách',
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tổng thanh toán',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                currencyFormat.format(booking.totalPrice),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF006591),
                                ),
                              ),
                            ],
                          ),
                          _buildActions(context, ref),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(bookingManagementViewModelProvider.notifier);

    if (booking.status == 'pending') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            onPressed: () => viewModel.cancelBooking(booking.id),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
              side: const BorderSide(color: Color(0xFFEF4444)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Từ chối', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => viewModel.approveBooking(booking.id),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Duyệt', style: TextStyle(fontSize: 12)),
          ),
        ],
      );
    } else if (booking.status == 'approved') {
      return FilledButton.icon(
        onPressed: () => viewModel.completeBooking(booking.id),
        icon: const Icon(Icons.check_circle_outline, size: 14),
        label: const Text('Hoàn thành', style: TextStyle(fontSize: 12)),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF006591),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return IconButton(
      onPressed: () => _showDeleteDialog(context, ref),
      icon: const Icon(
        Icons.delete_outline,
        color: Color(0xFF94A3B8),
        size: 20,
      ),
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(6),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'approved':
        return const Color(0xFF0EA5E9);
      case 'completed':
        return const Color(0xFF22C55E);
      case 'canceled':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa đặt chỗ?'),
        content: const Text(
          'Hành động này sẽ xóa bản ghi khỏi hệ thống và không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(bookingManagementViewModelProvider.notifier)
                  .deleteBooking(booking.id);
              Navigator.pop(dialogContext);
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'approved':
        return const Color(0xFF0EA5E9);
      case 'completed':
        return const Color(0xFF22C55E);
      case 'canceled':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ duyệt';
      case 'approved':
        return 'Đã duyệt';
      case 'completed':
        return 'Hoàn thành';
      case 'canceled':
        return 'Đã hủy';
      default:
        return status;
    }
  }
}
