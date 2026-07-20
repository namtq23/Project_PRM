import 'tour_model.dart';

class ToursState {
  const ToursState({
    this.allTours = const [],
    this.filteredTours = const [],
    this.selectedFilter = 'all',
    this.isLoading = false,
    this.errorMessage,
  });

  final List<TourModel> allTours;
  final List<TourModel> filteredTours;
  final String selectedFilter; // 'all', 'active', 'draft', 'inactive'
  final bool isLoading;
  final String? errorMessage;

  ToursState copyWith({
    List<TourModel>? allTours,
    List<TourModel>? filteredTours,
    String? selectedFilter,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ToursState(
      allTours: allTours ?? this.allTours,
      filteredTours: filteredTours ?? this.filteredTours,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // We allow setting errorMessage back to null when reset
    );
  }

  @override
  String toString() {
    return 'ToursState(allToursCount: ${allTours.length}, filteredToursCount: ${filteredTours.length}, selectedFilter: $selectedFilter, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}
