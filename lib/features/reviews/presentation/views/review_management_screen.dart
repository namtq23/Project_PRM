import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../tours/presentation/theme/tours_theme.dart';
import '../../../tours/presentation/widgets/admin_layout.dart';
import '../../models/review_model.dart';
import '../view_models/reviews_viewmodel.dart';

class ReviewManagementScreen extends ConsumerStatefulWidget {
  const ReviewManagementScreen({super.key});

  @override
  ConsumerState<ReviewManagementScreen> createState() => _ReviewManagementScreenState();
}

class _ReviewManagementScreenState extends ConsumerState<ReviewManagementScreen> {
  String _selectedRating = 'All Ratings';
  String _selectedTour = 'All Tours';

  @override
  void initState() {
    super.initState();
    // Safe trigger to load reviews after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewsViewModelProvider.notifier).loadReviews();
    });
  }

  void _rejectReview(ReviewModel review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ToursTheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ToursTheme.radiusXl)),
        title: const Text(
          'Xác nhận từ chối / xóa',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có chắc chắn muốn từ chối và xóa vĩnh viễn đánh giá của "${review.userName ?? 'Ẩn danh'}"? Thao tác này không thể hoàn tác.',
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
              final success = await ref
                  .read(reviewsViewModelProvider.notifier)
                  .deleteReview(review.reviewId!);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Đã từ chối và xóa đánh giá thành công!' : 'Có lỗi xảy ra khi xóa đánh giá!'),
                    backgroundColor: success ? ToursTheme.success : ToursTheme.danger,
                  ),
                );
              }
            },
            child: const Text(
              'Từ chối / Xóa',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: ToursTheme.surfaceContainerLow.withOpacity(0.6),
        borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
        border: Border.all(color: ToursTheme.outlineVariant.withOpacity(0.5), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: ToursTheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewsViewModelProvider);

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
        currentMenu: 'Reviews',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Duyệt Đánh Giá',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Quản lý và kiểm duyệt đánh giá của khách hàng. Giữ vững uy tín và chất lượng của Voyage.',
                            style: TextStyle(
                              color: ToursTheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        _buildStatCard(
                          title: 'CHỜ DUYỆT',
                          value: '${state.pendingCount}',
                          icon: Icons.pending_actions_outlined,
                          color: ToursTheme.primary,
                        ),
                        const SizedBox(width: 16),
                        _buildStatCard(
                          title: 'CẢNH BÁO',
                          value: '${state.flaggedCount}',
                          icon: Icons.report_problem_outlined,
                          color: ToursTheme.danger,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Filters Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ToursTheme.surfaceContainerLow.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
                    border: Border.all(color: ToursTheme.outlineVariant.withOpacity(0.5), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, color: ToursTheme.onSurfaceVariant, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'BỘ LỌC:',
                        style: TextStyle(
                          color: ToursTheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Rating Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: ToursTheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedRating,
                            dropdownColor: ToursTheme.surfaceContainerHighest,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            icon: const Icon(Icons.keyboard_arrow_down, color: ToursTheme.onSurfaceVariant),
                            items: const [
                              DropdownMenuItem(value: 'All Ratings', child: Text('Tất cả sao')),
                              DropdownMenuItem(value: '5 Stars', child: Text('5 Sao')),
                              DropdownMenuItem(value: '4 Stars', child: Text('4 Sao')),
                              DropdownMenuItem(value: '3 Stars & Below', child: Text('3 Sao trở xuống')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedRating = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Tour Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: ToursTheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedTour,
                            dropdownColor: ToursTheme.surfaceContainerHighest,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            icon: const Icon(Icons.keyboard_arrow_down, color: ToursTheme.onSurfaceVariant),
                            items: [
                              const DropdownMenuItem(value: 'All Tours', child: Text('Tất cả Tours')),
                              ...state.tourTitles.map(
                                (title) => DropdownMenuItem(value: title, child: Text(title)),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedTour = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Buttons
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedRating = 'All Ratings';
                            _selectedTour = 'All Tours';
                          });
                          ref.read(reviewsViewModelProvider.notifier).clearFilters();
                        },
                        child: const Text(
                          'Xóa Bộ Lọc',
                          style: TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ToursTheme.primary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ToursTheme.radiusLg)),
                        ),
                        onPressed: () {
                          ref.read(reviewsViewModelProvider.notifier).applyFilters(
                            ratingFilter: _selectedRating,
                            tourFilter: _selectedTour,
                          );
                        },
                        child: const Text(
                          'Áp Dụng',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Review Cards List with Loader constraints
                if (state.isLoading)
                  const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(color: ToursTheme.primary),
                    ),
                  )
                else if (state.filteredReviews.isEmpty || state.errorMessage != null)
                  _buildEmptyState(state.errorMessage)
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = state.filteredReviews[index];
                      return _buildReviewBentoCard(review);
                    },
                  ),

                const SizedBox(height: 16),
                // Pagination Footer
                if (!state.isLoading && state.filteredReviews.isNotEmpty)
                  _buildPaginationFooter(state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewBentoCard(ReviewModel review) {
    final isFlagged = review.status.toLowerCase() == 'flagged';
    
    // Format creation date
    String dateStr = 'Chưa xác định';
    try {
      dateStr = DateFormat('dd/MM/yyyy').format(review.createdAt.toLocal());
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isFlagged 
            ? ToursTheme.danger.withOpacity(0.05) 
            : ToursTheme.surfaceContainerLow.withOpacity(0.6),
        borderRadius: BorderRadius.circular(ToursTheme.radiusXl),
        border: Border.all(
          color: isFlagged 
              ? ToursTheme.danger.withOpacity(0.2) 
              : ToursTheme.outlineVariant.withOpacity(0.3), 
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left side: Wide Tour image + overlay title badge
            SizedBox(
              width: 260,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  review.tourImageUrl != null && review.tourImageUrl!.startsWith('http')
                      ? Image.network(
                          review.tourImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: ToursTheme.surface,
                            child: const Icon(Icons.broken_image, color: ToursTheme.onSurfaceVariant),
                          ),
                        )
                      : Container(
                          color: ToursTheme.surface,
                          child: const Icon(Icons.explore_outlined, color: ToursTheme.primary, size: 36),
                        ),
                  // Dark overlay gradient
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Tour title badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ToursTheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(ToursTheme.radiusDefault),
                          border: Border.all(color: ToursTheme.primary.withOpacity(0.3), width: 0.8),
                        ),
                        child: Text(
                          review.tourTitle ?? 'Chưa xác định',
                          style: const TextStyle(
                            color: ToursTheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Right side: Review content details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Details Header & Stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isFlagged ? ToursTheme.danger : ToursTheme.outlineVariant, 
                                  width: 1.5,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: review.userAvatarUrl != null && review.userAvatarUrl!.startsWith('http')
                                  ? Image.network(
                                      review.userAvatarUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(
                                        color: ToursTheme.surfaceContainerHigh,
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.person, color: ToursTheme.onSurfaceVariant),
                                      ),
                                    )
                                  : isFlagged
                                      ? const Icon(Icons.person_off, color: ToursTheme.danger, size: 18)
                                      : const Icon(Icons.person, color: ToursTheme.onSurfaceVariant),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isFlagged ? 'Người dùng ẩn danh' : (review.userName ?? 'Thành viên'),
                                  style: TextStyle(
                                    color: isFlagged ? Colors.white.withOpacity(0.6) : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month, size: 12, color: ToursTheme.onSurfaceVariant),
                                    const SizedBox(width: 4),
                                    Text(
                                      dateStr,
                                      style: const TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 11),
                                    ),
                                    if (isFlagged) ...[
                                      const SizedBox(width: 8),
                                      const Icon(Icons.warning, size: 12, color: ToursTheme.danger),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Có dấu hiệu vi phạm',
                                        style: TextStyle(color: ToursTheme.danger, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Rating stars
                        Row(
                          children: List.generate(5, (index) {
                            final isFilled = index < review.rating;
                            return Icon(
                              isFilled ? Icons.star : Icons.star_border,
                              color: isFilled ? Colors.amber : ToursTheme.onSurfaceVariant,
                              size: 18,
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quote review comment (with thick left border line)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: isFlagged 
                                ? ToursTheme.danger.withOpacity(0.4) 
                                : ToursTheme.primary.withOpacity(0.3), 
                            width: 2.5,
                          ),
                        ),
                      ),
                      child: Text(
                        '"${review.comment ?? 'Không có bình luận.'}"',
                        style: TextStyle(
                          color: isFlagged 
                              ? ToursTheme.onSurface.withOpacity(0.5) 
                              : ToursTheme.onSurface,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Footer badge nhãn & actions buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Badges
                        Row(
                          children: [
                            if (isFlagged)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: ToursTheme.danger.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'SPAM / CẢNH BÁO',
                                  style: TextStyle(color: ToursTheme.danger, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                              )
                            else ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: ToursTheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'VERIFIED BOOKING',
                                  style: TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: ToursTheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  review.rating >= 5 ? 'FIRST CLASS' : 'SOLO TRAVELER',
                                  style: const TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                              ),
                            ]
                          ],
                        ),
                        // Action buttons
                        Row(
                          children: [
                            // Reject / delete action
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: ToursTheme.danger,
                                side: BorderSide(color: ToursTheme.danger.withOpacity(0.3)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ToursTheme.radiusLg)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              onPressed: () => _rejectReview(review),
                              icon: Icon(isFlagged ? Icons.delete_forever : Icons.flag_outlined, size: 14),
                              label: Text(
                                isFlagged ? 'Xác Nhận Xóa' : 'Từ Chối / Xóa',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Approve / restore action
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isFlagged ? ToursTheme.surfaceContainerHighest : ToursTheme.primary,
                                foregroundColor: isFlagged ? Colors.white : Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ToursTheme.radiusLg)),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                elevation: 2,
                              ),
                              onPressed: () async {
                                final success = await ref
                                    .read(reviewsViewModelProvider.notifier)
                                    .updateReviewStatus(review.reviewId!, 'approved');
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(success ? 'Duyệt đánh giá thành công!' : 'Có lỗi xảy ra!'),
                                      backgroundColor: success ? ToursTheme.success : ToursTheme.danger,
                                    ),
                                  );
                                }
                              },
                              icon: Icon(isFlagged ? Icons.restore : Icons.check_circle_outline, size: 14),
                              label: Text(
                                isFlagged ? 'Khôi Phục' : 'Phê Duyệt',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(ReviewsState state) {
    final startIdx = (state.currentPage - 1) * state.pageSize + 1;
    final endIdx = (startIdx + state.filteredReviews.length - 1).clamp(0, state.totalCount);
    final totalPages = (state.totalCount / state.pageSize).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hiển thị $startIdx-$endIdx trong tổng số ${state.totalCount} đánh giá',
            style: const TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 12),
          ),
          Row(
            children: [
              // Previous Page Button
              IconButton(
                onPressed: state.currentPage > 1
                    ? () => ref.read(reviewsViewModelProvider.notifier).changePage(state.currentPage - 1)
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
                    onTap: () => ref.read(reviewsViewModelProvider.notifier).changePage(pageNum),
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isCurrent ? ToursTheme.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
                        border: isCurrent ? null : Border.all(color: ToursTheme.outlineVariant),
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
                    ? () => ref.read(reviewsViewModelProvider.notifier).changePage(state.currentPage + 1)
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

  Widget _buildEmptyState(String? errorMessage) {
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
          Icon(
            errorMessage != null ? Icons.error_outline : Icons.rate_review_outlined, 
            size: 64, 
            color: errorMessage != null ? ToursTheme.danger : ToursTheme.outline
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage != null ? 'Lỗi tải dữ liệu' : 'Không tìm thấy đánh giá nào',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              errorMessage ?? 'Hãy thử thay đổi tiêu chí bộ lọc của bạn.',
              style: const TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
