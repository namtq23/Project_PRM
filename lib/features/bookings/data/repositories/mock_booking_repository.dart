import 'dart:math';
import '../../models/booking_flow_models.dart';
import '../../models/booking_model.dart';
import 'booking_repository.dart';

class MockBookingRepository implements BookingRepository {
  @override
  Future<PromoResult> validatePromoCode(String code, double subtotal) async {
    await Future.delayed(const Duration(seconds: 1));
    if (code.toUpperCase() == 'VIETTRAVEL10') {
      return PromoResult(isValid: true, discountAmount: subtotal * 0.1, message: 'Applied 10% discount');
    }
    return const PromoResult(isValid: false, message: 'Invalid promo code');
  }

  @override
  Future<BookingResult> createBooking(BookingRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate cases
    if (request.draft.travelerInfo.specialNotes?.contains('FAIL_PAYMENT') ?? false) {
      return const BookingResult(success: false, message: 'Payment failed at gateway');
    }
    if (request.draft.travelerInfo.specialNotes?.contains('NO_SEATS') ?? false) {
      return const BookingResult(success: false, message: 'Tour has no seats available');
    }

    final bookingId = Random().nextInt(10000);
    final confirmationCode = 'VT-${Random().nextInt(999999).toString().padLeft(6, '0')}';
    
    final booking = BookingModel(
      bookingId: bookingId,
      userId: request.userId,
      tourId: request.draft.tourId,
      bookingDate: request.draft.travelerInfo.selectedDate ?? DateTime.now(),
      totalCost: request.draft.totalCost,
      paymentMethod: request.draft.paymentMethod.toString(),
      status: 'confirmed',
      passengerQuantity: request.draft.travelerInfo.adultCount + request.draft.travelerInfo.childCount,
      specialNotes: request.draft.travelerInfo.specialNotes,
      promoCode: request.draft.promoCode,
      confirmationCode: confirmationCode,
    );

    return BookingResult(success: true, confirmationCode: confirmationCode, booking: booking);
  }

  @override
  Future<List<BookingModel>> getBookingHistory(int userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      BookingModel(
        bookingId: 1,
        userId: userId,
        tourId: 101,
        bookingDate: DateTime.now().subtract(const Duration(days: 5)),
        totalCost: 1200.0,
        paymentMethod: 'PaymentMethodType.creditCard',
        status: 'completed',
        passengerQuantity: 2,
        confirmationCode: 'VT-123456',
      ),
      BookingModel(
        bookingId: 2,
        userId: userId,
        tourId: 102,
        bookingDate: DateTime.now().add(const Duration(days: 10)),
        totalCost: 800.0,
        paymentMethod: 'PaymentMethodType.eWallet',
        status: 'confirmed',
        passengerQuantity: 1,
        confirmationCode: 'VT-789012',
      ),
    ];
  }

  @override
  Future<BookingModel?> getBookingDetail(int bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return BookingModel(
      bookingId: bookingId,
      userId: 1,
      tourId: 101,
      bookingDate: DateTime.now(),
      totalCost: 1200.0,
      paymentMethod: 'PaymentMethodType.creditCard',
      status: 'confirmed',
      passengerQuantity: 2,
      confirmationCode: 'VT-123456',
    );
  }

  @override
  Future<bool> submitReview(ReviewRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    if (request.comment.contains('FAIL')) return false;
    return true;
  }
}
