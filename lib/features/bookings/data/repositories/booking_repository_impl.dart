import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../models/booking_flow_models.dart';
import '../../models/booking_model.dart';
import '../data_sources/booking_data_source.dart';
import 'booking_repository.dart';

part 'booking_repository_impl.g.dart';

class BookingRepositoryImpl implements BookingRepository {
  const BookingRepositoryImpl(this.dataSource) : _uuid = const Uuid();

  static const _supportedPromoCode = 'VIETTRAVEL10';
  static const _childPriceFactor = 0.7;

  final BookingDataSource dataSource;
  final Uuid _uuid;

  @override
  Future<PromoResult> validatePromoCode(String code, double subtotal) async {
    final normalizedCode = code.trim().toUpperCase();
    if (normalizedCode != _supportedPromoCode) {
      return const PromoResult(
        isValid: false,
        message: 'Mã giảm giá không hợp lệ.',
      );
    }
    return PromoResult(
      isValid: true,
      discountAmount: subtotal * 0.1,
      message: 'Đã áp dụng giảm giá 10%.',
    );
  }

  @override
  Future<BookingResult> createBooking(BookingRequest request) async {
    final validationMessage = _validateDraft(request.draft);
    if (validationMessage != null) {
      return BookingResult(success: false, message: validationMessage);
    }

    try {
      final tourPrice = await dataSource.getActiveTourPrice(
        request.draft.tourId,
      );
      if (tourPrice == null) {
        return const BookingResult(
          success: false,
          message: 'Tour không tồn tại hoặc hiện không nhận đặt chỗ.',
        );
      }

      final traveler = request.draft.travelerInfo;
      final subtotal =
          traveler.adultCount * tourPrice +
          traveler.childCount * tourPrice * _childPriceFactor;
      var discountAmount = 0.0;
      final promoCode = request.draft.promoCode?.trim().toUpperCase();
      if (promoCode != null && promoCode.isNotEmpty) {
        final promo = await validatePromoCode(promoCode, subtotal);
        if (!promo.isValid) {
          return BookingResult(success: false, message: promo.message);
        }
        discountAmount = promo.discountAmount;
      }

      final now = DateTime.now().toUtc();
      final confirmationCode = _newConfirmationCode();
      final booking = BookingModel(
        userId: request.userId,
        tourId: request.draft.tourId,
        bookingDate: traveler.selectedDate!,
        totalCost: subtotal - discountAmount,
        paymentMethod: request.draft.paymentMethod!.databaseValue,
        status: 'pending',
        passengerQuantity: traveler.adultCount + traveler.childCount,
        specialNotes: traveler.specialNotes?.trim(),
        promoCode: promoCode,
        confirmationCode: confirmationCode,
        createdAt: now,
        updatedAt: now,
      );
      final savedBooking = await dataSource.createBooking(booking);
      return BookingResult(
        success: true,
        confirmationCode: savedBooking.confirmationCode,
        booking: savedBooking,
      );
    } on BookingDataException catch (error) {
      return BookingResult(success: false, message: error.message);
    }
  }

  @override
  Future<List<BookingModel>> getBookingHistory(int userId) async {
    try {
      return await dataSource.getBookingHistory(userId);
    } on BookingDataException catch (error) {
      throw BookingException(error.message);
    }
  }

  @override
  Future<BookingModel?> getBookingDetail({
    required int bookingId,
    required int userId,
  }) async {
    try {
      return await dataSource.getBookingDetail(
        bookingId: bookingId,
        userId: userId,
      );
    } on BookingDataException catch (error) {
      throw BookingException(error.message);
    }
  }

  @override
  Future<bool> submitReview(ReviewRequest request) async {
    if (request.rating < 1 || request.rating > 5) {
      throw const BookingException(
        'Vui lòng chọn mức đánh giá từ 1 đến 5 sao.',
      );
    }
    if (request.comment.trim().isEmpty) {
      throw const BookingException('Vui lòng nhập nội dung đánh giá.');
    }

    try {
      final booking = await dataSource.getBookingDetail(
        bookingId: request.bookingId,
        userId: request.userId,
      );
      if (booking == null || booking.tourId != request.tourId) {
        throw const BookingException('Không tìm thấy đơn đặt tour hợp lệ.');
      }
      if (booking.status.toLowerCase() != 'completed') {
        throw const BookingException(
          'Bạn chỉ có thể đánh giá sau khi chuyến đi hoàn thành.',
        );
      }
      final alreadyReviewed = await dataSource.reviewExists(
        userId: request.userId,
        tourId: request.tourId,
      );
      if (alreadyReviewed) {
        throw const BookingException('Bạn đã đánh giá tour này rồi.');
      }
      await dataSource.createReview(request);
      return true;
    } on BookingDataException catch (error) {
      throw BookingException(error.message);
    }
  }

  String? _validateDraft(BookingDraft draft) {
    final traveler = draft.travelerInfo;
    if (draft.tourId <= 0) return 'Thông tin tour không hợp lệ.';
    if (traveler.contactName.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên người liên hệ.';
    }
    if (!RegExp(r'^\d{10,11}$').hasMatch(traveler.contactPhone.trim())) {
      return 'Số điện thoại không hợp lệ.';
    }
    if (traveler.adultCount < 1 || traveler.childCount < 0) {
      return 'Số lượng hành khách không hợp lệ.';
    }
    final selectedDate = traveler.selectedDate;
    if (selectedDate == null) return 'Vui lòng chọn ngày khởi hành.';
    final today = DateTime.now();
    final firstValidDate = DateTime(today.year, today.month, today.day);
    if (selectedDate.isBefore(firstValidDate)) {
      return 'Ngày khởi hành không thể ở trong quá khứ.';
    }
    if (draft.paymentMethod == null) {
      return 'Vui lòng chọn phương thức thanh toán.';
    }
    return null;
  }

  String _newConfirmationCode() {
    final compactUuid = _uuid.v4().replaceAll('-', '').toUpperCase();
    return 'VT-${compactUuid.substring(0, 8)}';
  }
}

@Riverpod(keepAlive: true)
BookingRepository bookingRepository(Ref ref) {
  return BookingRepositoryImpl(ref.watch(bookingDataSourceProvider));
}
