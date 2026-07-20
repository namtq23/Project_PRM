import 'package:equatable/equatable.dart';
import 'booking_model.dart';

class TravelerInfo extends Equatable {
  final String contactName;
  final String contactPhone;
  final int adultCount;
  final int childCount;
  final DateTime? selectedDate;
  final String? specialNotes;

  const TravelerInfo({
    this.contactName = '',
    this.contactPhone = '',
    this.adultCount = 1,
    this.childCount = 0,
    this.selectedDate,
    this.specialNotes,
  });

  TravelerInfo copyWith({
    String? contactName,
    String? contactPhone,
    int? adultCount,
    int? childCount,
    DateTime? selectedDate,
    String? specialNotes,
  }) {
    return TravelerInfo(
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      adultCount: adultCount ?? this.adultCount,
      childCount: childCount ?? this.childCount,
      selectedDate: selectedDate ?? this.selectedDate,
      specialNotes: specialNotes ?? this.specialNotes,
    );
  }

  @override
  List<Object?> get props => [
        contactName,
        contactPhone,
        adultCount,
        childCount,
        selectedDate,
        specialNotes,
      ];
}

enum PaymentMethodType {
  creditCard,
  eWallet,
  bankTransfer,
}

class BookingDraft extends Equatable {
  final int tourId;
  final double basePrice;
  final TravelerInfo travelerInfo;
  final PaymentMethodType? paymentMethod;
  final String? promoCode;
  final double discountAmount;

  const BookingDraft({
    required this.tourId,
    required this.basePrice,
    this.travelerInfo = const TravelerInfo(),
    this.paymentMethod,
    this.promoCode,
    this.discountAmount = 0,
  });

  double get subtotal => (travelerInfo.adultCount * basePrice) + (travelerInfo.childCount * basePrice * 0.7);
  double get totalCost => subtotal - discountAmount;

  BookingDraft copyWith({
    TravelerInfo? travelerInfo,
    PaymentMethodType? paymentMethod,
    String? promoCode,
    double? discountAmount,
  }) {
    return BookingDraft(
      tourId: tourId,
      basePrice: basePrice,
      travelerInfo: travelerInfo ?? this.travelerInfo,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  @override
  List<Object?> get props => [
        tourId,
        basePrice,
        travelerInfo,
        paymentMethod,
        promoCode,
        discountAmount,
      ];
}

class BookingRequest {
  final BookingDraft draft;
  final int userId;

  BookingRequest({required this.draft, required this.userId});
}

class BookingResult extends Equatable {
  final bool success;
  final String? message;
  final String? confirmationCode;
  final BookingModel? booking;

  const BookingResult({
    required this.success,
    this.message,
    this.confirmationCode,
    this.booking,
  });

  @override
  List<Object?> get props => [success, message, confirmationCode, booking];
}

class PromoResult extends Equatable {
  final bool isValid;
  final double discountAmount;
  final String? message;

  const PromoResult({
    required this.isValid,
    this.discountAmount = 0,
    this.message,
  });

  @override
  List<Object?> get props => [isValid, discountAmount, message];
}

class ReviewRequest extends Equatable {
  final int bookingId;
  final int tourId;
  final int userId;
  final int rating;
  final String comment;

  const ReviewRequest({
    required this.bookingId,
    required this.tourId,
    required this.userId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [bookingId, tourId, userId, rating, comment];
}
