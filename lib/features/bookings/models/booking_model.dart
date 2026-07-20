import 'package:equatable/equatable.dart';

class BookingModel extends Equatable {
  final int? bookingId;
  final int userId;
  final int tourId;
  final DateTime bookingDate;
  final double totalCost;
  final String paymentMethod;
  final String status;
  final int passengerQuantity;
  final String? specialNotes;
  final String? promoCode;
  final String? confirmationCode;

  const BookingModel({
    this.bookingId,
    required this.userId,
    required this.tourId,
    required this.bookingDate,
    required this.totalCost,
    required this.paymentMethod,
    required this.status,
    required this.passengerQuantity,
    this.specialNotes,
    this.promoCode,
    this.confirmationCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'booking_id': bookingId,
      'user_id': userId,
      'tour_id': tourId,
      'booking_date': bookingDate.toIso8601String(),
      'total_cost': totalCost,
      'payment_method': paymentMethod,
      'status': status,
      'passenger_quantity': passengerQuantity,
      'special_notes': specialNotes,
      'promo_code': promoCode,
      'confirmation_code': confirmationCode,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      bookingId: map['booking_id'] as int?,
      userId: map['user_id'] as int,
      tourId: map['tour_id'] as int,
      bookingDate: DateTime.parse(map['booking_date'] as String),
      totalCost: (map['total_cost'] as num).toDouble(),
      paymentMethod: map['payment_method'] as String,
      status: map['status'] as String,
      passengerQuantity: map['passenger_quantity'] as int,
      specialNotes: map['special_notes'] as String?,
      promoCode: map['promo_code'] as String?,
      confirmationCode: map['confirmation_code'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        bookingId,
        userId,
        tourId,
        bookingDate,
        totalCost,
        paymentMethod,
        status,
        passengerQuantity,
        specialNotes,
        promoCode,
        confirmationCode,
      ];
}
