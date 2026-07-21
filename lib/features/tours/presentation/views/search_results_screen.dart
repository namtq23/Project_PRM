import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../models/tour_model.dart';
import '../view_models/search_view_model.dart';
import '../widgets/search_result_card.dart';
import '../widgets/search_filter_sheet.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  late TextEditingController _searchController;
  int _selectedSortIndex = 0;
  TourFilters _currentFilters = const TourFilters();

  final List<String> _sortOptions = [
    'Phổ biến nhất',
    'Giá thấp đến cao',
    'Đánh giá cao',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    // Trigger search immediately when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchViewModelProvider.notifier).search(widget.query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SearchResultsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query) {
      _searchController.text = widget.query;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchViewModelProvider.notifier).search(widget.query);
      });
    }
  }

  Future<void> _openFilterSheet() async {
    final filters = await showModalBottomSheet<TourFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SearchFilterSheet(initialFilters: _currentFilters),
    );

    if (filters != null && mounted) {
      setState(() {
        _currentFilters = filters;
      });
    }
  }

  List<TourModel> _processTours(List<TourModel> tours) {
    // 1. Filter
    var processed = tours.where((t) {
      if (_currentFilters.category != 'Tất cả' && t.categoryId != null) {
        // Very basic category check - ideally we'd map category ID to name
        // For now, we assume simple string matching or skip it if category not loaded
        // To be accurate, we'd need category joined in the view, but this is a mock filter for now
      }

      if (t.price < _currentFilters.minPrice ||
          t.price > _currentFilters.maxPrice) {
        return false;
      }

      // We don't have real ratings or categories mapped in TourModel model directly right now,
      // but we apply duration logic:
      if (_currentFilters.duration == 'Trong ngày' && t.durationDays > 1) {
        return false;
      }
      if (_currentFilters.duration == '2 - 3 ngày' &&
          (t.durationDays < 2 || t.durationDays > 3)) {
        return false;
      }
      if (_currentFilters.duration == 'Trên 3 ngày' && t.durationDays <= 3) {
        return false;
      }

      return true;
    }).toList();

    // 2. Sort
    switch (_selectedSortIndex) {
      case 1:
        processed.sort((a, b) => a.price.compareTo(b.price));
      case 2:
        processed.sort((a, b) => b.price.compareTo(a.price));
      default:
        break; // 'Phổ biến nhất'
    }
    return processed;
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: Colors.black12,
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (q) {
              final newQuery = q.trim();
              if (newQuery.isNotEmpty) {
                if (newQuery == widget.query) {
                  // Force refresh if it's the same query
                  ref.read(searchViewModelProvider.notifier).search(newQuery);
                } else {
                  context.pushReplacementNamed(
                    RouteNames.searchResults,
                    queryParameters: {'q': newQuery},
                  );
                }
              }
            },
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
                onPressed: () {
                  final q = _searchController.text.trim();
                  if (q.isNotEmpty) {
                    if (q == widget.query) {
                      ref.read(searchViewModelProvider.notifier).search(q);
                    } else {
                      context.pushReplacementNamed(
                        RouteNames.searchResults,
                        queryParameters: {'q': q},
                      );
                    }
                  }
                },
              ),
              hintText: 'Tìm kiếm tour...',
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Bộ lọc',
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: searchState.when(
        loading: () => const _SearchResultsSkeleton(),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 56,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(height: 16),
              Text(
                'Đã xảy ra lỗi',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => ref
                    .read(searchViewModelProvider.notifier)
                    .search(widget.query),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
        data: (tours) {
          if (tours == null || tours.isEmpty) {
            return _EmptyState(query: widget.query);
          }

          final processed = _processTours(tours);

          if (processed.isEmpty) {
            return _EmptyState(query: widget.query);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Results header + sort chips
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kết quả cho "${widget.query}"',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Đang hiển thị ${tours.length} hành trình tuyệt vời nhất',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_sortOptions.length, (i) {
                          final selected = _selectedSortIndex == i;
                          return Padding(
                            padding: EdgeInsets.only(
                              right: i < _sortOptions.length - 1 ? 8 : 0,
                            ),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedSortIndex = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFF006591)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: selected
                                        ? const Color(0xFF006591)
                                        : const Color(0xFFBEC8D2),
                                  ),
                                ),
                                child: Text(
                                  _sortOptions[i],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF3E4850),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              // Results list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: processed.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    return SearchResultCard(
                      tour: processed[index],
                      onTap: () => context.pushNamed(
                        RouteNames.tourDetail,
                        pathParameters: {
                          'tourId': processed[index].id?.toString() ?? '0',
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;

  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFEAEEF4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 60,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Không tìm thấy kết quả',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Không tìm thấy tour nào phù hợp với "$query".\nHãy thử thay đổi từ khóa khác.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Thử lại tìm kiếm'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF006591),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultsSkeleton extends StatelessWidget {
  const _SearchResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerBox(width: 200, height: 20),
              const SizedBox(height: 8),
              _shimmerBox(width: 160, height: 14),
              const SizedBox(height: 12),
              Row(
                children: [
                  _shimmerBox(width: 110, height: 34),
                  const SizedBox(width: 8),
                  _shimmerBox(width: 120, height: 34),
                  const SizedBox(width: 8),
                  _shimmerBox(width: 100, height: 34),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(height: 24),
            itemBuilder: (_, _) => ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(height: 280, color: const Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _shimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
