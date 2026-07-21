import '../../models/booking_flow_models.dart';
import '../../models/booking_model.dart';

abstract class BookingRepository {
  Future<PromoResult> validatePromoCode(String code, double subtotal);
  Future<BookingResult> createBooking(BookingRequest request);
  Future<List<BookingModel>> getBookingHistory(int userId);
  Future<BookingModel?> getBookingDetail({
    required int bookingId,
    required int userId,
  });
  Future<bool> submitReview(ReviewRequest request);
}

class BookingException implements Exception {
  const BookingException(this.message);

  final String message;

  @override
  String toString() => message;
}
