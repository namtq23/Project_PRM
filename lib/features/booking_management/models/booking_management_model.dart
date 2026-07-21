class BookingManagementModel {
  const BookingManagementModel({
    required this.id,
    required this.userId,
    required this.tourId,
    required this.customerName,
    required this.customerEmail,
    required this.tourTitle,
    required this.bookingDate,
    required this.status,
    required this.totalPrice,
    required this.passengers,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int userId;
  final int tourId;
  final String customerName;
  final String customerEmail;
  final String tourTitle;
  final DateTime bookingDate;
  final String status; // pending, approved, completed, canceled
  final double totalPrice;
  final int passengers;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory BookingManagementModel.fromMap(Map<String, Object?> map) {
    final rawCustomerName = (map['customer_name'] as String?)?.trim();
    final rawCustomerEmail = (map['customer_email'] as String?)?.trim();
    final rawTourTitle = (map['tour_title'] as String?)?.trim();

    final totalPriceNum = (map['total_price'] as num?)?.toDouble() ?? 0.0;
    final totalCostNum = (map['total_cost'] as num?)?.toDouble() ?? 0.0;
    final price = totalPriceNum > 0
        ? totalPriceNum
        : (totalCostNum > 0 ? totalCostNum : 0.0);

    return BookingManagementModel(
      id: map['id']! as int,
      userId: map['user_id']! as int,
      tourId: map['tour_id']! as int,
      customerName: (rawCustomerName != null && rawCustomerName.isNotEmpty)
          ? rawCustomerName
          : 'Guest Customer',
      customerEmail: (rawCustomerEmail != null && rawCustomerEmail.isNotEmpty)
          ? rawCustomerEmail
          : 'guest@example.com',
      tourTitle: (rawTourTitle != null && rawTourTitle.isNotEmpty)
          ? rawTourTitle
          : 'Tour Booking',
      bookingDate: DateTime.parse(map['booking_date']! as String),
      status: map['status']! as String,
      totalPrice: price,
      passengers: ((map['passengers'] ?? map['passenger_quantity'] ?? 1) as num)
          .toInt(),
      createdAt: DateTime.parse(map['created_at']! as String),
      updatedAt: DateTime.parse(map['updated_at']! as String),
    );
  }

  Map<String, Object?> toMap() => {
    if (id != 0) 'id': id,
    'user_id': userId,
    'tour_id': tourId,
    'customer_name': customerName,
    'customer_email': customerEmail,
    'tour_title': tourTitle,
    'booking_date': bookingDate.toIso8601String(),
    'status': status,
    'total_price': totalPrice,
    'passengers': passengers,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  BookingManagementModel copyWith({
    int? id,
    int? userId,
    int? tourId,
    String? customerName,
    String? customerEmail,
    String? tourTitle,
    DateTime? bookingDate,
    String? status,
    double? totalPrice,
    int? passengers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BookingManagementModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    tourId: tourId ?? this.tourId,
    customerName: customerName ?? this.customerName,
    customerEmail: customerEmail ?? this.customerEmail,
    tourTitle: tourTitle ?? this.tourTitle,
    bookingDate: bookingDate ?? this.bookingDate,
    status: status ?? this.status,
    totalPrice: totalPrice ?? this.totalPrice,
    passengers: passengers ?? this.passengers,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
