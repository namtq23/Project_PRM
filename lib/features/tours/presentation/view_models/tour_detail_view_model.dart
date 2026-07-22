import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/tour_model.dart';
import '../../data/repositories/tour_repository.dart';

part 'tour_detail_view_model.g.dart';

@riverpod
class TourDetailViewModel extends _$TourDetailViewModel {
  @override
  FutureOr<TourModel?> build(int tourId) async {
    final repository = await ref.watch(tourRepositoryProvider.future);
    return repository.getTourById(tourId);
  }
}
