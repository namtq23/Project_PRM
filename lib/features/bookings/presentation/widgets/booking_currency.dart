import 'package:intl/intl.dart';

final _vietnameseCurrency = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: '₫',
  decimalDigits: 0,
);

String formatBookingCurrency(num value) => _vietnameseCurrency.format(value);
