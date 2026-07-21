import 'category_model.dart';

class CategoriesState {
  const CategoriesState({
    this.allCategories = const [],
    this.filteredCategories = const [],
    this.selectedFilter = 'all', // 'all', 'active', 'inactive'
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
    this.currentPage = 1,
    this.itemsPerPage = 10,
    this.totalCount = 0,
  });

  final List<CategoryModel> allCategories;
  final List<CategoryModel> filteredCategories;
  final String selectedFilter;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final int itemsPerPage;
  final int totalCount;

  CategoriesState copyWith({
    List<CategoryModel>? allCategories,
    List<CategoryModel>? filteredCategories,
    String? selectedFilter,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    int? itemsPerPage,
    int? totalCount,
  }) {
    return CategoriesState(
      allCategories: allCategories ?? this.allCategories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  String toString() {
    return 'CategoriesState(allCategoriesCount: ${allCategories.length}, filteredCategoriesCount: ${filteredCategories.length}, selectedFilter: $selectedFilter, searchQuery: $searchQuery, isLoading: $isLoading, errorMessage: $errorMessage, currentPage: $currentPage, itemsPerPage: $itemsPerPage, totalCount: $totalCount)';
  }
}
