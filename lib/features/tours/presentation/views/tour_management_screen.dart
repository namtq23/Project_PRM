import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/tour_model.dart';
import '../../models/tours_state.dart';
import '../../presentation/view_models/tours_viewmodel.dart';
import '../theme/tours_theme.dart';
import '../widgets/tour_data_table.dart';
import '../widgets/tour_filter_chips.dart';
import '../widgets/tour_insight_cards.dart';
import 'create_tour_screen.dart';
import 'edit_tour_screen.dart';
import '../widgets/admin_layout.dart';

class TourManagementScreen extends ConsumerStatefulWidget {
  const TourManagementScreen({super.key});

  @override
  ConsumerState<TourManagementScreen> createState() =>
      _TourManagementScreenState();
}

class _TourManagementScreenState extends ConsumerState<TourManagementScreen> {
  bool _isGridView = false;

  void _showAddEditDialog([TourModel? tour]) {
    if (tour != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditTourScreen(tour: tour)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateTourScreen()),
      );
    }
  }

  String _getCategoryName(String? categoryId) {
    switch (categoryId) {
      case '1':
      case 'Thám Hiểm Sang Trọng':
      case 'Luxury Expedition':
        return 'Thám Hiểm Sang Trọng';
      case '2':
      case 'Thành Thị Thượng Lưu':
      case 'Urban Elite':
        return 'Thành Thị Thượng Lưu';
      case 'Nordic Luxury':
        return 'Bắc Âu Xa Hoa';
      case 'Nautical Elite':
        return 'Hải Trình Thượng Lưu';
      default:
        return categoryId ?? 'Chưa phân loại';
    }
  }

  void _showViewDetailsDialog(TourModel tour) {
    final priceFormat = NumberFormat('#,###', 'en_US');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ToursTheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Chi Tiết Tour',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: ToursTheme.onSurfaceVariant),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tour.firestoreId != null &&
                    tour.firestoreId!.startsWith('http'))
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
                      image: DecorationImage(
                        image: NetworkImage(tour.firestoreId!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                _DetailRow(label: 'Tên tour', value: tour.title),
                _DetailRow(
                  label: 'Thời lượng',
                  value: '${tour.durationDays} Ngày',
                ),
                _DetailRow(
                  label: 'Danh mục',
                  value: _getCategoryName(tour.categoryId?.toString()),
                ),
                _DetailRow(
                  label: 'Giá (VNĐ)',
                  value:
                      '${priceFormat.format(tour.price).replaceAll(',', '.')} đ',
                ),
                _DetailRow(
                  label: 'Trạng thái',
                  value: tour.status.toLowerCase() == 'active'
                      ? 'Hoạt động'
                      : tour.status.toLowerCase() == 'draft'
                      ? 'Nháp'
                      : 'Ngưng hoạt động',
                ),
                _DetailRow(label: 'Mô tả', value: tour.description ?? ''),
                _DetailRow(
                  label: 'Ngày tạo',
                  value: tour.createdAt != null
                      ? tour.createdAt!.toLocal().toString().split('.').first
                      : '',
                ),
                _DetailRow(
                  label: 'Ngày cập nhật',
                  value: tour.updatedAt != null
                      ? tour.updatedAt!.toLocal().toString().split('.').first
                      : '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(toursViewModelProvider);

    final displayedTours = state.filteredTours;

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
        currentMenu: 'Tours',
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: ToursTheme.stackLg,
            vertical: ToursTheme.stackLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header breadcrumb + Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Kho hàng',
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
                              'Tours',
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
                          'Quản Lý Tour',
                          style: TextStyle(
                            color: ToursTheme.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Quản lý và điều hành các trải nghiệm du lịch cao cấp trên toàn cầu.',
                          style: TextStyle(
                            color: ToursTheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons (Create, List/Grid View)
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ToursTheme.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ToursTheme.radiusLg,
                            ),
                          ),
                        ),
                        onPressed: () => _showAddEditDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Thêm Tour Mới',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: ToursTheme.stackLg),

              // Search Bar + Filter Line
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ToursTheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
                  border: Border.all(color: ToursTheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) => ref
                            .read(toursViewModelProvider.notifier)
                            .searchTours(val),
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm tour, danh mục, hoặc mô tả...',
                          hintStyle: const TextStyle(
                            color: ToursTheme.onSurfaceVariant,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: ToursTheme.onSurfaceVariant,
                          ),
                          filled: true,
                          fillColor: ToursTheme.surfaceContainerLow,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: ToursTheme.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: ToursTheme.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: ToursTheme.primary,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: ToursTheme.stackMd),

              // Filter Chips
              const TourFilterChips(),
              const SizedBox(height: ToursTheme.stackLg),

              // Toggle List/Grid View Button Line
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KẾT QUẢ TÌM KIẾM (${displayedTours.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: ToursTheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(
                            ToursTheme.radiusLg,
                          ),
                          border: Border.all(color: ToursTheme.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            _ViewToggleBtn(
                              icon: Icons.view_list,
                              label: 'Dạng Danh Sách',
                              isSelected: !_isGridView,
                              onTap: () => setState(() => _isGridView = false),
                            ),
                            _ViewToggleBtn(
                              icon: Icons.grid_view,
                              label: 'Dạng Lưới',
                              isSelected: _isGridView,
                              onTap: () => setState(() => _isGridView = true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: ToursTheme.stackMd),

              // Tours Data Layout (List/Grid)
              if (_isGridView)
                _ToursGrid(
                  tours: displayedTours,
                  onView: _showViewDetailsDialog,
                  onEdit: _showAddEditDialog,
                )
              else
                TourDataTable(
                  onView: _showViewDetailsDialog,
                  onEdit: _showAddEditDialog,
                ),

              const SizedBox(height: 16),
              // Pagination Footer
              if (!state.isLoading && displayedTours.isNotEmpty)
                _buildPaginationFooter(state),

              const SizedBox(height: ToursTheme.stackLg),

              // Quick Insights Bento Grid
              const TourInsightCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(ToursState state) {
    final startIdx = (state.currentPage - 1) * state.itemsPerPage + 1;
    final endIdx = (startIdx + state.filteredTours.length - 1).clamp(
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
            'Hiển thị $startIdx-$endIdx trên tổng số ${state.totalCount} tours',
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
                          .read(toursViewModelProvider.notifier)
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
                        .read(toursViewModelProvider.notifier)
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
                          .read(toursViewModelProvider.notifier)
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

class _ViewToggleBtn extends StatelessWidget {
  const _ViewToggleBtn({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? ToursTheme.secondaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ToursTheme.radiusLg - 2),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : ToursTheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : ToursTheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: ToursTheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const Divider(
            color: ToursTheme.outlineVariant,
            height: 16,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}

class _ToursGrid extends StatelessWidget {
  const _ToursGrid({
    required this.tours,
    required this.onView,
    required this.onEdit,
  });

  final List<TourModel> tours;
  final void Function(TourModel tour) onView;
  final void Function(TourModel tour) onEdit;

  String _getTourImage(TourModel tour) {
    if (tour.firestoreId != null && tour.firestoreId!.startsWith('http')) {
      return tour.firestoreId!;
    }
    final title = tour.title.toLowerCase();
    if (title.contains('serengeti') || title.contains('safari')) {
      return 'https://lh3.googleusercontent.com/aida-public/AB6AXuDrkzu1ntLg_DVqpTSm-dKbhdaOkhm7UsJm1YBNJT3gNK9xE3V1wpw3e3hinNwybWJeqG7JKrGpdl3PnVwuG1tFIEEq5p0q9VBPtnJQhhGQvMYMQ-OGalhAwPXJLAiS9Cc4gZwKCOIbv8yUdSdUdZ2MgHC6cT_SCHHdMoUYFZvcD25w_Sw1aAOAY6k7GOR96SCjAlLhGPP0dg1-sk2anXctVlKtL1GD08JvKdSc-tdXgPucVt4Ep_QI';
    } else if (title.contains('tokyo') || title.contains('japan')) {
      return 'https://lh3.googleusercontent.com/aida-public/AB6AXuAjQTjpRnMxZBYHKFfiC2_XQxzIeN-iBVYVlL7M1pV1krFXmo9BhP84ZTqklLoLVmnH1dZS0HcWEE0yKtUHpQXqixua0WTBsgFDgQO7e6NerDA8AGHzykkOeXNw4N2Vj6Cgb7-ZxZxcrqt4XfJvmRZEev-G3sv8vgz5sMey6qCklceRAx8P1NszeHkvY_xNGvgRcH2xOu0K4atmERI9jMhM_6sCB2evWeOEsaBeP3DTuqGm-qWaumGW';
    } else if (title.contains('aurora') ||
        title.contains('finland') ||
        title.contains('arctic')) {
      return 'https://lh3.googleusercontent.com/aida-public/AB6AXuDv5UN1b31uqqyyMW1QvgCduEmsHZfRmtYgHP1jsOeXLkJXJpnziXUGtTHZY2YMqsxdl7aOz-MGII5EVbcbk3jwfYChKcaSS1N9Q6Zbr04LKc2gXKqbW_FmhftYrBV_PPoek1Iw-sRBsFNC78deWV74I0F9ohgK1fR5Jhu24KLhwoR2XTuUR4NPxHetcZe0szNzvuXIxcC2W9aabxBKzh7KE8FAiDLuW9TxVKGDXIyPzXbgAM7kTv5P';
    } else if (title.contains('yacht') ||
        title.contains('riviera') ||
        title.contains('france') ||
        title.contains('charter')) {
      return 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbCsCGiNyykRI0HJVBkdydcDVNtr49YJUINXwekmangx4BmVdzj1cEcAHfFFKNFYkA4LvZomQJDQIHsS_j7Q2VkM4kWs_gCueV0rkk2Cv7jPRxNBPEsvpxl0PVhoHLLiVTuIxGAEOkHMJvVnfqaFGoinJQtg9i3_YeuK_aeBwujQ11EB-9GK9UAT8yJlgvawJX_x7MuqwsHEuQ7H69fXC5_-8B1tRFQCfIhaBE2yLFdYQZQAgL66IU';
    }
    return 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600&auto=format&fit=crop';
  }

  String _getCategoryName(String? categoryId) {
    switch (categoryId) {
      case '1':
      case 'Thám Hiểm Sang Trọng':
      case 'Luxury Expedition':
        return 'Thám Hiểm Sang Trọng';
      case '2':
      case 'Thành Thị Thượng Lưu':
      case 'Urban Elite':
        return 'Thành Thị Thượng Lưu';
      case 'Nordic Luxury':
        return 'Bắc Âu Xa Hoa';
      case 'Nautical Elite':
        return 'Hải Trình Thượng Lưu';
      default:
        return categoryId ?? 'Chưa phân loại';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.center,
        child: const Text(
          'Không tìm thấy tour nào phù hợp.',
          style: TextStyle(color: ToursTheme.onSurfaceVariant),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        return Container(
          decoration: BoxDecoration(
            color: ToursTheme.surfaceContainer,
            borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
            border: Border.all(color: ToursTheme.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: ToursTheme.surfaceContainerHigh,
                  child: Image.network(
                    _getTourImage(tour),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: ToursTheme.surfaceContainerHigh,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 40,
                        color: ToursTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tour.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tour.durationDays} Ngày • ${_getCategoryName(tour.categoryId?.toString())}',
                      style: const TextStyle(
                        color: ToursTheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${NumberFormat('#,###', 'en_US').format(tour.price).replaceAll(',', '.')} đ',
                          style: const TextStyle(
                            color: ToursTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => onView(tour),
                              icon: const Icon(
                                Icons.visibility_outlined,
                                size: 16,
                                color: ToursTheme.onSurfaceVariant,
                              ),
                            ),
                            IconButton(
                              onPressed: () => onEdit(tour),
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: ToursTheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
