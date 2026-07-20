import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_paths.dart';

class BookingFailedView extends StatelessWidget {
  final String? error;
  const BookingFailedView({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán thất bại')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 100, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              'Rất tiếc, đã có lỗi xảy ra',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              error ?? 'Giao dịch của bạn không thể hoàn tất vào lúc này. Vui lòng thử lại hoặc chọn phương thức thanh toán khác.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Thử lại'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go(RoutePaths.home),
              child: const Text('Hủy bỏ giao dịch'),
            ),
          ],
        ),
      ),
    );
  }
}
