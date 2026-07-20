import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../view_models/booking_view_model.dart';
import '../../models/booking_flow_models.dart';
import '../../../../app/router/route_paths.dart';

class PaymentMethodView extends ConsumerWidget {
  const PaymentMethodView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingViewModelProvider);
    final selectedMethod = draft.paymentMethod;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phương thức thanh toán'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMethodTile(
                  context,
                  ref,
                  PaymentMethodType.creditCard,
                  'Thẻ tín dụng / Ghi nợ',
                  'Visa, Mastercard, JCB',
                  Icons.credit_card,
                  selectedMethod,
                ),
                const SizedBox(height: 12),
                _buildMethodTile(
                  context,
                  ref,
                  PaymentMethodType.eWallet,
                  'Ví điện tử',
                  'MoMo, ZaloPay, ShopeePay',
                  Icons.account_balance_wallet_outlined,
                  selectedMethod,
                ),
                const SizedBox(height: 12),
                _buildMethodTile(
                  context,
                  ref,
                  PaymentMethodType.bankTransfer,
                  'Chuyển khoản ngân hàng',
                  'Vietcombank, Techcombank...',
                  Icons.account_balance_outlined,
                  selectedMethod,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                        '${draft.totalCost.toStringAsFixed(0)} USD',
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
                      onPressed: selectedMethod != null
                          ? () => context.push(RoutePaths.bookingCheckout)
                          : null,
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

  Widget _buildMethodTile(
    BuildContext context,
    WidgetRef ref,
    PaymentMethodType method,
    String title,
    String subtitle,
    IconData icon,
    PaymentMethodType? selected,
  ) {
    final isSelected = method == selected;
    return InkWell(
      onTap: () => ref.read(bookingViewModelProvider.notifier).updatePaymentMethod(method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: isSelected ? Theme.of(context).colorScheme.primary : null),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Radio<PaymentMethodType>(
              value: method,
              groupValue: selected,
              onChanged: (val) {
                if (val != null) {
                  ref.read(bookingViewModelProvider.notifier).updatePaymentMethod(val);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
