import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/admin_booking_detail_model.dart';
import '../data_sources/booking_details_data_source.dart';

part 'booking_details_repository.g.dart';

class BookingDetailsRepository {
  BookingDetailsRepository(this._dataSource);

  final BookingDetailsDataSource _dataSource;

  Future<AdminBookingDetailModel?> getBookingDetail(int id) async {
    return _dataSource.getBookingDetailById(id);
  }

  Future<void> updateBookingStatus(int id, String status) async {
    await _dataSource.updateBookingStatus(id, status);
  }
}

@Riverpod(keepAlive: true)
BookingDetailsRepository bookingDetailsRepository(Ref ref) {
  return BookingDetailsRepository(ref.watch(bookingDetailsDataSourceProvider));
}
