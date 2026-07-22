import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../widgets/home_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmit(String query) {
    final q = query.trim();
    if (q.isNotEmpty) {
      context.pushNamed(RouteNames.searchResults, queryParameters: {'q': q});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Container(
          height: 44,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: _onSearchSubmit,
            decoration: InputDecoration(
              hintText: 'Bạn muốn đi đâu?',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                onPressed: () {
                  _searchController.clear();
                  _focusNode.requestFocus();
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ),
      body: const _SearchExploreContent(),
    );
  }
}

class _SearchExploreContent extends StatelessWidget {
  const _SearchExploreContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tìm kiếm gần đây',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _RecentSearchChip(label: 'Tour Sapa 3 ngày'),
              _RecentSearchChip(label: 'Du thuyền Hạ Long'),
              _RecentSearchChip(label: 'Đà Nẵng Hội An'),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Điểm đến thịnh hành',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          const DestinationGrid(),
          const SizedBox(height: 32),
          const Text(
            'Danh mục phổ biến',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          const CategoryChips(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _RecentSearchChip extends StatelessWidget {
  final String label;

  const _RecentSearchChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        RouteNames.searchResults,
        queryParameters: {'q': label},
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history, size: 16, color: Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF334155), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
