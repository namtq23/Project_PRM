import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../view_models/booking_view_model.dart';
import '../../../../app/router/route_paths.dart';
import '../../models/booking_flow_models.dart';
import '../widgets/booking_currency.dart';

class CheckoutConfirmationView extends ConsumerStatefulWidget {
  const CheckoutConfirmationView({super.key});

  @override
  ConsumerState<CheckoutConfirmationView> createState() =>
      _CheckoutConfirmationViewState();
}

class _CheckoutConfirmationViewState
    extends ConsumerState<CheckoutConfirmationView> {
  final _promoController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
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
      appBar: AppBar(title: const Text('Thanh toán & Xác nhận')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(context, draft),
                const SizedBox(height: 24),
                Text(
                  'Mã giảm giá',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _promoController,
                        decoration: const InputDecoration(
                          hintText: 'Nhập mã (Ví dụ: VIETTRAVEL10)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final res = await ref
                            .read(bookingViewModelProvider.notifier)
                            .applyPromoCode(_promoController.text);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(res.message ?? '')),
                        );
                      },
                      child: const Text('Áp dụng'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildPriceBreakdown(context, draft),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
          if (_isSubmitting) const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _isSubmitting ? null : _onConfirm,
              child: const Text('Xác nhận thanh toán'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, BookingDraft draft) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tóm tắt đơn hàng',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildRow('Tour ID:', '#${draft.tourId}'),
            _buildRow(
              'Ngày đi:',
              draft.travelerInfo.selectedDate != null
                  ? DateFormat(
                      'dd/MM/yyyy',
                    ).format(draft.travelerInfo.selectedDate!)
                  : '-',
            ),
            _buildRow(
              'Khách:',
              '${draft.travelerInfo.adultCount} người lớn, ${draft.travelerInfo.childCount} trẻ em',
            ),
            _buildRow('Liên hệ:', draft.travelerInfo.contactName),
            _buildRow('PTTT:', draft.paymentMethod?.displayName ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown(BuildContext context, BookingDraft draft) {
    return Column(
      children: [
        _buildPriceRow('Tạm tính:', draft.subtotal),
        if (draft.discountAmount > 0)
          _buildPriceRow('Giảm giá:', -draft.discountAmount, isDiscount: true),
        const Divider(thickness: 1),
        _buildPriceRow('TỔNG CỘNG:', draft.totalCost, isTotal: true),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                : null,
          ),
          Text(
            formatBookingCurrency(value),
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
              color: isDiscount
                  ? Colors.green
                  : (isTotal ? Theme.of(context).colorScheme.primary : null),
            ),
          ),
        ],
      ),
    );
  }
}
