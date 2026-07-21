import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_paths.dart';
import '../../models/booking_flow_models.dart';
import '../view_models/booking_view_model.dart';
import '../widgets/booking_currency.dart';
import '../widgets/booking_design.dart';

class CheckoutConfirmationView extends ConsumerStatefulWidget {
  const CheckoutConfirmationView({super.key});

  @override
  ConsumerState<CheckoutConfirmationView> createState() =>
      _CheckoutConfirmationViewState();
}

class _CheckoutConfirmationViewState
    extends ConsumerState<CheckoutConfirmationView> {
  final _promoController = TextEditingController();
  bool _isApplyingPromo = false;
  bool _isSubmitting = false;
  bool _acceptedTerms = false;
  bool _showTermsError = false;
  String? _promoMessage;
  bool _promoSucceeded = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _applyPromo() async {
    if (_isApplyingPromo) return;
    setState(() {
      _isApplyingPromo = true;
      _promoMessage = null;
    });
    final result = await ref
        .read(bookingViewModelProvider.notifier)
        .applyPromoCode(_promoController.text);
    if (!mounted) return;
    setState(() {
      _isApplyingPromo = false;
      _promoSucceeded = result.isValid;
      _promoMessage = result.message;
    });
  }

  void _attemptConfirm() {
    if (!_acceptedTerms) {
      setState(() => _showTermsError = true);
      return;
    }
    _onConfirm();
  }

  Future<void> _onConfirm() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    final result = await ref
        .read(bookingViewModelProvider.notifier)
        .submitBooking();
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result.success) {
      context.go(RoutePaths.bookingSuccess, extra: result);
    } else {
      context.push(RoutePaths.bookingFailed, extra: result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingViewModelProvider);

    return Scaffold(
      backgroundColor: BookingDesign.background,
      appBar: const BookingAppBar(title: 'Tóm tắt đơn hàng'),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    children: [
                      _CheckoutTourCard(draft: draft),
                      const SizedBox(height: 24),
                      _PassengerDetailsCard(draft: draft),
                      const SizedBox(height: 24),
                      _PromoCodeCard(
                        controller: _promoController,
                        isLoading: _isApplyingPromo,
                        message: _promoMessage,
                        succeeded: _promoSucceeded,
                        appliedCode: draft.promoCode,
                        onApply: _applyPromo,
                      ),
                      const SizedBox(height: 24),
                      _CheckoutPriceCard(
                        draft: draft,
                        acceptedTerms: _acceptedTerms,
                        showTermsError: _showTermsError,
                        isSubmitting: _isSubmitting,
                        onTermsChanged: (value) {
                          setState(() {
                            _acceptedTerms = value;
                            if (value) _showTermsError = false;
                          });
                        },
                        onConfirm: _attemptConfirm,
                      ),
                      const SizedBox(height: 26),
                      const _TrustIndicators(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isSubmitting) ...[
            const ModalBarrier(dismissible: false, color: Color(0x99020617)),
            const Center(
              child: CircularProgressIndicator(color: BookingDesign.primary),
            ),
          ],
        ],
      ),
      bottomNavigationBar: BookingBottomBar(
        total: draft.totalCost,
        buttonLabel: 'Tiếp tục',
        onPressed: _isSubmitting ? null : _attemptConfirm,
        isLoading: _isSubmitting,
      ),
    );
  }
}

