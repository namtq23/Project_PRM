import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/preferences_service.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../models/booking_flow_models.dart';
import '../../models/booking_model.dart';

part 'booking_view_model.g.dart';

@Riverpod(keepAlive: true)
class BookingViewModel extends _$BookingViewModel {
  @override
  BookingDraft build() => const BookingDraft(tourId: 0, basePrice: 0);

  void startBooking({required int tourId, required double basePrice}) {
    if (tourId <= 0 || basePrice < 0) {
      throw ArgumentError('Tour ID and base price must be valid.');
    }
    state = BookingDraft(tourId: tourId, basePrice: basePrice);
  }

  void updateTravelerInfo(TravelerInfo info) {
    state = state.copyWith(travelerInfo: info);
  }

  void updatePaymentMethod(PaymentMethodType method) {
    state = state.copyWith(paymentMethod: method);
  }

  Future<PromoResult> applyPromoCode(String code) async {
    final result = await ref
        .read(bookingRepositoryProvider)
        .validatePromoCode(code, state.subtotal);
    state = result.isValid
        ? state.copyWith(
            promoCode: code.trim().toUpperCase(),
            discountAmount: result.discountAmount,
          )
        : state.copyWith(clearPromoCode: true, discountAmount: 0);
    return result;
  }

  Future<BookingResult> submitBooking() async {
    final userId = await ref
        .read(preferencesServiceProvider)
        .getCurrentUserId();
    if (userId == null) {
      return const BookingResult(
        success: false,
        message: 'Vui lòng đăng nhập trước khi đặt tour.',
      );
    }

    final result = await ref
        .read(bookingRepositoryProvider)
        .createBooking(BookingRequest(draft: state, userId: userId));
    if (result.success) {
      ref.invalidate(bookingHistoryViewModelProvider);
    }
    return result;
  }
}

@riverpod
class BookingHistoryViewModel extends _$BookingHistoryViewModel {
  @override
  FutureOr<List<BookingModel>> build() async {
    final userId = await ref
        .read(preferencesServiceProvider)
        .getCurrentUserId();
    if (userId == null) {
      throw const BookingException(
        'Vui lòng đăng nhập để xem lịch sử đặt tour.',
      );
    }
    return ref.read(bookingRepositoryProvider).getBookingHistory(userId);
  }
}

@riverpod
class BookingDetailViewModel extends _$BookingDetailViewModel {
  @override
  FutureOr<BookingModel?> build(int bookingId) async {
    final userId = await ref
        .read(preferencesServiceProvider)
        .getCurrentUserId();
    if (userId == null) {
      throw const BookingException('Vui lòng đăng nhập để xem đơn đặt tour.');
    }
    return ref
        .read(bookingRepositoryProvider)
        .getBookingDetail(bookingId: bookingId, userId: userId);
  }
}

@riverpod
class ReviewViewModel extends _$ReviewViewModel {
  @override
  AsyncValue<bool?> build() => const AsyncValue.data(null);

  Future<void> submitReview({
    required int bookingId,
    required int tourId,
    required int rating,
    required String comment,
  }) async {
    state = const AsyncValue.loading();
    try {
      final userId = await ref
          .read(preferencesServiceProvider)
          .getCurrentUserId();
      if (userId == null) {
        throw const BookingException('Vui lòng đăng nhập để gửi đánh giá.');
      }
      final success = await ref
          .read(bookingRepositoryProvider)
          .submitReview(
            ReviewRequest(
              bookingId: bookingId,
              tourId: tourId,
              userId: userId,
              rating: rating,
              comment: comment,
            ),
          );
      state = AsyncValue.data(success);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
