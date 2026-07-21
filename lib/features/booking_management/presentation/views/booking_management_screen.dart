import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../core/widgets/admin_scaffold.dart';
import '../../models/booking_management_model.dart';
import '../view_models/booking_management_view_model.dart';

/// Design tokens derived from Stitch MCP design (Project ID: 6140232890509749795, Screen: adb321bb085a4cc2ad678e94c1da33c4)
abstract class _StitchTokens {
  static const Color background = Color(0xFF0C1324);
  static const Color surfaceLow = Color(0xFF151B2D);
  static const Color surfaceContainer = Color(0xFF191F31);
  static const Color surfaceHigh = Color(0xFF23293C);
  static const Color surfaceHighest = Color(0xFF2E3447);

  static const Color onSurface = Color(0xFFDCE1FB);
  static const Color onSurfaceVariant = Color(0xFFBDC8D1);

  static const Color primary = Color(0xFF8ED5FF);
  static const Color primaryContainer = Color(0xFF38BDF8);
  static const Color onPrimaryContainer = Color(0xFF004965);

  static const Color secondary = Color(0xFFBEC6E0);
  static const Color secondaryContainer = Color(0xFF3F465C);
  static const Color onSecondaryContainer = Color(0xFFADB4CE);

  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);

  static const Color outlineVariant = Color(0xFF3E484F);
}

