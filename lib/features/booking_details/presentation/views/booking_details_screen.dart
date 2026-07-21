import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/admin_booking_detail_model.dart';
import '../view_models/booking_details_view_model.dart';

/// Design tokens derived from Stitch MCP design (Project ID: 6140232890509749795, Screen: f2d280fdea84434185ef415d6d307d8b)
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
  static const Color onPrimary = Color(0xFF00354A);

  static const Color secondaryContainer = Color(0xFF3F465C);
  static const Color onSecondaryContainer = Color(0xFFADB4CE);

  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  static const Color outlineVariant = Color(0xFF3E484F);
}

class BookingDetailsScreen extends ConsumerWidget {
  const BookingDetailsScreen({required this.bookingId, super.key});

  final int bookingId;

  void _showCancelConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _StitchTokens.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _StitchTokens.outlineVariant),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: _StitchTokens.error,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              'Hủy Đặt Chỗ (Cancel Booking)',
              style: TextStyle(
                color: _StitchTokens.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Bạn có chắc chắn muốn hủy đơn đặt chỗ này không? Hành động này sẽ cập nhật trạng thái đơn hàng thành Canceled.',
          style: TextStyle(color: _StitchTokens.onSurfaceVariant, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Không, quay lại',
              style: TextStyle(color: _StitchTokens.onSurfaceVariant),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref
                  .read(bookingDetailsViewModelProvider(bookingId).notifier)
                  .cancelBooking();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã hủy đơn đặt chỗ thành công!'),
                  backgroundColor: _StitchTokens.errorContainer,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: _StitchTokens.errorContainer,
              foregroundColor: _StitchTokens.onErrorContainer,
            ),
            child: const Text('Xác nhận Hủy'),
          ),
        ],
      ),
    );
  }

  void _sendETicket(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã gửi vé điện tử (E-ticket) đến email khách hàng!'),
        backgroundColor: _StitchTokens.primaryContainer,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _editItinerary(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Tính năng chỉnh sửa lịch trình (Edit Itinerary) đang mở...',
        ),
        backgroundColor: _StitchTokens.primaryContainer,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(bookingDetailsViewModelProvider(bookingId));

    return Scaffold(
      backgroundColor: _StitchTokens.background,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'export_btn',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã xuất thông tin đơn hàng!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            backgroundColor: _StitchTokens.surfaceHigh,
            foregroundColor: _StitchTokens.onSurface,
            child: const Icon(Icons.print_outlined),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'share_btn',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã chia sẻ thông tin đặt chỗ!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            backgroundColor: _StitchTokens.primaryContainer,
            foregroundColor: _StitchTokens.onPrimaryContainer,
            child: const Icon(Icons.share),
          ),
        ],
      ),
      body: SafeArea(
        child: detailAsync.when(
          data: (detail) {
            if (detail == null) {
              return const Center(
                child: Text(
                  'Không tìm thấy thông tin chi tiết đơn đặt chỗ',
                  style: TextStyle(color: _StitchTokens.onSurfaceVariant),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderAndBreadcrumbs(context, ref, detail),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 900;
                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                children: [
                                  _buildTourSummaryCard(detail),
                                  const SizedBox(height: 24),
                                  _buildItinerarySummaryCard(context, detail),
                                  const SizedBox(height: 24),
                                  _buildTravelersListCard(detail),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  _buildCustomerContactCard(detail),
                                  const SizedBox(height: 24),
                                  _buildPaymentSummaryCard(detail),
                                  const SizedBox(height: 24),
                                  _buildActivityTimelineCard(detail),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          _buildTourSummaryCard(detail),
                          const SizedBox(height: 24),
                          _buildCustomerContactCard(detail),
                          const SizedBox(height: 24),
                          _buildItinerarySummaryCard(context, detail),
                          const SizedBox(height: 24),
                          _buildPaymentSummaryCard(detail),
                          const SizedBox(height: 24),
                          _buildTravelersListCard(detail),
                          const SizedBox(height: 24),
                          _buildActivityTimelineCard(detail),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: _StitchTokens.primaryContainer,
            ),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: _StitchTokens.error,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'Lỗi tải chi tiết đơn hàng: $error',
                  style: const TextStyle(color: _StitchTokens.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(
                    bookingDetailsViewModelProvider(bookingId),
                  ),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderAndBreadcrumbs(
    BuildContext context,
    WidgetRef ref,
    AdminBookingDetailModel detail,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final titleSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Bookings',
                  style: TextStyle(
                    color: _StitchTokens.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: _StitchTokens.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  detail.bookingCode,
                  style: const TextStyle(
                    color: _StitchTokens.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Booking Details',
              style: TextStyle(
                color: _StitchTokens.onSurface,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        );

        final actionButtons = Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () => _showCancelConfirmationDialog(context, ref),
              icon: const Icon(Icons.cancel_outlined, size: 16),
              label: const Text('Cancel Booking'),
              style: OutlinedButton.styleFrom(
                backgroundColor: _StitchTokens.surfaceHighest,
                foregroundColor: _StitchTokens.onSurface,
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
            OutlinedButton.icon(
              onPressed: () => _sendETicket(context),
              icon: const Icon(Icons.send_outlined, size: 16),
              label: const Text('Send E-ticket'),
              style: OutlinedButton.styleFrom(
                backgroundColor: _StitchTokens.surfaceHighest,
                foregroundColor: _StitchTokens.onSurface,
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
            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(bookingDetailsViewModelProvider(bookingId).notifier)
                    .confirmPayment();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xác nhận thanh toán (Confirm Payment)!'),
                    backgroundColor: _StitchTokens.primaryContainer,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.check_circle, size: 16),
              label: const Text('Confirm Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _StitchTokens.primary,
                foregroundColor: _StitchTokens.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [titleSection, const SizedBox(height: 16), actionButtons],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [titleSection, actionButtons],
        );
      },
    );
  }

  Widget _buildTourSummaryCard(AdminBookingDetailModel detail) {
    final dateFormat = DateFormat('MMM dd');
    final dateRangeStr =
        '${dateFormat.format(detail.startDate)} - ${dateFormat.format(detail.endDate)}, ${detail.startDate.year}';

    final isConfirmed =
        detail.status == 'confirmed' || detail.status == 'completed';
    final badgeBg = isConfirmed
        ? _StitchTokens.primary
        : detail.status == 'canceled'
        ? _StitchTokens.errorContainer
        : _StitchTokens.secondaryContainer;
    final badgeColor = isConfirmed
        ? _StitchTokens.onPrimary
        : detail.status == 'canceled'
        ? _StitchTokens.onErrorContainer
        : _StitchTokens.onSecondaryContainer;

    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _StitchTokens.outlineVariant),
        image: DecorationImage(
          image: NetworkImage(detail.tourImageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black45,
              _StitchTokens.background,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                detail.status.toUpperCase(),
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              detail.tourTitle,
              style: const TextStyle(
                color: _StitchTokens.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: _StitchTokens.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  dateRangeStr,
                  style: const TextStyle(
                    color: _StitchTokens.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 24),
                const Icon(
                  Icons.person,
                  size: 16,
                  color: _StitchTokens.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${detail.travelerCount} Travelers',
                  style: const TextStyle(
                    color: _StitchTokens.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItinerarySummaryCard(
    BuildContext context,
    AdminBookingDetailModel detail,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Itinerary Summary',
                style: TextStyle(
                  color: _StitchTokens.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => _editItinerary(context),
                child: const Text(
                  'Edit Itinerary',
                  style: TextStyle(
                    color: _StitchTokens.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...detail.itinerary.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _StitchTokens.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _StitchTokens.outlineVariant),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _StitchTokens.surfaceHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getItineraryIcon(item.iconName),
                        color: _StitchTokens.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: _StitchTokens.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                              color: _StitchTokens.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getItineraryIcon(String iconName) {
    switch (iconName) {
      case 'flight_takeoff':
        return Icons.flight_takeoff;
      case 'hotel':
        return Icons.hotel;
      case 'directions_car':
        return Icons.directions_car;
      default:
        return Icons.event;
    }
  }

  Widget _buildTravelersListCard(AdminBookingDetailModel detail) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'List of Travelers',
            style: TextStyle(
              color: _StitchTokens.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.transparent),
              dataRowColor: WidgetStateProperty.all(
                _StitchTokens.surfaceContainer,
              ),
              horizontalMargin: 12,
              columnSpacing: 24,
              columns: const [
                DataColumn(
                  label: Text(
                    'NAME',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'DOCUMENT',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'PREFERENCES',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
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
                    ),
                  ),
                ),
              ],
              rows: detail.travelers
                  .map(
                    (traveler) => DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: traveler.isLead
                                    ? _StitchTokens.primaryContainer
                                    : _StitchTokens.secondaryContainer,
                                child: Text(
                                  traveler.initials,
                                  style: TextStyle(
                                    color: traveler.isLead
                                        ? _StitchTokens.onPrimaryContainer
                                        : _StitchTokens.onSecondaryContainer,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                traveler.name,
                                style: const TextStyle(
                                  color: _StitchTokens.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              if (traveler.isLead) ...[
                                const SizedBox(width: 8),
                                const Text(
                                  'LEAD',
                                  style: TextStyle(
                                    color: _StitchTokens.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            traveler.documentId,
                            style: const TextStyle(
                              color: _StitchTokens.onSurfaceVariant,
                              fontFamily: 'monospace',
                              fontSize: 13,
                            ),
                          ),
                        ),
                        DataCell(
                          Wrap(
                            spacing: 4,
                            children: traveler.preferences
                                .map(
                                  (pref) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _StitchTokens.surfaceHighest,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      pref,
                                      style: const TextStyle(
                                        color: _StitchTokens.onSurfaceVariant,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: _StitchTokens.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                traveler.status,
                                style: const TextStyle(
                                  color: _StitchTokens.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerContactCard(AdminBookingDetailModel detail) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CUSTOMER CONTACT',
            style: TextStyle(
              color: _StitchTokens.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactRow(
            icon: Icons.mail_outline,
            label: 'Primary Email',
            value: detail.customerEmail,
          ),
          const SizedBox(height: 16),
          _buildContactRow(
            icon: Icons.phone_outlined,
            label: 'Mobile Number',
            value: detail.customerPhone,
          ),
          const SizedBox(height: 16),
          _buildContactRow(
            icon: Icons.pin_drop_outlined,
            label: 'Billing Address',
            value: detail.billingAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _StitchTokens.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _StitchTokens.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: _StitchTokens.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummaryCard(AdminBookingDetailModel detail) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAYMENT SUMMARY',
            style: TextStyle(
              color: _StitchTokens.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  color: _StitchTokens.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              Text(
                currencyFormat.format(detail.subtotal),
                style: const TextStyle(
                  color: _StitchTokens.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Luxury Surcharge',
                style: TextStyle(
                  color: _StitchTokens.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              Text(
                currencyFormat.format(detail.luxurySurcharge),
                style: const TextStyle(
                  color: _StitchTokens.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: _StitchTokens.outlineVariant),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: _StitchTokens.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                currencyFormat.format(detail.totalPrice),
                style: const TextStyle(
                  color: _StitchTokens.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'HISTORY',
            style: TextStyle(
              color: _StitchTokens.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _StitchTokens.surfaceHigh,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Deposit Paid',
                      style: TextStyle(
                        color: _StitchTokens.onSurface,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  currencyFormat.format(detail.depositPaid),
                  style: const TextStyle(
                    color: _StitchTokens.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _StitchTokens.surfaceHigh,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _StitchTokens.primaryContainer.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: _StitchTokens.primary,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Balance Due',
                      style: TextStyle(
                        color: _StitchTokens.onSurface,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  currencyFormat.format(detail.balanceDue),
                  style: const TextStyle(
                    color: _StitchTokens.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTimelineCard(AdminBookingDetailModel detail) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACTIVITY TIMELINE',
            style: TextStyle(
              color: _StitchTokens.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: detail.timeline.length,
            itemBuilder: (context, index) {
              final item = detail.timeline[index];
              final isLast = index == detail.timeline.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.isPrimary
                                ? _StitchTokens.primary
                                : _StitchTokens.outlineVariant,
                            boxShadow: item.isPrimary
                                ? [
                                    BoxShadow(
                                      color: _StitchTokens.primary.withValues(
                                        alpha: 0.6,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: _StitchTokens.outlineVariant,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: _StitchTokens.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.timestamp,
                              style: const TextStyle(
                                color: _StitchTokens.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                            if (item.note != null) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _StitchTokens.surfaceHighest,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.note!,
                                  style: const TextStyle(
                                    color: _StitchTokens.onSurfaceVariant,
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
