import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/tour_model.dart';
import '../../presentation/view_models/tours_viewmodel.dart';
import '../theme/tours_theme.dart';

class TourDataTable extends ConsumerWidget {
  const TourDataTable({
    required this.onEdit,
    required this.onView,
    super.key,
  });

  final void Function(TourModel tour) onEdit;
  final void Function(TourModel tour) onView;

  String _getTourImage(TourModel tour) {
    if (tour.firestoreId != null && tour.firestoreId!.startsWith('http')) {
      return tour.firestoreId!;
    }
    final title = tour.title.toLowerCase();
    if (title.contains('serengeti') || title.contains('safari')) {
      return 'https://lh3.googleusercontent.com/aida-public/AB6AXuDrkzu1ntLg_DVqpTSm-dKbhdaOkhm7UsJm1YBNJT3gNK9xE3V1wpw3e3hinNwybWJeqG7JKrGpdl3PnVwuG1tFIEEq5p0q9VBPtnJQhhGQvMYMQ-OGalhAwPXJLAiS9Cc4gZwKCOIbv8yUdSdUdZ2MgHC6cT_SCHHdMoUYFZvcD25w_Sw1aAOAY6k7GOR96SCjAlLhGPP0dg1-sk2anXctVlKtL1GD08JvKdSc-tdXgPucVt4Ep_QI';
    } else if (title.contains('tokyo') || title.contains('japan')) {
      return 'https://lh3.googleusercontent.com/aida-public/AB6AXuAjQTjpRnMxZBYHKFfiC2_XQxzIeN-iBVYVlL7M1pV1krFXmo9BhP84ZTqklLoLVmnH1dZS0HcWEE0yKtUHpQXqixua0WTBsgFDgQO7e6NerDA8AGHzykkOeXNw4N2Vj6Cgb7-ZxZxcrqt4XfJvmRZEev-G3sv8vgz5sMey6qCklceRAx8P1NszeHkvY_xNGvgRcH2xOu0K4atmERI9jMhM_6sCB2evWeOEsaBeP3DTuqGm-qWaumGW';
    } else if (title.contains('aurora') || title.contains('finland') || title.contains('arctic')) {
      return 'https://lh3.googleusercontent.com/aida-public/AB6AXuDv5UN1b31uqqyyMW1QvgCduEmsHZfRmtYgHP1jsOeXLkJXJpnziXUGtTHZY2YMqsxdl7aOz-MGII5EVbcbk3jwfYChKcaSS1N9Q6Zbr04LKc2gXKqbW_FmhftYrBV_PPoek1Iw-sRBsFNC78deWV74I0F9ohgK1fR5Jhu24KLhwoR2XTuUR4NPxHetcZe0szNzvuXIxcC2W9aabxBKzh7KE8FAiDLuW9TxVKGDXIyPzXbgAM7kTv5P';
    } else if (title.contains('yacht') || title.contains('riviera') || title.contains('france') || title.contains('charter')) {
      return 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbCsCGiNyykRI0HJVBkdydcDVNtr49YJUINXwekmangx4BmVdzj1cEcAHfFFKNFYkA4LvZomQJDQIHsS_j7Q2VkM4kWs_gCueV0rkk2Cv7jPRxNBPEsvpxl0PVhoHLLiVTuIxGAEOkHMJvVnfqaFGoinJQtg9i3_YeuK_aeBwujQ11EB-9GK9UAT8yJlgvawJX_x7MuqwsHEuQ7H69fXC5_-8B1tRFQCfIhaBE2yLFdYQZQAgL66IU';
    }
    return 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600&auto=format&fit=crop';
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, TourModel tour) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ToursTheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ToursTheme.radiusXl)),
        title: const Text(
          'Xác nhận xóa',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa tour "${tour.title}" không? Hành động này không thể hoàn tác.',
          style: const TextStyle(color: ToursTheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy', style: TextStyle(color: ToursTheme.onSurfaceVariant)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ToursTheme.danger,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ToursTheme.radiusLg)),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await ref.read(toursViewModelProvider.notifier).deleteTour(tour.id!);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Xóa tour thành công!' : 'Có lỗi xảy ra khi xóa tour!'),
                    backgroundColor: success ? ToursTheme.success : ToursTheme.danger,
                  ),
                );
              }
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(toursViewModelProvider);
    final priceFormat = NumberFormat('#,###', 'en_US');

    if (state.isLoading && state.allTours.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: ToursTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
          border: Border.all(color: ToursTheme.outlineVariant, width: 1),
        ),
        child: const Column(
          children: [
            _TableHeader(),
            _SkeletonRow(),
            _SkeletonRow(),
            _SkeletonRow(),
            _SkeletonRow(),
          ],
        ),
      );
    }

    if (state.filteredTours.isEmpty) {
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
            Icon(Icons.explore_outlined, size: 64, color: ToursTheme.outline),
            const SizedBox(height: 16),
            const Text(
              'Không tìm thấy tour nào',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy thử thêm tour mới hoặc thay đổi bộ lọc trạng thái.',
              style: TextStyle(color: ToursTheme.onSurfaceVariant.withOpacity(0.7), fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: ToursTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
        border: Border.all(color: ToursTheme.outlineVariant, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _TableHeader(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.filteredTours.length,
                itemBuilder: (context, index) {
                  final tour = state.filteredTours[index];
                  final isEven = index % 2 == 0;
                  return _TourRow(
                    tour: tour,
                    isEven: isEven,
                    imageUrl: _getTourImage(tour),
                    priceString: '${priceFormat.format(tour.price).replaceAll(',', '.')} đ',
                    onView: () => onView(tour),
                    onEdit: () => onEdit(tour),
                    onDelete: () => _confirmDelete(context, ref, tour),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: ToursTheme.surfaceContainerHigh,
      child: const Row(
        children: [
          SizedBox(width: 80, child: Text('ẢNH NỀN', style: ToursTheme.textLabel)),
          SizedBox(width: 16),
          Expanded(child: Text('TÊN TOUR', style: ToursTheme.textLabel)),
          SizedBox(width: 16),
          SizedBox(width: 150, child: Text('DANH MỤC', style: ToursTheme.textLabel)),
          SizedBox(width: 16),
          SizedBox(width: 120, child: Text('GIÁ (VNĐ)', style: ToursTheme.textLabel)),
          SizedBox(width: 16),
          SizedBox(width: 120, child: Text('TRẠNG THÁI', style: ToursTheme.textLabel, textAlign: TextAlign.center)),
          SizedBox(width: 16),
          SizedBox(width: 130, child: Text('THAO TÁC', style: ToursTheme.textLabel, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class _TourRow extends StatelessWidget {
  const _TourRow({
    required this.tour,
    required this.isEven,
    required this.imageUrl,
    required this.priceString,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final TourModel tour;
  final bool isEven;
  final String imageUrl;
  final String priceString;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
    Color statusBgColor;
    Color statusTextColor;
    bool hasPulse = false;

    switch (tour.status.toLowerCase()) {
      case 'active':
        statusBgColor = const Color(0xFF10B981).withOpacity(0.1);
        statusTextColor = const Color(0xFF34D399);
        hasPulse = true;
        break;
      case 'draft':
        statusBgColor = Colors.blue.withOpacity(0.1);
        statusTextColor = Colors.blue[400]!;
        break;
      case 'inactive':
      default:
        statusBgColor = Colors.grey.withOpacity(0.1);
        statusTextColor = Colors.grey[400]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isEven ? Colors.transparent : ToursTheme.surfaceContainerLow.withOpacity(0.3),
        border: const Border(bottom: BorderSide(color: ToursTheme.outlineVariant, width: 0.5)),
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 80,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
              border: Border.all(color: ToursTheme.outlineVariant, width: 0.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: ToursTheme.surfaceContainerHighest),
              errorWidget: (context, url, error) => Icon(Icons.broken_image, color: ToursTheme.outline),
            ),
          ),
          const SizedBox(width: 16),
          // Name & Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(tour.description ?? '').length > 30 ? (tour.description ?? '').substring(0, 30) : (tour.description ?? '')} • ${tour.durationDays} Ngày',
                  style: TextStyle(color: ToursTheme.onSurfaceVariant.withOpacity(0.7), fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Category
          SizedBox(
            width: 150,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ToursTheme.secondaryContainer,
                borderRadius: BorderRadius.circular(ToursTheme.radiusDefault),
              ),
              child: Text(
                _getCategoryName(tour.categoryId?.toString()),
                style: const TextStyle(
                  color: ToursTheme.onSecondaryContainer,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Price
          SizedBox(
            width: 120,
            child: Text(
              priceString,
              style: const TextStyle(color: ToursTheme.primary, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          const SizedBox(width: 16),
          // Status
          SizedBox(
            width: 120,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(ToursTheme.radiusFull),
                  border: Border.all(color: statusTextColor.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasPulse)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusTextColor,
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusTextColor.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        tour.status.toLowerCase() == 'active'
                            ? 'Hoạt động'
                            : tour.status.toLowerCase() == 'draft'
                                ? 'Nháp'
                                : 'Ngưng hoạt động',
                        style: TextStyle(color: statusTextColor, fontSize: 10, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Actions
          SizedBox(
            width: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onView,
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  color: ToursTheme.onSurfaceVariant,
                  hoverColor: ToursTheme.primary.withOpacity(0.1),
                  tooltip: 'Xem chi tiết',
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  color: ToursTheme.onSurfaceVariant,
                  hoverColor: ToursTheme.primary.withOpacity(0.1),
                  tooltip: 'Sửa tour',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  color: ToursTheme.onSurfaceVariant,
                  hoverColor: ToursTheme.danger.withOpacity(0.1),
                  tooltip: 'Xóa tour',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonRow extends StatefulWidget {
  const _SkeletonRow();

  @override
  State<_SkeletonRow> createState() => _SkeletonRowState();
}

class _SkeletonRowState extends State<_SkeletonRow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.3,
      upperBound: 0.7,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: ToursTheme.outlineVariant, width: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 48,
              decoration: BoxDecoration(
                color: ToursTheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 180, height: 16, color: ToursTheme.surfaceContainerHighest),
                  const SizedBox(height: 6),
                  Container(width: 120, height: 12, color: ToursTheme.surfaceContainerHighest),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(width: 100, height: 24, color: ToursTheme.surfaceContainerHighest),
            const SizedBox(width: 16),
            Container(width: 80, height: 16, color: ToursTheme.surfaceContainerHighest),
            const SizedBox(width: 16),
            Container(
              width: 100,
              height: 24,
              decoration: BoxDecoration(
                color: ToursTheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(ToursTheme.radiusFull),
              ),
            ),
            const SizedBox(width: 16),
            Container(width: 120, height: 32, color: ToursTheme.surfaceContainerHighest),
          ],
        ),
      ),
    );
  }
}