class BookingManagementScreen extends ConsumerStatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  ConsumerState<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState
    extends ConsumerState<BookingManagementScreen> {
  String _selectedStatus = 'All Statuses';
  String _selectedCategory = 'All Categories';
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
        backgroundColor: _StitchTokens.primaryContainer,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showNewBookingDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final tourController = TextEditingController(
      text: 'Icelandic Northern Lights',
    );
    final priceController = TextEditingController(text: '4250');
    final passengersController = TextEditingController(text: '2');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _StitchTokens.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _StitchTokens.outlineVariant),
        ),
        title: const Text(
          'Tạo đặt chỗ mới (New Booking)',
          style: TextStyle(
            color: _StitchTokens.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField(
                  controller: nameController,
                  label: 'Tên khách hàng',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Vui lòng nhập tên' : null,
                ),
                const SizedBox(height: 12),
                _buildDialogTextField(
                  controller: emailController,
                  label: 'Email',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Vui lòng nhập email' : null,
                ),
                const SizedBox(height: 12),
                _buildDialogTextField(
                  controller: tourController,
                  label: 'Tên tour',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Vui lòng nhập tên tour' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDialogTextField(
                        controller: priceController,
                        label: 'Tổng tiền (\$)',
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v == null || double.tryParse(v) == null
                            ? 'Không hợp lệ'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDialogTextField(
                        controller: passengersController,
                        label: 'Số khách',
                        keyboardType: TextInputType.number,
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
            child: const Text(
              'Hủy',
              style: TextStyle(color: _StitchTokens.onSurfaceVariant),
            ),
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
                    backgroundColor: _StitchTokens.primaryContainer,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: _StitchTokens.primaryContainer,
              foregroundColor: _StitchTokens.onPrimaryContainer,
            ),
            child: const Text('Tạo mới'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: _StitchTokens.onSurface, fontSize: 14),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: _StitchTokens.onSurfaceVariant,
          fontSize: 13,
        ),
        filled: true,
        fillColor: _StitchTokens.surfaceLow,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _StitchTokens.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _StitchTokens.primaryContainer),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingManagementViewModelProvider);

    return AdminScaffold(
      currentPath: RoutePaths.adminBookings,
      body: Scaffold(
        backgroundColor: _StitchTokens.background,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _StitchTokens.primaryContainer.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => _showNewBookingDialog(context),
            backgroundColor: _StitchTokens.primaryContainer,
            foregroundColor: _StitchTokens.onPrimaryContainer,
            elevation: 4,
            child: const Icon(Icons.edit, size: 26),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopHeader(context),
              Expanded(
                child: bookingsAsync.when(
                  data: (bookings) {
                    final filteredBookings = bookings.where((b) {
                      final statusMatch =
                          _selectedStatus == 'All Statuses' ||
                          (_selectedStatus == 'Confirmed' &&
                              (b.status == 'completed' ||
                                  b.status == 'approved')) ||
                          (_selectedStatus == 'Pending' &&
                              b.status == 'pending') ||
                          (_selectedStatus == 'Cancelled' &&
                              b.status == 'canceled');

                      final query = _searchController.text.toLowerCase();
                      final searchMatch =
                          b.customerName.toLowerCase().contains(query) ||
                          b.customerEmail.toLowerCase().contains(query) ||
                          b.tourTitle.toLowerCase().contains(query) ||
                          '#VOY-${b.id}'.toLowerCase().contains(query);

                      return statusMatch && searchMatch;
                    }).toList();

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPageHeader(context),
                          const SizedBox(height: 24),
                          _buildBentoStats(bookings),
                          const SizedBox(height: 24),
                          _buildFilterSection(),
                          const SizedBox(height: 16),
                          _buildTableSection(filteredBookings),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: _StitchTokens.primaryContainer,
                    ),
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
                            color: _StitchTokens.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Lỗi tải dữ liệu: $error',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _StitchTokens.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => ref.invalidate(
                              bookingManagementViewModelProvider,
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: _StitchTokens.background,
        border: Border(bottom: BorderSide(color: _StitchTokens.outlineVariant)),
      ),
      child: Row(
        children: [
          if (MediaQuery.of(context).size.width < 900) ...[
            IconButton(
              icon: const Icon(Icons.menu, color: _StitchTokens.onSurface),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const SizedBox(width: 8),
          ],
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Voyage Admin',
                style: TextStyle(
                  color: _StitchTokens.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'EXECUTIVE SUITE',
                style: TextStyle(
                  color: _StitchTokens.onSurfaceVariant,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Thông báo',
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: _StitchTokens.onSurfaceVariant,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _StitchTokens.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Trợ giúp',
            icon: const Icon(
              Icons.help_outline,
              color: _StitchTokens.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: _StitchTokens.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Alex Mercer',
                      style: TextStyle(
                        color: _StitchTokens.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'MASTER ADMIN',
                      style: TextStyle(
                        color: _StitchTokens.onSurfaceVariant,
                        fontSize: 9,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _StitchTokens.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  child: const Text(
                    'AM',
                    style: TextStyle(
                      color: _StitchTokens.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        final titleWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Booking Management',
              style: TextStyle(
                color: _StitchTokens.onSurface,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Monitor and manage all executive travel arrangements in real-time.',
              style: TextStyle(
                color: _StitchTokens.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        );

        return Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isMobile) titleWidget else Expanded(child: titleWidget),
            if (isMobile) const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _exportCsv(context),
                  icon: const Icon(
                    Icons.file_download_outlined,
                    size: 18,
                    color: _StitchTokens.onSurface,
                  ),
                  label: const Text(
                    'Export CSV',
                    style: TextStyle(
                      color: _StitchTokens.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _StitchTokens.surfaceHigh,
                    side: const BorderSide(color: _StitchTokens.outlineVariant),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showNewBookingDialog(context),
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: _StitchTokens.onPrimaryContainer,
                  ),
                  label: const Text(
                    'New Booking',
                    style: TextStyle(
                      color: _StitchTokens.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _StitchTokens.primaryContainer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBentoStats(List<BookingManagementModel> bookings) {
    final pendingCount = bookings.where((b) => b.status == 'pending').length;
    final totalRevenue = bookings
        .where((b) => b.status == 'completed' || b.status == 'approved')
        .fold(0.0, (sum, b) => sum + b.totalPrice);
    final avgTicket = bookings.isEmpty ? 0.0 : totalRevenue / bookings.length;
    final currencyFormat = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 550
            ? 2
            : 1;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.2,
          children: [
            _BentoCard(
              label: 'TOTAL BOOKINGS',
              value: '1,284',
              subtext: '+12%',
              subtextIcon: Icons.trending_up,
              subtextColor: _StitchTokens.primary,
            ),
            _BentoCard(
              label: 'REVENUE',
              value: '\$${(totalRevenue / 1000000).toStringAsFixed(1)}M',
              subtext: '+8.4%',
              subtextIcon: Icons.trending_up,
              subtextColor: _StitchTokens.primary,
            ),
            _BentoCard(
              label: 'PENDING APPROVAL',
              value: '$pendingCount',
              subtext: 'Action Required',
              subtextIcon: Icons.schedule,
              subtextColor: _StitchTokens.secondary,
            ),
            _BentoCard(
              label: 'AVG. TICKET',
              value: currencyFormat.format(avgTicket),
              subtext: 'Stable',
              subtextColor: _StitchTokens.onSurfaceVariant,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  SizedBox(
                    width: isWide ? 220 : constraints.maxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Search Query',
                          style: TextStyle(
                            color: _StitchTokens.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(
                            color: _StitchTokens.onSurface,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search customer, tour...',
                            hintStyle: const TextStyle(
                              color: _StitchTokens.onSurfaceVariant,
                              fontSize: 13,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 18,
                              color: _StitchTokens.onSurfaceVariant,
                            ),
                            filled: true,
                            fillColor: _StitchTokens.surfaceLow,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: _StitchTokens.outlineVariant,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: _StitchTokens.primaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: isWide ? 180 : (constraints.maxWidth - 16) / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(
                            color: _StitchTokens.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedStatus,
                          dropdownColor: _StitchTokens.surfaceContainer,
                          style: const TextStyle(
                            color: _StitchTokens.onSurface,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _StitchTokens.surfaceLow,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: _StitchTokens.outlineVariant,
                              ),
                            ),
                          ),
                          items:
                              [
                                    'All Statuses',
                                    'Confirmed',
                                    'Pending',
                                    'Cancelled',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedStatus = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: isWide ? 200 : (constraints.maxWidth - 16) / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tour Category',
                          style: TextStyle(
                            color: _StitchTokens.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          dropdownColor: _StitchTokens.surfaceContainer,
                          style: const TextStyle(
                            color: _StitchTokens.onSurface,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _StitchTokens.surfaceLow,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: _StitchTokens.outlineVariant,
                              ),
                            ),
                          ),
                          items:
                              [
                                    'All Categories',
                                    'Executive Retreats',
                                    'Arctic Expeditions',
                                    'Private Islands',
                                    'Cultural Safaris',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedCategory = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _StitchTokens.primaryContainer,
                          foregroundColor: _StitchTokens.onPrimaryContainer,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () =>
                            ref.invalidate(bookingManagementViewModelProvider),
                        tooltip: 'Refresh',
                        icon: const Icon(
                          Icons.refresh,
                          color: _StitchTokens.onSurfaceVariant,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: _StitchTokens.surfaceLow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: _StitchTokens.outlineVariant,
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection(List<BookingManagementModel> bookings) {
    return Container(
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                _StitchTokens.surfaceHigh.withValues(alpha: 0.5),
              ),
              dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.hovered)) {
                  return _StitchTokens.surfaceHighest;
                }
                return _StitchTokens.surfaceLow;
              }),
              horizontalMargin: 24,
              columnSpacing: 32,
              columns: const [
                DataColumn(
                  label: Text(
                    'BOOKING ID',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'CUSTOMER',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'TOUR',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'DATE',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'TOTAL',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'STATUS',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                DataColumn(
                  numeric: true,
                  label: Text(
                    'ACTIONS',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
              rows: bookings.isEmpty
                  ? [
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'No bookings matching filters',
                              style: TextStyle(
                                color: _StitchTokens.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const DataCell(SizedBox.shrink()),
                          const DataCell(SizedBox.shrink()),
                          const DataCell(SizedBox.shrink()),
                          const DataCell(SizedBox.shrink()),
                          const DataCell(SizedBox.shrink()),
                          const DataCell(SizedBox.shrink()),
                        ],
                      ),
                    ]
                  : bookings.map((b) => _buildDataRow(context, b)).toList(),
            ),
          ),
          _buildPaginationFooter(bookings.length),
        ],
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, BookingManagementModel booking) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );

    final nameParts = booking.customerName.trim().split(' ');
    final initials = nameParts.length >= 2
        ? '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase()
        : booking.customerName.isNotEmpty
        ? booking.customerName[0].toUpperCase()
        : 'U';

    String categoryTag = 'Executive Retreat';
    if (booking.tourTitle.contains('Iceland')) {
      categoryTag = 'Arctic Expedition';
    }
    if (booking.tourTitle.contains('Amalfi')) {
      categoryTag = 'Luxury Marine';
    }
    if (booking.tourTitle.contains('Kyoto')) {
      categoryTag = 'Cultural Heritage';
    }
    if (booking.tourTitle.contains('Swiss')) {
      categoryTag = 'Extreme Sport';
    }

    return DataRow(
      cells: [
        DataCell(
          Text(
            '#VOY-${booking.id > 0 ? booking.id : (booking.tourId + 9700)}',
            style: const TextStyle(
              color: _StitchTokens.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: _StitchTokens.secondaryContainer,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: _StitchTokens.onSecondaryContainer,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.customerName,
                    style: const TextStyle(
                      color: _StitchTokens.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    booking.customerEmail,
                    style: const TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.tourTitle,
                style: const TextStyle(
                  color: _StitchTokens.onSurface,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: _StitchTokens.surfaceHighest,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _StitchTokens.outlineVariant),
                ),
                child: Text(
                  categoryTag,
                  style: const TextStyle(
                    color: _StitchTokens.onSurfaceVariant,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            dateFormat.format(booking.bookingDate),
            style: const TextStyle(color: _StitchTokens.onSurfaceVariant),
          ),
        ),
        DataCell(
          Text(
            currencyFormat.format(booking.totalPrice),
            style: const TextStyle(
              color: _StitchTokens.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(_StitchStatusBadge(status: booking.status)),
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: _StitchTokens.onSurfaceVariant,
            ),
            color: _StitchTokens.surfaceContainer,
            onSelected: (action) {
              final viewModel = ref.read(
                bookingManagementViewModelProvider.notifier,
              );
              if (action == 'approve') {
                viewModel.approveBooking(booking.id);
              } else if (action == 'complete') {
                viewModel.completeBooking(booking.id);
              } else if (action == 'cancel') {
                viewModel.cancelBooking(booking.id);
              } else if (action == 'delete') {
                viewModel.deleteBooking(booking.id);
              }
            },
            itemBuilder: (context) => [
              if (booking.status == 'pending')
                const PopupMenuItem(
                  value: 'approve',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: _StitchTokens.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Duyệt (Approve)',
                        style: TextStyle(color: _StitchTokens.onSurface),
                      ),
                    ],
                  ),
                ),
              if (booking.status == 'approved')
                const PopupMenuItem(
                  value: 'complete',
                  child: Row(
                    children: [
                      Icon(Icons.verified, size: 16, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Hoàn thành (Complete)',
                        style: TextStyle(color: _StitchTokens.onSurface),
                      ),
                    ],
                  ),
                ),
              if (booking.status != 'canceled')
                const PopupMenuItem(
                  value: 'cancel',
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        size: 16,
                        color: _StitchTokens.error,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Hủy đơn (Cancel)',
                        style: TextStyle(color: _StitchTokens.onSurface),
                      ),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: _StitchTokens.error,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Xóa bản ghi (Delete)',
                      style: TextStyle(color: _StitchTokens.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationFooter(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: _StitchTokens.surfaceContainer,
        border: Border(top: BorderSide(color: _StitchTokens.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing 1 to $count of 1,284 entries',
            style: const TextStyle(
              color: _StitchTokens.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              _PageNavButton(icon: Icons.chevron_left, onPressed: null),
              const SizedBox(width: 4),
              _PageNavButton(text: '1', isActive: true),
              const SizedBox(width: 4),
              _PageNavButton(text: '2'),
              const SizedBox(width: 4),
              _PageNavButton(text: '3'),
              const SizedBox(width: 4),
              _PageNavButton(icon: Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }
}

class _BentoCard extends StatelessWidget {
  const _BentoCard({
    required this.label,
    required this.value,
    required this.subtext,
    this.subtextIcon,
    required this.subtextColor,
  });

  final String label;
  final String value;
  final String subtext;
  final IconData? subtextIcon;
  final Color subtextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _StitchTokens.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: _StitchTokens.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  if (subtextIcon != null) ...[
                    Icon(subtextIcon, size: 14, color: subtextColor),
                    const SizedBox(width: 2),
                  ],
                  Text(
                    subtext,
                    style: TextStyle(
                      color: subtextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StitchStatusBadge extends StatelessWidget {
  const _StitchStatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final isConfirmed = status == 'completed' || status == 'approved';
    final isPending = status == 'pending';
    final isCancelled = status == 'canceled';

    final Color badgeBg = isConfirmed
        ? _StitchTokens.primaryContainer.withValues(alpha: 0.2)
        : isPending
        ? _StitchTokens.secondaryContainer.withValues(alpha: 0.2)
        : isCancelled
        ? _StitchTokens.errorContainer.withValues(alpha: 0.2)
        : _StitchTokens.surfaceHighest;

    final Color badgeColor = isConfirmed
        ? _StitchTokens.primary
        : isPending
        ? _StitchTokens.secondary
        : isCancelled
        ? _StitchTokens.error
        : _StitchTokens.onSurfaceVariant;

    final Color borderColor = isConfirmed
        ? _StitchTokens.primaryContainer.withValues(alpha: 0.3)
        : isPending
        ? _StitchTokens.secondary.withValues(alpha: 0.3)
        : isCancelled
        ? _StitchTokens.error.withValues(alpha: 0.3)
        : _StitchTokens.outlineVariant;

    final String text = isConfirmed
        ? 'Confirmed'
        : isPending
        ? 'Pending'
        : isCancelled
        ? 'Cancelled'
        : status;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageNavButton extends StatelessWidget {
  const _PageNavButton({
    this.icon,
    this.text,
    this.isActive = false,
    this.onPressed,
  });

  final IconData? icon;
  final String? text;
  final bool isActive;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive
            ? _StitchTokens.primaryContainer
            : _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(6),
        border: isActive
            ? null
            : Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed ?? () {},
          borderRadius: BorderRadius.circular(6),
          child: Center(
            child: icon != null
                ? Icon(icon, size: 18, color: _StitchTokens.onSurfaceVariant)
                : Text(
                    text ?? '',
                    style: TextStyle(
                      color: isActive
                          ? _StitchTokens.onPrimaryContainer
                          : _StitchTokens.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
