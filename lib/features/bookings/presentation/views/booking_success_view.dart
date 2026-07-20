import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_paths.dart';
import '../../models/booking_flow_models.dart';

class BookingSuccessView extends StatelessWidget {
  final BookingResult result;
  const BookingSuccessView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              Text(
                'Đặt tour thành công!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cảm ơn bạn đã tin tưởng VietTravel. Thông tin chi tiết đã được gửi đến email của bạn.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    const Text('Mã xác nhận đơn hàng'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          result.confirmationCode ?? '-',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: result.confirmationCode ?? ''));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã sao chép mã')));
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () => context.go(RoutePaths.bookings),
                  child: const Text('Về đơn hàng của tôi'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go(RoutePaths.home),
                child: const Text('Quay lại trang chủ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
