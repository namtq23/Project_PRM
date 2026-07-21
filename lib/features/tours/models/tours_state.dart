import 'tour_model.dart';

class ToursState {
  const ToursState({
    this.allTours = const [],
    this.filteredTours = const [],
    this.selectedFilter = 'all', // 'all', 'active', 'draft', 'inactive'
    this.isLoading = false,
    this.errorMessage,
    this.currentPage = 1,
    this.itemsPerPage = 10,
    this.totalCount = 0,
    this.searchQuery = '',
  });

  final List<TourModel> allTours;
  final List<TourModel> filteredTours;
  final String selectedFilter;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final int itemsPerPage;
  final int totalCount;
  final String searchQuery;

  ToursState copyWith({
    List<TourModel>? allTours,
    List<TourModel>? filteredTours,
    String? selectedFilter,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    int? itemsPerPage,
    int? totalCount,
    String? searchQuery,
  }) {
    return ToursState(
      allTours: allTours ?? this.allTours,
      filteredTours: filteredTours ?? this.filteredTours,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalCount: totalCount ?? this.totalCount,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  String toString() {
    return 'ToursState(allToursCount: ${allTours.length}, filteredToursCount: ${filteredTours.length}, selectedFilter: $selectedFilter, isLoading: $isLoading, errorMessage: $errorMessage, currentPage: $currentPage, itemsPerPage: $itemsPerPage, totalCount: $totalCount, searchQuery: $searchQuery)';
  }
}
