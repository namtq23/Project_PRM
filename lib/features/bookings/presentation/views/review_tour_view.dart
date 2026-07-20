import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/booking_model.dart';
import '../view_models/booking_view_model.dart';

class ReviewTourView extends ConsumerStatefulWidget {
  const ReviewTourView({required this.bookingId, this.booking, super.key});

  final int bookingId;
  final BookingModel? booking;

  @override
  ConsumerState<ReviewTourView> createState() => _ReviewTourViewState();
}

class _ReviewTourViewState extends ConsumerState<ReviewTourView> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref
        .read(reviewViewModelProvider.notifier)
        .submitReview(
          bookingId: widget.bookingId,
          tourId: widget.booking?.tourId ?? 0,
          rating: _rating,
          comment: _commentController.text,
        );

    if (!mounted) return;
    final state = ref.read(reviewViewModelProvider);
    if (state.value == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cảm ơn bạn đã đánh giá!')));
      context.pop();
      return;
    }

    final message = state.hasError
        ? state.error.toString()
        : 'Gửi đánh giá thất bại. Vui lòng thử lại.';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gửi đánh giá tour')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.stars, size: 80, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Trải nghiệm của bạn thế nào?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hãy chia sẻ cảm nhận để chúng tôi phục vụ tốt hơn.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  iconSize: 40,
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                  ),
                  onPressed: () => setState(() => _rating = index + 1),
                );
              }),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Nhận xét của bạn...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: reviewState.isLoading ? null : _submit,
                child: reviewState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Gửi đánh giá'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
