import '../../models/booking_flow_models.dart';
import '../../models/booking_model.dart';

abstract class BookingRepository {
  Future<PromoResult> validatePromoCode(String code, double subtotal);
  Future<BookingResult> createBooking(BookingRequest request);
  Future<List<BookingModel>> getBookingHistory(int userId);
  Future<BookingModel?> getBookingDetail(int bookingId);
  Future<bool> submitReview(ReviewRequest request);
}
