import 'package:equatable/equatable.dart';

class ItineraryItem extends Equatable {
  const ItineraryItem({
    required this.iconName,
    required this.title,
    required this.subtitle,
  });

  final String iconName; // e.g. flight_takeoff, hotel, directions_car
  final String title;
  final String subtitle;

  @override
  List<Object?> get props => [iconName, title, subtitle];
}

class TravelerDetail extends Equatable {
  const TravelerDetail({
    required this.name,
    required this.initials,
    this.isLead = false,
    required this.documentId,
    required this.preferences,
    required this.status,
  });

  final String name;
  final String initials;
  final bool isLead;
  final String documentId;
  final List<String> preferences;
  final String status; // Verified, Pending

  @override
  List<Object?> get props => [
    name,
    initials,
    isLead,
    documentId,
    preferences,
    status,
  ];
}

class ActivityTimelineItem extends Equatable {
  const ActivityTimelineItem({
    required this.title,
    required this.timestamp,
    this.note,
    this.isPrimary = false,
  });

  final String title;
  final String timestamp;
  final String? note;
  final bool isPrimary;

  @override
  List<Object?> get props => [title, timestamp, note, isPrimary];
}

class AdminBookingDetailModel extends Equatable {
  const AdminBookingDetailModel({
    required this.id,
    required this.bookingCode,
    required this.tourTitle,
    required this.tourImageUrl,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.travelerCount,
    required this.customerEmail,
    required this.customerPhone,
    required this.billingAddress,
    required this.subtotal,
    required this.luxurySurcharge,
    required this.totalPrice,
    required this.depositPaid,
    required this.balanceDue,
    required this.itinerary,
    required this.travelers,
    required this.timeline,
  });

  final int id;
  final String bookingCode;
  final String tourTitle;
  final String tourImageUrl;
  final String status; // confirmed, pending, canceled
  final DateTime startDate;
  final DateTime endDate;
  final int travelerCount;
  final String customerEmail;
  final String customerPhone;
  final String billingAddress;
  final double subtotal;
  final double luxurySurcharge;
  final double totalPrice;
  final double depositPaid;
  final double balanceDue;
  final List<ItineraryItem> itinerary;
  final List<TravelerDetail> travelers;
  final List<ActivityTimelineItem> timeline;

  AdminBookingDetailModel copyWith({
    int? id,
    String? bookingCode,
    String? tourTitle,
    String? tourImageUrl,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? travelerCount,
    String? customerEmail,
    String? customerPhone,
    String? billingAddress,
    double? subtotal,
    double? luxurySurcharge,
    double? totalPrice,
    double? depositPaid,
    double? balanceDue,
    List<ItineraryItem>? itinerary,
    List<TravelerDetail>? travelers,
    List<ActivityTimelineItem>? timeline,
  }) {
    return AdminBookingDetailModel(
      id: id ?? this.id,
      bookingCode: bookingCode ?? this.bookingCode,
      tourTitle: tourTitle ?? this.tourTitle,
      tourImageUrl: tourImageUrl ?? this.tourImageUrl,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      travelerCount: travelerCount ?? this.travelerCount,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      billingAddress: billingAddress ?? this.billingAddress,
      subtotal: subtotal ?? this.subtotal,
      luxurySurcharge: luxurySurcharge ?? this.luxurySurcharge,
      totalPrice: totalPrice ?? this.totalPrice,
      depositPaid: depositPaid ?? this.depositPaid,
      balanceDue: balanceDue ?? this.balanceDue,
      itinerary: itinerary ?? this.itinerary,
      travelers: travelers ?? this.travelers,
      timeline: timeline ?? this.timeline,
    );
  }

  @override
  List<Object?> get props => [
    id,
    bookingCode,
    tourTitle,
    tourImageUrl,
    status,
    startDate,
    endDate,
    travelerCount,
    customerEmail,
    customerPhone,
    billingAddress,
    subtotal,
    luxurySurcharge,
    totalPrice,
    depositPaid,
    balanceDue,
    itinerary,
    travelers,
    timeline,
  ];
}
