import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../models/booking_flow_models.dart';
import '../view_models/booking_view_model.dart';
import '../widgets/booking_currency.dart';

class PaymentMethodView extends ConsumerWidget {
  const PaymentMethodView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingViewModelProvider);
    final selectedMethod = draft.paymentMethod;

    return Scaffold(
      appBar: AppBar(title: const Text('Phương thức thanh toán')),
      body: Column(
        children: [
          Expanded(
            child: RadioGroup<PaymentMethodType>(
              groupValue: selectedMethod,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(bookingViewModelProvider.notifier)
                      .updatePaymentMethod(value);
                }
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _PaymentMethodTile(
                    method: PaymentMethodType.creditCard,
                    title: 'Thẻ tín dụng / Ghi nợ',
                    subtitle: 'Visa, Mastercard, JCB',
                    icon: Icons.credit_card,
                    isSelected: selectedMethod == PaymentMethodType.creditCard,
                    onTap: () => ref
                        .read(bookingViewModelProvider.notifier)
                        .updatePaymentMethod(PaymentMethodType.creditCard),
                  ),
                  const SizedBox(height: 12),
                  _PaymentMethodTile(
                    method: PaymentMethodType.eWallet,
                    title: 'Ví điện tử',
                    subtitle: 'MoMo, ZaloPay, ShopeePay',
                    icon: Icons.account_balance_wallet_outlined,
                    isSelected: selectedMethod == PaymentMethodType.eWallet,
                    onTap: () => ref
                        .read(bookingViewModelProvider.notifier)
                        .updatePaymentMethod(PaymentMethodType.eWallet),
                  ),
                  const SizedBox(height: 12),
                  _PaymentMethodTile(
                    method: PaymentMethodType.bankTransfer,
                    title: 'Chuyển khoản ngân hàng',
                    subtitle: 'Vietcombank, Techcombank...',
                    icon: Icons.account_balance_outlined,
                    isSelected:
                        selectedMethod == PaymentMethodType.bankTransfer,
                    onTap: () => ref
                        .read(bookingViewModelProvider.notifier)
                        .updatePaymentMethod(PaymentMethodType.bankTransfer),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng tiền:'),
                      Text(
                        formatBookingCurrency(draft.totalCost),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: selectedMethod == null
                          ? null
                          : () => context.push(RoutePaths.bookingCheckout),
                      child: const Text('Tiếp tục'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentMethodType method;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Radio<PaymentMethodType>(value: method),
          ],
        ),
      ),
    );
  }
}
