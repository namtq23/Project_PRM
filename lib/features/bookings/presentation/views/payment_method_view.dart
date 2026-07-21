import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_paths.dart';
import '../../models/booking_flow_models.dart';
import '../view_models/booking_view_model.dart';
import '../widgets/booking_currency.dart';
import '../widgets/booking_design.dart';

class PaymentMethodView extends ConsumerStatefulWidget {
  const PaymentMethodView({super.key});

  @override
  ConsumerState<PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends ConsumerState<PaymentMethodView> {
  bool _acceptedTerms = true;

  @override
  void initState() {
    super.initState();
    if (ref.read(bookingViewModelProvider).paymentMethod == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(bookingViewModelProvider.notifier)
            .updatePaymentMethod(PaymentMethodType.creditCard);
      });
    }
  }

  void _selectMethod(PaymentMethodType method) {
    ref.read(bookingViewModelProvider.notifier).updatePaymentMethod(method);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingViewModelProvider);
    final selectedMethod = draft.paymentMethod ?? PaymentMethodType.creditCard;

    return Scaffold(
      backgroundColor: BookingDesign.background,
      appBar: const BookingAppBar(title: 'Thanh toán'),
      body: RadioGroup<PaymentMethodType>(
        groupValue: selectedMethod,
        onChanged: (value) {
          if (value != null) _selectMethod(value);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 30),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chọn phương thức thanh toán',
                      style: TextStyle(
                        color: BookingDesign.text,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'An toàn, bảo mật và hoàn toàn miễn phí giao dịch.',
                      style: TextStyle(
                        color: BookingDesign.mutedText,
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _PaymentOptionCard(
                      method: PaymentMethodType.creditCard,
                      icon: Icons.credit_card,
                      title: 'Thẻ tín dụng / Ghi nợ',
                      subtitle: 'Visa, Mastercard, JCB, American Express',
                      isSelected:
                          selectedMethod == PaymentMethodType.creditCard,
                      trailing: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PaymentBadge(label: 'VISA'),
                          SizedBox(width: 7),
                          _PaymentBadge(label: '●●'),
                        ],
                      ),
                      onTap: () => _selectMethod(PaymentMethodType.creditCard),
                      expandedChild: const _CreditCardFields(),
                    ),
                    const SizedBox(height: 14),
                    _PaymentOptionCard(
                      method: PaymentMethodType.eWallet,
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Ví điện tử',
                      subtitle: 'MoMo, ZaloPay, ShopeePay',
                      isSelected: selectedMethod == PaymentMethodType.eWallet,
                      trailing: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _RoundPaymentBadge(label: 'QR'),
                          SizedBox(width: 7),
                          _RoundPaymentBadge(label: 'M'),
                        ],
                      ),
                      onTap: () => _selectMethod(PaymentMethodType.eWallet),
                    ),
                    const SizedBox(height: 14),
                    _PaymentOptionCard(
                      method: PaymentMethodType.bankTransfer,
                      icon: Icons.account_balance_outlined,
                      title: 'Chuyển khoản ngân hàng',
                      subtitle: 'Vietcombank, Techcombank, BIDV...',
                      isSelected:
                          selectedMethod == PaymentMethodType.bankTransfer,
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: BookingDesign.mutedText,
                      ),
                      onTap: () =>
                          _selectMethod(PaymentMethodType.bankTransfer),
                    ),
                    const SizedBox(height: 24),
                    const BookingSectionCard(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            color: BookingDesign.primary,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Giao dịch được bảo mật tuyệt đối',
                                  style: TextStyle(
                                    color: BookingDesign.text,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Thông tin thanh toán của bạn được mã hóa theo tiêu chuẩn PCI DSS toàn cầu.',
                                  style: TextStyle(
                                    color: BookingDesign.mutedText,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _TripInformationCard(
                      draft: draft,
                      acceptedTerms: _acceptedTerms,
                      onTermsChanged: (value) {
                        setState(() => _acceptedTerms = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BookingBottomBar(
        total: draft.totalCost,
        buttonLabel: 'Xác nhận',
        onPressed: draft.paymentMethod != null && _acceptedTerms
            ? () => context.push(RoutePaths.bookingCheckout)
            : null,
      ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  const _PaymentOptionCard({
    required this.method,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.trailing,
    required this.onTap,
    this.expandedChild,
  });

  final PaymentMethodType method;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final Widget trailing;
  final VoidCallback onTap;
  final Widget? expandedChild;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: BookingDesign.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? BookingDesign.primary : BookingDesign.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: BookingDesign.surfaceContainer,
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
                          title,
                          style: const TextStyle(
                            color: BookingDesign.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: BookingDesign.mutedText,
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  trailing,
                  const SizedBox(width: 4),
                  Radio<PaymentMethodType>(
                    value: method,
                    activeColor: BookingDesign.primary,
                  ),
                ],
              ),
              if (isSelected && expandedChild != null) ...[
                const SizedBox(height: 20),
                Divider(color: BookingDesign.outline.withValues(alpha: 0.45)),
                const SizedBox(height: 18),
                expandedChild!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CreditCardFields extends StatelessWidget {
  const _CreditCardFields();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _PaymentFieldLabel(label: 'Số thẻ'),
        const SizedBox(height: 7),
        TextField(
          keyboardType: TextInputType.number,
          style: const TextStyle(color: BookingDesign.text),
          decoration: BookingDesign.fieldDecoration(
            hintText: '0000 0000 0000 0000',
            suffixIcon: const Icon(
              Icons.lock_outline,
              color: BookingDesign.mutedText,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PaymentFieldLabel(label: 'Ngày hết hạn'),
                  SizedBox(height: 7),
                  TextField(
                    keyboardType: TextInputType.datetime,
                    style: TextStyle(color: BookingDesign.text),
                    decoration: InputDecoration(
                      hintText: 'MM/YY',
                      hintStyle: TextStyle(color: BookingDesign.subtleText),
                      filled: true,
                      fillColor: Color(0xFF20272B),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(color: BookingDesign.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(color: BookingDesign.outline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PaymentFieldLabel(label: 'CVV / CVC'),
                  SizedBox(height: 7),
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: BookingDesign.text),
                    decoration: InputDecoration(
                      hintText: '***',
                      hintStyle: TextStyle(color: BookingDesign.subtleText),
                      filled: true,
                      fillColor: Color(0xFF20272B),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(color: BookingDesign.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(color: BookingDesign.outline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PaymentFieldLabel extends StatelessWidget {
  const _PaymentFieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: BookingDesign.text,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  const _PaymentBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF172554),
          fontSize: 7,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _RoundPaymentBadge extends StatelessWidget {
  const _RoundPaymentBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFE2E8F0),
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF111827),
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TripInformationCard extends StatelessWidget {
  const _TripInformationCard({
    required this.draft,
    required this.acceptedTerms,
    required this.onTermsChanged,
  });

  final BookingDraft draft;
  final bool acceptedTerms;
  final ValueChanged<bool> onTermsChanged;

  @override
  Widget build(BuildContext context) {
    final traveler = draft.travelerInfo;
    final date = traveler.selectedDate;
    final dateText = date == null
        ? 'Chưa chọn ngày khởi hành'
        : '${DateFormat('dd/MM/yyyy').format(date)} - ${DateFormat('dd/MM/yyyy').format(date.add(const Duration(days: 1)))}';

    return BookingSectionCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin chuyến đi',
            style: TextStyle(
              color: BookingDesign.text,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  bookingTourImage(draft.tourId),
                  width: 94,
                  height: 94,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookingTourTitle(draft.tourId),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: BookingDesign.text,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: BookingDesign.mutedText,
                          size: 17,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            dateText,
                            style: const TextStyle(
                              color: BookingDesign.mutedText,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${traveler.adultCount + traveler.childCount} hành khách',
                      style: const TextStyle(
                        color: BookingDesign.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Divider(color: BookingDesign.outline.withValues(alpha: 0.5)),
          const SizedBox(height: 14),
          _TripPriceRow(label: 'Giá tour', value: draft.subtotal),
          const SizedBox(height: 12),
          const _TripPriceRow(
            label: 'Phí dịch vụ (0%)',
            valueText: 'Miễn phí',
            valueColor: BookingDesign.success,
          ),
          if (draft.discountAmount > 0) ...[
            const SizedBox(height: 12),
            _TripPriceRow(
              label: 'Giảm giá',
              value: -draft.discountAmount,
              valueColor: BookingDesign.danger,
            ),
          ],
          const SizedBox(height: 18),
          Divider(color: BookingDesign.outline.withValues(alpha: 0.5)),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Text(
                  'Tổng cộng',
                  style: TextStyle(
                    color: BookingDesign.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatBookingCurrency(draft.totalCost),
                    style: const TextStyle(
                      color: BookingDesign.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    '* Đã bao gồm VAT',
                    style: TextStyle(
                      color: BookingDesign.mutedText,
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: acceptedTerms,
                onChanged: (value) => onTermsChanged(value ?? false),
                activeColor: BookingDesign.primary,
                checkColor: BookingDesign.onPrimary,
                side: const BorderSide(color: BookingDesign.outline),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: BookingDesign.mutedText,
                        fontSize: 13,
                        height: 1.45,
                      ),
                      children: [
                        TextSpan(text: 'Tôi đồng ý với '),
                        TextSpan(
                          text: 'Điều khoản dịch vụ',
                          style: TextStyle(color: BookingDesign.primary),
                        ),
                        TextSpan(text: ' và '),
                        TextSpan(
                          text: 'Chính sách bảo mật.',
                          style: TextStyle(color: BookingDesign.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TripPriceRow extends StatelessWidget {
  const _TripPriceRow({
    required this.label,
    this.value,
    this.valueText,
    this.valueColor = BookingDesign.text,
  });

  final String label;
  final num? value;
  final String? valueText;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: BookingDesign.mutedText),
          ),
        ),
        Text(
          valueText ?? formatBookingCurrency(value ?? 0),
          style: TextStyle(color: valueColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
