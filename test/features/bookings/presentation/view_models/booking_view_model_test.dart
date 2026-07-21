import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_prm/features/bookings/data/repositories/booking_repository.dart';
import 'package:project_prm/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:project_prm/features/bookings/models/booking_flow_models.dart';
import 'package:project_prm/features/bookings/models/booking_model.dart';
import 'package:project_prm/features/bookings/presentation/view_models/booking_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'view model keeps draft, applies promo, and uses session user ID',
    () async {
      SharedPreferences.setMockInitialValues({'current_user_id': 7});
      final repository = _FakeBookingRepository();
      final container = ProviderContainer(
        overrides: [bookingRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final viewModel = container.read(bookingViewModelProvider.notifier);
      viewModel.startBooking(tourId: 42, basePrice: 200);
      viewModel.updateTravelerInfo(
        TravelerInfo(
          contactName: 'Nguyễn Văn A',
          contactPhone: '0912345678',
          adultCount: 2,
          childCount: 1,
          selectedDate: DateTime.now().add(const Duration(days: 10)),
        ),
      );
      viewModel.updatePaymentMethod(PaymentMethodType.eWallet);

      final promo = await viewModel.applyPromoCode('viettravel10');
      expect(promo.isValid, isTrue);
      expect(
        container.read(bookingViewModelProvider).promoCode,
        'VIETTRAVEL10',
      );
      expect(container.read(bookingViewModelProvider).discountAmount, 54);

      await viewModel.applyPromoCode('INVALID');
      expect(container.read(bookingViewModelProvider).promoCode, isNull);
      expect(container.read(bookingViewModelProvider).discountAmount, 0);
      await viewModel.applyPromoCode('VIETTRAVEL10');

      final result = await viewModel.submitBooking();
      expect(result.success, isTrue);
      expect(repository.lastRequest?.userId, 7);
      expect(repository.lastRequest?.draft.tourId, 42);
    },
  );

  test('view model blocks checkout when no user session exists', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = _FakeBookingRepository();
    final container = ProviderContainer(
      overrides: [bookingRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final result = await container
        .read(bookingViewModelProvider.notifier)
        .submitBooking();

    expect(result.success, isFalse);
    expect(result.message, contains('đăng nhập'));
    expect(repository.lastRequest, isNull);
  });

  test('history view model loads bookings for session user only', () async {
    SharedPreferences.setMockInitialValues({'current_user_id': 9});
    final repository = _FakeBookingRepository();
    final container = ProviderContainer(
      overrides: [bookingRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final history = await container.read(
      bookingHistoryViewModelProvider.future,
    );

    expect(history, isEmpty);
    expect(repository.historyUserId, 9);
  });
}

class _FakeBookingRepository implements BookingRepository {
  BookingRequest? lastRequest;
  int? historyUserId;

  @override
  Future<PromoResult> validatePromoCode(String code, double subtotal) async {
    return PromoResult(
      isValid: code.trim().toUpperCase() == 'VIETTRAVEL10',
      discountAmount: subtotal * 0.1,
      message: 'OK',
    );
  }

  @override
  Future<BookingResult> createBooking(BookingRequest request) async {
    lastRequest = request;
    return const BookingResult(success: true, confirmationCode: 'VT-TEST');
  }

  @override
  Future<BookingModel?> getBookingDetail({
    required int bookingId,
    required int userId,
  }) async {
    return null;
  }

  @override
  Future<List<BookingModel>> getBookingHistory(int userId) async {
    historyUserId = userId;
    return const [];
  }

  @override
  Future<bool> submitReview(ReviewRequest request) async => true;
}
