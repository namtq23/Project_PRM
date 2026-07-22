import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../tours/presentation/theme/tours_theme.dart';
import '../../../../../tours/presentation/widgets/admin_layout.dart';
import '../../models/category_model.dart';
import '../../models/categories_state.dart';
import '../view_models/categories_viewmodel.dart';

class CategoryManagementScreen extends ConsumerStatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  ConsumerState<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState
    extends ConsumerState<CategoryManagementScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Refresh categories when loading the screen to get accurate SQLite dynamic tour count
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoriesViewModelProvider.notifier).loadCategories();
    });
  }

  void _onSearchChanged() {
    ref
        .read(categoriesViewModelProvider.notifier)
        .searchCategories(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _deleteCategory(CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ToursTheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
        ),
        title: const Text(
          'Xác nhận xóa',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa danh mục "${category.title}"? Thao tác này không thể hoàn tác.',
          style: const TextStyle(color: ToursTheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Hủy',
              style: TextStyle(color: ToursTheme.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ToursTheme.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await ref
                  .read(categoriesViewModelProvider.notifier)
                  .deleteCategory(category.id!);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Xóa danh mục thành công!'
                          : 'Lỗi khi xóa danh mục!',
                    ),
                    backgroundColor: success
                        ? ToursTheme.success
                        : ToursTheme.danger,
                  ),
                );
              }
            },
            child: const Text(
              'Xóa',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName?.toLowerCase().trim()) {
      case 'luxury':
      case 'luxury-gold':
        return Icons.hotel_class_outlined;
      case 'adventure':
      case 'adventure-cyan':
        return Icons.explore_outlined;
      case 'heritage':
      case 'heritage-amber':
        return Icons.account_balance_outlined;
      case 'gourmet':
      case 'gourmet-red':
        return Icons.restaurant_outlined;
      case 'ocean':
      case 'ocean-blue':
        return Icons.beach_access_outlined;
      case 'explore':
      case 'compass':
        return Icons.explore_outlined;
      case 'location_city':
      case 'city':
        return Icons.location_city_outlined;
      case 'beach':
      case 'beach_access':
        return Icons.beach_access_outlined;
      case 'forest':
      case 'park':
        return Icons.park_outlined;
      case 'directions_boat':
      case 'boat':
        return Icons.directions_boat_outlined;
      case 'landscape':
      case 'mountain':
        return Icons.landscape_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  Color _getThemeColor(String? iconName) {
    switch (iconName?.toLowerCase().trim()) {
      case 'luxury':
      case 'luxury-gold':
        return Colors.amber;
      case 'adventure':
      case 'adventure-cyan':
        return Colors.cyan;
      case 'heritage':
      case 'heritage-amber':
        return Colors.orange;
      case 'gourmet':
      case 'gourmet-red':
        return Colors.red;
      case 'ocean':
      case 'ocean-blue':
        return Colors.blue;
      case 'explore':
      case 'compass':
        return Colors.orange;
      case 'location_city':
      case 'city':
        return Colors.purple;
      case 'beach':
      case 'beach_access':
        return Colors.blue;
      case 'forest':
      case 'park':
        return Colors.green;
      case 'directions_boat':
      case 'boat':
        return Colors.teal;
      case 'landscape':
      case 'mountain':
        return Colors.red;
      default:
        return ToursTheme.primary;
    }
  }

  double _getLinkedToursProgress(int toursCount) {
    return (toursCount / 20.0).clamp(0.0, 1.0);
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ToursTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
          border: Border.all(color: ToursTheme.outlineVariant, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: ToursTheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: ToursTheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoriesViewModelProvider);
    final selectedFilter = state.selectedFilter;

    // Calculate metrics
    final totalCategories = state.allCategories.length;
    final activeCategories = state.allCategories
        .where((cat) => cat.status.toLowerCase() == 'active')
        .length;
    final inactiveCategories = totalCategories - activeCategories;

    int totalLinkedTours = 0;
    CategoryModel? topCategory;
    int maxTours = -1;

    for (final cat in state.allCategories) {
      totalLinkedTours += cat.toursCount;
      if (cat.toursCount > maxTours) {
        maxTours = cat.toursCount;
        topCategory = cat;
      }
    }

    final topCategoryName = topCategory != null
        ? topCategory.title
        : 'Chưa xác định';

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ToursTheme.background,
        colorScheme: const ColorScheme.dark(
          primary: ToursTheme.primary,
          secondary: ToursTheme.secondary,
          surface: ToursTheme.surface,
        ),
      ),
      child: AdminLayout(
        currentMenu: 'Categories',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header + Breadcrumbs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Kho lưu trữ',
                              style: ToursTheme.textLabel.copyWith(
                                color: ToursTheme.onSurfaceVariant.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.chevron_right,
                              color: ToursTheme.onSurfaceVariant,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Danh mục',
                              style: TextStyle(
                                color: ToursTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Quản Lý Danh Mục',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tạo và cấu hình các danh mục trải nghiệm du lịch cao cấp.',
                          style: TextStyle(
                            color: ToursTheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ToursTheme.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ToursTheme.radiusLg,
                          ),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () => context.go('/admin/categories/create'),
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      label: const Text(
                        'Thêm Danh Mục Mới',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 4 Stat Cards Row
                Row(
                  children: [
                    _buildStatCard(
                      title: 'TỔNG DANH MỤC',
                      value: '$totalCategories',
                      subtitle: 'Đã tạo trong hệ thống',
                      icon: Icons.category,
                      color: ToursTheme.primary,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      title: 'TOUR LIÊN KẾT',
                      value: '$totalLinkedTours',
                      subtitle: 'Đang được khai thác',
                      icon: Icons.explore_outlined,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      title: 'NỔI BẬT NHẤT',
                      value: topCategoryName,
                      subtitle: 'Sở hữu nhiều tour nhất',
                      icon: Icons.star_outline,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      title: 'LƯU TRỮ / NGƯNG',
                      value: '$inactiveCategories',
                      subtitle: 'Đang tạm dừng hoạt động',
                      icon: Icons.archive_outlined,
                      color: ToursTheme.danger,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Search & Filter Panel
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ToursTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
                    border: Border.all(
                      color: ToursTheme.outlineVariant,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Search Input
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: ToursTheme.surface,
                            borderRadius: BorderRadius.circular(
                              ToursTheme.radiusLg,
                            ),
                            border: Border.all(
                              color: ToursTheme.outlineVariant,
                              width: 0.5,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText:
                                  'Tìm kiếm danh mục, tên ngắn hoặc mô tả...',
                              hintStyle: TextStyle(
                                color: ToursTheme.onSurfaceVariant,
                                fontSize: 13,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 20,
                                color: ToursTheme.onSurfaceVariant,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Filter Status
                      Container(
                        height: 44,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: ToursTheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(
                            ToursTheme.radiusLg,
                          ),
                          border: Border.all(
                            color: ToursTheme.outlineVariant,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildFilterBtn('all', 'Tất cả', selectedFilter),
                            _buildFilterBtn(
                              'active',
                              'Hoạt động',
                              selectedFilter,
                            ),
                            _buildFilterBtn(
                              'inactive',
                              'Ngưng hoạt động',
                              selectedFilter,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Table Content
                if (state.isLoading && state.allCategories.isEmpty)
                  _buildSkeletonLoader()
                else if (state.filteredCategories.isEmpty)
                  _buildEmptyState()
                else ...[
                  _buildCategoryTable(state.filteredCategories),
                  const SizedBox(height: 16),
                  if (!state.isLoading && state.filteredCategories.isNotEmpty)
                    _buildPaginationFooter(state),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBtn(String value, String label, String currentFilter) {
    final isSelected = value == currentFilter;
    return GestureDetector(
      onTap: () {
        ref.read(categoriesViewModelProvider.notifier).filterCategories(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ToursTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(ToursTheme.radiusLg - 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : ToursTheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTable(List<CategoryModel> categories) {
    return Container(
      decoration: BoxDecoration(
        color: ToursTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
        border: Border.all(color: ToursTheme.outlineVariant, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Table Header
          Container(
            color: ToursTheme.surfaceContainerHigh,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'TÊN DANH MỤC',
                    style: TextStyle(
                      color: ToursTheme.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'ICON / CHỦ ĐỀ',
                    style: TextStyle(
                      color: ToursTheme.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'TOUR LIÊN KẾT',
                    style: TextStyle(
                      color: ToursTheme.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'TRẠNG THÁI',
                    style: TextStyle(
                      color: ToursTheme.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'THAO TÁC',
                      style: TextStyle(
                        color: ToursTheme.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table Body Rows
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isEven = index % 2 == 0;
              final statusActive = cat.status.toLowerCase() == 'active';
              final themeColor = _getThemeColor(cat.icon);
              final toursCount = cat.toursCount;
              final progress = _getLinkedToursProgress(toursCount);

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isEven
                      ? Colors.transparent
                      : ToursTheme.surfaceContainerLow.withValues(alpha: 0.3),
                  border: const Border(
                    bottom: BorderSide(
                      color: ToursTheme.outlineVariant,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Column 1: Category Name with square Thumbnail + Title & Subtitle Description (flex = 4)
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: ToursTheme.surface,
                              borderRadius: BorderRadius.circular(
                                ToursTheme.radiusDefault,
                              ),
                              border: Border.all(
                                color: ToursTheme.outlineVariant,
                                width: 0.8,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child:
                                cat.imageUrl != null &&
                                    cat.imageUrl!.startsWith('http')
                                ? Image.network(
                                    cat.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (
                                          context,
                                          error,
                                          stackTrace,
                                        ) => Container(
                                          color:
                                              ToursTheme.surfaceContainerHigh,
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.image_not_supported_outlined,
                                            color: ToursTheme.onSurfaceVariant,
                                            size: 20,
                                          ),
                                        ),
                                  )
                                : const Icon(
                                    Icons.category_outlined,
                                    color: ToursTheme.primary,
                                    size: 20,
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cat.description ?? 'Chưa có mô tả chi tiết.',
                                  style: TextStyle(
                                    color: ToursTheme.onSurfaceVariant
                                        .withValues(alpha: 0.8),
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Column 2: Circular colored badge for Icon / Theme (flex = 2)
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: themeColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: themeColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            _getIconData(cat.icon),
                            color: themeColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ),

                    // Column 3: Linked Tours progress bar and text (flex = 3)
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$toursCount Tours',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: TextStyle(
                                    color: ToursTheme.onSurfaceVariant
                                        .withValues(alpha: 0.8),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: SizedBox(
                                height: 4,
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor:
                                      ToursTheme.surfaceContainerHigh,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    themeColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Column 4: Switch toggle for status (flex = 2)
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Switch(
                          value: statusActive,
                          activeThumbColor: ToursTheme.primary,
                          activeTrackColor: ToursTheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          inactiveThumbColor: ToursTheme.onSurfaceVariant,
                          inactiveTrackColor: ToursTheme.surfaceContainerHigh,
                          onChanged: (bool value) async {
                            final newStatus = value ? 'active' : 'inactive';
                            final success = await ref
                                .read(categoriesViewModelProvider.notifier)
                                .updateCategory(
                                  id: cat.id!,
                                  title: cat.title,
                                  shortName: cat.shortName,
                                  description: cat.description,
                                  icon: cat.icon,
                                  imageUrl: cat.imageUrl,
                                  status: newStatus,
                                  createdAt: cat.createdAt,
                                );
                            if (mounted && success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value
                                        ? 'Đã kích hoạt danh mục "${cat.title}"!'
                                        : 'Đã tạm ngưng danh mục "${cat.title}"!',
                                  ),
                                  backgroundColor: value
                                      ? ToursTheme.success
                                      : ToursTheme.danger,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    // Column 5: Action buttons (flex = 2)
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () =>
                                context.go('/admin/categories/edit/${cat.id}'),
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: ToursTheme.onSurfaceVariant,
                            ),
                            tooltip: 'Chỉnh sửa',
                          ),
                          IconButton(
                            onPressed: () => _deleteCategory(cat),
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: ToursTheme.danger,
                            ),
                            tooltip: 'Xóa',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64),
      decoration: BoxDecoration(
        color: ToursTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
        border: Border.all(color: ToursTheme.outlineVariant, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: ToursTheme.outline),
          const SizedBox(height: 16),
          const Text(
            'Không tìm thấy danh mục nào',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy thử thêm mới một danh mục hoặc thay đổi bộ lọc.',
            style: TextStyle(
              color: ToursTheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Container(
      decoration: BoxDecoration(
        color: ToursTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
        border: Border.all(color: ToursTheme.outlineVariant, width: 1),
      ),
      child: const Column(
        children: [
          _TableHeaderSkeleton(),
          _RowSkeleton(),
          _RowSkeleton(),
          _RowSkeleton(),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter(CategoriesState state) {
    final startIdx = (state.currentPage - 1) * state.itemsPerPage + 1;
    final endIdx = (startIdx + state.filteredCategories.length - 1).clamp(
      0,
      state.totalCount,
    );
    final totalPages = (state.totalCount / state.itemsPerPage).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hiển thị $startIdx-$endIdx trên tổng số ${state.totalCount} danh mục',
            style: const TextStyle(
              color: ToursTheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              // Previous Page Button
              IconButton(
                onPressed: state.currentPage > 1
                    ? () => ref
                          .read(categoriesViewModelProvider.notifier)
                          .changePage(state.currentPage - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
                    side: const BorderSide(color: ToursTheme.outlineVariant),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Page Numbers List
              Row(
                children: List.generate(totalPages, (idx) {
                  final pageNum = idx + 1;
                  final isCurrent = pageNum == state.currentPage;
                  return GestureDetector(
                    onTap: () => ref
                        .read(categoriesViewModelProvider.notifier)
                        .changePage(pageNum),
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? ToursTheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          ToursTheme.radiusLg,
                        ),
                        border: isCurrent
                            ? null
                            : Border.all(color: ToursTheme.outlineVariant),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$pageNum',
                        style: TextStyle(
                          color: isCurrent ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),
              // Next Page Button
              IconButton(
                onPressed: state.currentPage < totalPages
                    ? () => ref
                          .read(categoriesViewModelProvider.notifier)
                          .changePage(state.currentPage + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
                    side: const BorderSide(color: ToursTheme.outlineVariant),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableHeaderSkeleton extends StatelessWidget {
  const _TableHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ToursTheme.surfaceContainerHigh,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: const Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'TÊN DANH MỤC',
              style: TextStyle(
                color: ToursTheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'ICON / CHỦ ĐỀ',
              style: TextStyle(
                color: ToursTheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'TOUR LIÊN KẾT',
              style: TextStyle(
                color: ToursTheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'TRẠNG THÁI',
              style: TextStyle(
                color: ToursTheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'THAO TÁC',
                style: TextStyle(
                  color: ToursTheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ToursTheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: ToursTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 16,
                        decoration: BoxDecoration(
                          color: ToursTheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: ToursTheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: ToursTheme.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 14,
                  decoration: BoxDecoration(
                    color: ToursTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ToursTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 44,
                height: 24,
                decoration: BoxDecoration(
                  color: ToursTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: ToursTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: ToursTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(4),
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
