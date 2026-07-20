import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/mock_booking_repository.dart';
import '../../models/booking_flow_models.dart';

part 'booking_view_model.g.dart';

@riverpod
BookingRepository bookingRepository(Ref ref) {
  // Return Mock repository for now
  return MockBookingRepository();
}

@riverpod
class BookingViewModel extends _$BookingViewModel {
  @override
  BookingDraft build() {
    // Initial draft with some mock tour data
    return const BookingDraft(tourId: 1, basePrice: 500.0);
  }

  void updateTravelerInfo(TravelerInfo info) {
    state = state.copyWith(travelerInfo: info);
  }

  void updatePaymentMethod(PaymentMethodType method) {
    state = state.copyWith(paymentMethod: method);
  }

  Future<PromoResult> applyPromoCode(String code) async {
    final repository = ref.read(bookingRepositoryProvider);
    final result = await repository.validatePromoCode(code, state.subtotal);
    if (result.isValid) {
      state = state.copyWith(promoCode: code, discountAmount: result.discountAmount);
    } else {
      state = state.copyWith(promoCode: null, discountAmount: 0);
    }
    return result;
  }

  Future<BookingResult> submitBooking() async {
    final repository = ref.read(bookingRepositoryProvider);
    final request = BookingRequest(draft: state, userId: 1); // Mock user ID
    return await repository.createBooking(request);
  }
}

@riverpod
class BookingHistoryViewModel extends _$BookingHistoryViewModel {
  @override
  FutureOr<List> build() async {
    final repository = ref.read(bookingRepositoryProvider);
    return await repository.getBookingHistory(1); // Mock user ID
  }
}

@riverpod
class ReviewViewModel extends _$ReviewViewModel {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> submitReview(ReviewRequest request) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(bookingRepositoryProvider);
      final success = await repository.submitReview(request);
      state = AsyncValue.data(success);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
