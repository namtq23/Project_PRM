import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TourFilters {
  final String category;
  final double minPrice;
  final double maxPrice;
  final int minRating;
  final String duration;

  const TourFilters({
    this.category = 'Tất cả',
    this.minPrice = 0,
    this.maxPrice = 10000000,
    this.minRating = 0,
    this.duration = '',
  });

  TourFilters copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    int? minRating,
    String? duration,
  }) {
    return TourFilters(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      duration: duration ?? this.duration,
    );
  }
}

class SearchFilterSheet extends StatefulWidget {
  final TourFilters initialFilters;

  const SearchFilterSheet({super.key, required this.initialFilters});

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late TourFilters _filters;

  final List<String> _categories = [
    'Tất cả',
    'Mạo hiểm',
    'Nghỉ dưỡng',
    'Văn hóa',
    'Ẩm thực',
  ];

  final List<int> _ratings = [1, 2, 3, 4, 5];

  final List<Map<String, dynamic>> _durations = [
    {'title': 'Trong ngày', 'icon': Icons.schedule},
    {'title': '2 - 3 ngày', 'icon': Icons.hotel},
    {'title': 'Trên 3 ngày', 'icon': Icons.event_available},
  ];

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
  }

  String _formatPrice(double val) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    ).format(val);
  }

  void _reset() {
    setState(() {
      _filters = const TourFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        MediaQuery.of(context)
            .viewInsets
            .bottom, // Don't add extra padding here to keep footer fixed
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFBEC8D2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Header
          Row(
            children: [
              const Text(
                'Bộ lọc tìm kiếm',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFEAEEF4),
                  foregroundColor: const Color(0xFF3E4850),
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFFEAEEF4), height: 32),
          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  const Text(
                    'Loại hình tour',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _categories.map((c) {
                      final selected = _filters.category == c;
                      return GestureDetector(
                        onTap: () => setState(
                          () => _filters = _filters.copyWith(category: c),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF006591).withValues(alpha: 0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF006591)
                                  : const Color(0xFFBEC8D2),
                            ),
                          ),
                          child: Text(
                            c,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: selected
                                  ? const Color(0xFF006591)
                                  : const Color(0xFF3E4850),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Khoảng giá',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_formatPrice(_filters.minPrice)} - ${_formatPrice(_filters.maxPrice)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF006591),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF006591),
                      inactiveTrackColor: const Color(0xFFEAEEF4),
                      thumbColor: const Color(0xFF006591),
                      overlayColor: const Color(
                        0xFF006591,
                      ).withValues(alpha: 0.2),
                      trackHeight: 6,
                    ),
                    child: RangeSlider(
                      values: RangeValues(_filters.minPrice, _filters.maxPrice),
                      min: 0,
                      max: 10000000,
                      divisions: 20,
                      onChanged: (val) {
                        setState(() {
                          _filters = _filters.copyWith(
                            minPrice: val.start,
                            maxPrice: val.end,
                          );
                        });
                      },
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0đ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        '10tr+',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Ratings
                  const Text(
                    'Đánh giá',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: _ratings.map((r) {
                      final selected = _filters.minRating == r;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(
                            () => _filters = _filters.copyWith(
                              minRating: selected ? 0 : r,
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(right: r != 5 ? 12 : 0),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(
                                      0xFF006591,
                                    ).withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF006591)
                                    : const Color(0xFFBEC8D2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: const Color(0xFFF59E0B),
                                  size: 20,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  r == 5 ? '5' : '$r+',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: selected
                                        ? const Color(0xFF006591)
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  // Duration
                  const Text(
                    'Thời gian',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ..._durations.map((d) {
                    final title = d['title'] as String;
                    final icon = d['icon'] as IconData;
                    final selected = _filters.duration == title;

                    return GestureDetector(
                      onTap: () => setState(
                        () => _filters = _filters.copyWith(
                          duration: selected ? '' : title,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              color: const Color(0xFF3E4850),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF006591)
                                      : const Color(0xFFBEC8D2),
                                  width: selected ? 6 : 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Footer actions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFEAEEF4))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFFBEC8D2)),
                    ),
                    child: const Text(
                      'Đặt lại',
                      style: TextStyle(color: Color(0xFF0F172A), fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(_filters),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF006591),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Áp dụng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
