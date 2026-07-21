import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_paths.dart';
import '../../models/booking_flow_models.dart';
import '../view_models/booking_view_model.dart';
import '../widgets/booking_currency.dart';
import '../widgets/booking_design.dart';

class BookingSuccessView extends ConsumerWidget {
  const BookingSuccessView({super.key, required this.result});

  final BookingResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingViewModelProvider);
    final booking = result.booking;
    final tourId = booking?.tourId ?? draft.tourId;
    final bookingDate = booking?.bookingDate ?? draft.travelerInfo.selectedDate;
    final total = booking?.totalCost ?? draft.totalCost;
    final confirmationCode = result.confirmationCode ?? '-';

    return Scaffold(
      backgroundColor: BookingDesign.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 34),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                children: [
                  const _SuccessMark(),
                  const SizedBox(height: 34),
                  const Text(
                    'Đặt tour thành công!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: BookingDesign.text,
                      fontSize: 36,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cảm ơn bạn đã tin tưởng dịch vụ của chúng tôi. Chuyến đi của bạn đã được xác nhận và sẵn sàng.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: BookingDesign.mutedText,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 44),
                  _SuccessOrderCard(
                    confirmationCode: confirmationCode,
                    tourTitle: bookingTourTitle(tourId),
                    bookingDate: bookingDate,
                    adultCount: draft.travelerInfo.adultCount,
                    childCount: draft.travelerInfo.childCount,
                    total: total,
                    onCopy: () =>
                        _copyConfirmationCode(context, confirmationCode),
                  ),
                  const SizedBox(height: 34),
                  const BookingSectionCard(
                    padding: EdgeInsets.all(18),
                    borderColor: Color(0xFF0C4A6E),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: BookingDesign.primary,
                          size: 28,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Thông tin chi tiết chuyến đi và vé điện tử đã được gửi tới email bạn đã đăng ký.',
                            style: TextStyle(
                              color: BookingDesign.mutedText,
                              fontSize: 15,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: BookingPrimaryButton(
                      label: 'Xem chi tiết đơn hàng',
                      onPressed: () {
                        final bookingId = booking?.bookingId;
                        if (bookingId == null) {
                          context.go(RoutePaths.bookings);
                          return;
                        }
                        context.go(
                          RoutePaths.bookingDetailFor(bookingId.toString()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go(RoutePaths.home),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: BookingDesign.text,
                        backgroundColor: const Color(0xFF20272B),
                        side: const BorderSide(color: BookingDesign.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      icon: const Icon(Icons.home_outlined, size: 20),
                      label: const Text('Về trang chủ'),
                    ),
                  ),
                  const SizedBox(height: 58),
                  const Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: BookingDesign.mutedText,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(text: 'Cần hỗ trợ? Liên hệ hotline '),
                        TextSpan(
                          text: '1900 6789',
                          style: TextStyle(
                            color: BookingDesign.primary,
                            fontWeight: FontWeight.w700,
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
      ),
    );
  }

  void _copyConfirmationCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã sao chép mã đơn hàng')));
  }
}

class _SuccessMark extends StatelessWidget {
  const _SuccessMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 142,
      height: 142,
      decoration: const BoxDecoration(
        color: Color(0xFF123D36),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color(0x6622C55E), blurRadius: 32, spreadRadius: 2),
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        width: 90,
        height: 90,
        decoration: const BoxDecoration(
          color: Color(0xFF22C55E),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: BookingDesign.surface,
          size: 54,
          weight: 700,
        ),
      ),
    );
  }
}

class _SuccessOrderCard extends StatelessWidget {
  const _SuccessOrderCard({
    required this.confirmationCode,
    required this.tourTitle,
    required this.bookingDate,
    required this.adultCount,
    required this.childCount,
    required this.total,
    required this.onCopy,
  });

  final String confirmationCode;
  final String tourTitle;
  final DateTime? bookingDate;
  final int adultCount;
  final int childCount;
  final num total;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return BookingSectionCard(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MÃ ĐƠN HÀNG',
                      style: TextStyle(
                        color: BookingDesign.mutedText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: onCopy,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                '#$confirmationCode',
                                style: const TextStyle(
                                  color: BookingDesign.primary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 7),
                            const Icon(
                              Icons.copy_outlined,
                              color: BookingDesign.primary,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFF15803D)),
                ),
                child: const Text(
                  'Đã xác nhận',
                  style: TextStyle(
                    color: BookingDesign.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Divider(color: BookingDesign.outline.withValues(alpha: 0.7)),
          const SizedBox(height: 28),
          _SuccessDetailRow(
            icon: Icons.map_outlined,
            label: 'Tour du lịch',
            value: tourTitle,
          ),
          const SizedBox(height: 24),
          _SuccessDetailRow(
            icon: Icons.calendar_month_outlined,
            label: 'Ngày khởi hành',
            value: bookingDate == null
                ? 'Đang cập nhật'
                : DateFormat('dd/MM/yyyy').format(bookingDate!),
          ),
          const SizedBox(height: 24),
          _SuccessDetailRow(
            icon: Icons.groups_outlined,
            label: 'Số lượng khách',
            value: childCount > 0
                ? '$adultCount Người lớn, $childCount Trẻ em'
                : '$adultCount Người lớn',
          ),
          const SizedBox(height: 24),
          _SuccessDetailRow(
            icon: Icons.payments_outlined,
            label: 'Tổng cộng',
            value: formatBookingCurrency(total),
            valueColor: BookingDesign.primary,
          ),
        ],
      ),
    );
  }
}

class _SuccessDetailRow extends StatelessWidget {
  const _SuccessDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = BookingDesign.text,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            color: Color(0xFF20272B),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: BookingDesign.primary, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: BookingDesign.mutedText,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
