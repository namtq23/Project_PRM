import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../view_models/booking_view_model.dart';
import '../../models/booking_flow_models.dart';
import '../../models/booking_model.dart';

class ReviewTourView extends ConsumerStatefulWidget {
  final int bookingId;
  final BookingModel? booking;
  const ReviewTourView({super.key, required this.bookingId, this.booking});

  @override
  ConsumerState<ReviewTourView> createState() => _ReviewTourViewState();
}

class _ReviewTourViewState extends ConsumerState<ReviewTourView> {
  int _rating = 5;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() async {
    final request = ReviewRequest(
      bookingId: widget.bookingId,
      tourId: widget.booking?.tourId ?? 0,
      userId: 1, // Mock
      rating: _rating,
      comment: _commentController.text,
    );

    await ref.read(reviewViewModelProvider.notifier).submitReview(request);
    
    if (mounted) {
      final state = ref.read(reviewViewModelProvider);
      if (state.value == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cảm ơn bạn đã đánh giá!')));
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gửi đánh giá thất bại. Vui lòng thử lại.')));
      }
    }
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
            const Text('Vui lòng chia sẻ cảm nhận của bạn để chúng tôi phục vụ tốt hơn'),
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