class _CheckoutTourCard extends StatelessWidget {
  const _CheckoutTourCard({required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    final date = draft.travelerInfo.selectedDate;
    final dateText = date == null
        ? 'Chưa chọn ngày khởi hành'
        : '${DateFormat('dd/MM/yyyy').format(date)} • 2 Ngày 1 Đêm';

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: BookingDesign.surface,
          border: Border.all(
            color: BookingDesign.outline.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              bookingTourImage(draft.tourId),
              width: double.infinity,
              height: 238,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF004C6E),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Tour Đặc Sắc',
                          style: TextStyle(
                            color: Color(0xFFC9E6FF),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: BookingDesign.warning,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '4.9 (124 đánh giá)',
                            style: TextStyle(
                              color: BookingDesign.mutedText,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    bookingTourTitle(draft.tourId),
                    style: const TextStyle(
                      color: BookingDesign.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: BookingDesign.mutedText,
                        size: 21,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          dateText,
                          style: const TextStyle(
                            color: BookingDesign.mutedText,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassengerDetailsCard extends StatelessWidget {
  const _PassengerDetailsCard({required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    final traveler = draft.travelerInfo;
    final adultCost = traveler.adultCount * draft.basePrice;
    final childCost = traveler.childCount * draft.basePrice * 0.7;

    return BookingSectionCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi tiết hành khách',
            style: TextStyle(
              color: BookingDesign.text,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Divider(color: BookingDesign.outline.withValues(alpha: 0.4)),
          const SizedBox(height: 18),
          _PassengerPriceRow(
            icon: Icons.person_outline,
            label: 'Người lớn',
            quantity: traveler.adultCount,
            cost: adultCost,
          ),
          if (traveler.childCount > 0) ...[
            const SizedBox(height: 20),
            _PassengerPriceRow(
              icon: Icons.child_care_outlined,
              label: 'Trẻ em',
              quantity: traveler.childCount,
              cost: childCost,
            ),
          ],
        ],
      ),
    );
  }
}

class _PassengerPriceRow extends StatelessWidget {
  const _PassengerPriceRow({
    required this.icon,
    required this.label,
    required this.quantity,
    required this.cost,
  });

  final IconData icon;
  final String label;
  final int quantity;
  final num cost;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: BookingDesign.surfaceContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: BookingDesign.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: BookingDesign.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'x$quantity hành khách',
                style: const TextStyle(color: BookingDesign.mutedText),
              ),
            ],
          ),
        ),
        Text(
          formatBookingCurrency(cost),
          style: const TextStyle(
            color: BookingDesign.text,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PromoCodeCard extends StatelessWidget {
  const _PromoCodeCard({
    required this.controller,
    required this.isLoading,
    required this.message,
    required this.succeeded,
    required this.appliedCode,
    required this.onApply,
  });

  final TextEditingController controller;
  final bool isLoading;
  final String? message;
  final bool succeeded;
  final String? appliedCode;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final displayMessage =
        message ??
        (appliedCode == null
            ? null
            : 'Đã áp dụng mã: ${appliedCode!.toUpperCase()}');
    final success = message == null ? appliedCode != null : succeeded;

    return BookingSectionCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MÃ GIẢM GIÁ',
            style: TextStyle(
              color: BookingDesign.mutedText,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(color: BookingDesign.text),
                  decoration: BookingDesign.fieldDecoration(
                    hintText: 'Nhập mã khuyến mãi',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 116,
                height: 54,
                child: FilledButton(
                  onPressed: isLoading ? null : onApply,
                  style: FilledButton.styleFrom(
                    backgroundColor: BookingDesign.primary,
                    foregroundColor: BookingDesign.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: BookingDesign.onPrimary,
                          ),
                        )
                      : const Text('Áp dụng'),
                ),
              ),
            ],
          ),
          if (displayMessage != null) ...[
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  success ? Icons.check_circle_outline : Icons.error_outline,
                  color: success ? BookingDesign.success : BookingDesign.danger,
                  size: 21,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    displayMessage,
                    style: TextStyle(
                      color: success
                          ? BookingDesign.success
                          : BookingDesign.danger,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CheckoutPriceCard extends StatelessWidget {
  const _CheckoutPriceCard({
    required this.draft,
    required this.acceptedTerms,
    required this.showTermsError,
    required this.isSubmitting,
    required this.onTermsChanged,
    required this.onConfirm,
  });

  final BookingDraft draft;
  final bool acceptedTerms;
  final bool showTermsError;
  final bool isSubmitting;
  final ValueChanged<bool> onTermsChanged;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final traveler = draft.travelerInfo;
    final adultCost = traveler.adultCount * draft.basePrice;
    final childCost = traveler.childCount * draft.basePrice * 0.7;

    return BookingSectionCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi phí tạm tính',
            style: TextStyle(
              color: BookingDesign.text,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 26),
          _CheckoutPriceRow(
            label: 'Người lớn (x${traveler.adultCount})',
            value: adultCost,
          ),
          if (traveler.childCount > 0) ...[
            const SizedBox(height: 17),
            _CheckoutPriceRow(
              label: 'Trẻ em (x${traveler.childCount})',
              value: childCost,
            ),
          ],
          if (draft.discountAmount > 0) ...[
            const SizedBox(height: 17),
            _CheckoutPriceRow(
              label: draft.promoCode == null
                  ? 'Giảm giá'
                  : 'Giảm giá (Mã: ${draft.promoCode})',
              value: -draft.discountAmount,
              color: BookingDesign.success,
            ),
          ],
          const SizedBox(height: 17),
          const _CheckoutPriceRow(label: 'Phí dịch vụ', valueText: 'Miễn phí'),
          const SizedBox(height: 22),
          Divider(color: BookingDesign.outline.withValues(alpha: 0.4)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Text(
                  'Tổng cộng',
                  style: TextStyle(
                    color: BookingDesign.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        formatBookingCurrency(draft.totalCost),
                        style: const TextStyle(
                          color: BookingDesign.primary,
                          fontSize: 31,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Text(
                      'Đã bao gồm thuế & phí',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: BookingDesign.mutedText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: acceptedTerms,
                onChanged: (value) => onTermsChanged(value ?? false),
                activeColor: BookingDesign.primary,
                checkColor: BookingDesign.onPrimary,
                side: BorderSide(
                  color: showTermsError
                      ? BookingDesign.danger
                      : BookingDesign.outline,
                ),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: BookingDesign.mutedText,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: 'Tôi đã đọc và đồng ý với '),
                        TextSpan(
                          text: 'Điều khoản & Điều kiện',
                          style: TextStyle(color: BookingDesign.primary),
                        ),
                        TextSpan(text: ' và '),
                        TextSpan(
                          text: 'Chính sách bảo mật',
                          style: TextStyle(color: BookingDesign.primary),
                        ),
                        TextSpan(text: ' của VietTravel.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (showTermsError)
            const Padding(
              padding: EdgeInsets.only(left: 52, top: 4),
              child: Text(
                'Vui lòng đồng ý với điều khoản để tiếp tục.',
                style: TextStyle(color: BookingDesign.danger, fontSize: 12),
              ),
            ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: BookingPrimaryButton(
              label: 'Tiếp tục thanh toán',
              onPressed: onConfirm,
              isLoading: isSubmitting,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutPriceRow extends StatelessWidget {
  const _CheckoutPriceRow({
    required this.label,
    this.value,
    this.valueText,
    this.color = BookingDesign.mutedText,
  });

  final String label;
  final num? value;
  final String? valueText;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: color, fontSize: 16)),
        ),
        Text(
          valueText ?? formatBookingCurrency(value ?? 0),
          style: TextStyle(color: color, fontSize: 16),
        ),
      ],
    );
  }
}

class _TrustIndicators extends StatelessWidget {
  const _TrustIndicators();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _TrustItem(
            icon: Icons.verified_user_outlined,
            label: 'Bảo mật',
          ),
        ),
        Expanded(
          child: _TrustItem(
            icon: Icons.payments_outlined,
            label: 'Đa phương thức',
          ),
        ),
        Expanded(
          child: _TrustItem(
            icon: Icons.support_agent_outlined,
            label: 'Hỗ trợ 24/7',
          ),
        ),
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: BookingDesign.subtleText, size: 22),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: const TextStyle(color: BookingDesign.subtleText, fontSize: 11),
        ),
      ],
    );
  }
}
