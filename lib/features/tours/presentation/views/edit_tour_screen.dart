import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/tour_model.dart';
import '../../presentation/view_models/tours_viewmodel.dart';
import '../theme/tours_theme.dart';
import '../widgets/admin_layout.dart';

class EditTourScreen extends ConsumerStatefulWidget {
  const EditTourScreen({required this.tour, super.key});
  final TourModel tour;

  @override
  ConsumerState<EditTourScreen> createState() => _EditTourScreenState();
}

class _EditTourScreenState extends ConsumerState<EditTourScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _durationCtrl;
  late TextEditingController _imageCtrl;

  String _status = 'active';
  String _category = '1';
  String _difficulty = 'Trung bình';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.tour;
    _titleCtrl = TextEditingController(text: t.title);
    _descCtrl = TextEditingController(text: t.description ?? '');
    _priceCtrl = TextEditingController(text: t.price.toStringAsFixed(0));
    _durationCtrl = TextEditingController(text: t.durationDays.toString());
    _imageCtrl = TextEditingController(text: t.firestoreId ?? '');

    _status = t.status;
    final catId = t.categoryId?.toString();
    if (catId == '1' ||
        catId == 'Thám Hiểm Sang Trọng' ||
        catId == 'Luxury Expedition') {
      _category = '1';
    } else if (catId == '2' ||
        catId == 'Thành Thị Thượng Lưu' ||
        catId == 'Urban Elite') {
      _category = '2';
    } else if (catId == 'Nordic Luxury' || catId == 'Bắc Âu Xa Hoa') {
      _category = 'Bắc Âu Xa Hoa';
    } else if (catId == 'Nautical Elite' || catId == 'Hải Trình Thượng Lưu') {
      _category = 'Hải Trình Thượng Lưu';
    } else {
      _category = '1';
    }

    if (t.durationDays <= 3) {
      _difficulty = 'Dễ';
    } else if (t.durationDays <= 7) {
      _difficulty = 'Trung bình';
    } else {
      _difficulty = 'Khó';
    }

    _imageCtrl.addListener(_onImageChanged);
  }

  void _onImageChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _imageCtrl.removeListener(_onImageChanged);
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _durationCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final title = _titleCtrl.text;
    final desc = _descCtrl.text;

    // Remove non-digit characters for formatted numeric inputs (e.g. 1.050.000.000 VNĐ)
    final priceCleaned = _priceCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final price = double.tryParse(priceCleaned) ?? 0.0;

    final durationCleaned = _durationCtrl.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    final duration = int.tryParse(durationCleaned) ?? 0;

    final imageUrl = _imageCtrl.text.trim();

    final success = await ref
        .read(toursViewModelProvider.notifier)
        .updateTour(
          id: widget.tour.id!,
          title: title,
          description: desc,
          price: price,
          durationDays: duration,
          status: _status,
          categoryId: _category,
          firestoreId: imageUrl.isNotEmpty ? imageUrl : null,
          createdAt: widget.tour.createdAt,
        );

    setState(() => _isSaving = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lưu thông tin tour thành công!'),
            backgroundColor: ToursTheme.success,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Có lỗi xảy ra khi lưu thông tin tour!'),
            backgroundColor: ToursTheme.danger,
          ),
        );
      }
    }
  }

  Widget _buildGlassCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ToursTheme.surfaceContainerLow.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
        border: Border.all(
          color: ToursTheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ToursTheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildGeneralInfoCard() {
    return _buildGlassCard(
      title: 'Thông Tin Chung',
      icon: Icons.article_outlined,
      child: Column(
        children: [
          TextFormField(
            controller: _titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Tên tour',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.title,
                size: 20,
                color: ToursTheme.onSurfaceVariant,
              ),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (val) =>
                val == null || val.isEmpty ? 'Vui lòng nhập tên tour' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(
              labelText: 'Chọn danh mục',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.category,
                size: 20,
                color: ToursTheme.onSurfaceVariant,
              ),
            ),
            dropdownColor: ToursTheme.surfaceContainerHigh,
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(value: '1', child: Text('Thám Hiểm Sang Trọng')),
              DropdownMenuItem(value: '2', child: Text('Thành Thị Thượng Lưu')),
              DropdownMenuItem(
                value: 'Bắc Âu Xa Hoa',
                child: Text('Bắc Âu Xa Hoa'),
              ),
              DropdownMenuItem(
                value: 'Hải Trình Thượng Lưu',
                child: Text('Hải Trình Thượng Lưu'),
              ),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _category = val);
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _difficulty,
            decoration: const InputDecoration(
              labelText: 'Mức độ thử thách',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.speed,
                size: 20,
                color: ToursTheme.onSurfaceVariant,
              ),
            ),
            dropdownColor: ToursTheme.surfaceContainerHigh,
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(value: 'Dễ', child: Text('Dễ (Easy)')),
              DropdownMenuItem(
                value: 'Trung bình',
                child: Text('Trung bình (Moderate)'),
              ),
              DropdownMenuItem(value: 'Khó', child: Text('Khó (Demanding)')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _difficulty = val);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descCtrl,
            decoration: const InputDecoration(
              labelText: 'Mô tả chi tiết',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            style: const TextStyle(color: Colors.white),
            maxLines: 5,
            validator: (val) => val == null || val.isEmpty
                ? 'Vui lòng nhập mô tả chi tiết'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingStatusCard() {
    return _buildGlassCard(
      title: 'Giá Cả & Trạng Thái',
      icon: Icons.payments_outlined,
      child: Column(
        children: [
          TextFormField(
            controller: _priceCtrl,
            decoration: const InputDecoration(
              labelText: 'Giá cả (VNĐ)',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.money,
                size: 20,
                color: ToursTheme.onSurfaceVariant,
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Vui lòng nhập giá';
              final priceCleaned = val.replaceAll(RegExp(r'[^0-9.]'), '');
              if (double.tryParse(priceCleaned) == null) {
                return 'Giá trị phải là số';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _durationCtrl,
            decoration: const InputDecoration(
              labelText: 'Thời lượng (Ngày)',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.today,
                size: 20,
                color: ToursTheme.onSurfaceVariant,
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Vui lòng nhập số ngày';
              if (int.tryParse(val) == null) return 'Số ngày phải là số nguyên';
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(
              labelText: 'Trạng thái phát hành',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.visibility,
                size: 20,
                color: ToursTheme.onSurfaceVariant,
              ),
            ),
            dropdownColor: ToursTheme.surfaceContainerHigh,
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(
                value: 'active',
                child: Text('Hoạt động (Active)'),
              ),
              DropdownMenuItem(value: 'draft', child: Text('Nháp (Draft)')),
              DropdownMenuItem(
                value: 'inactive',
                child: Text('Không hoạt động (Inactive)'),
              ),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _status = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return _buildGlassCard(
      title: 'Hiệu Suất Hoạt Động',
      icon: Icons.trending_up_outlined,
      child: Column(
        children: [
          _buildPerformanceRow(
            'Tỷ lệ đặt chỗ (Booking Rate)',
            '94%',
            Icons.check_circle_outline,
            Colors.green,
          ),
          const Divider(color: ToursTheme.outlineVariant, height: 20),
          _buildPerformanceRow(
            'Điểm đánh giá trung bình',
            '4.9 ★',
            Icons.star_border,
            Colors.amber,
          ),
          const Divider(color: ToursTheme.outlineVariant, height: 20),
          _buildPerformanceRow(
            'Lượt xem tháng này',
            '1,240 lượt',
            Icons.visibility_outlined,
            ToursTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: ToursTheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryCard() {
    final imageLink = _imageCtrl.text.trim();
    final hasImage = imageLink.isNotEmpty && imageLink.startsWith('http');

    return _buildGlassCard(
      title: 'Quản Lý Thư Viện Ảnh (Gallery)',
      icon: Icons.photo_library_outlined,
      child: Column(
        children: [
          TextFormField(
            controller: _imageCtrl,
            decoration: const InputDecoration(
              labelText: 'Đường dẫn ảnh nền chính (URL)',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              hintText: 'https://...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.link,
                size: 20,
                color: ToursTheme.onSurfaceVariant,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: ToursTheme.surface,
              borderRadius: BorderRadius.circular(ToursTheme.radiusDefault),
              border: Border.all(
                color: hasImage
                    ? Colors.transparent
                    : ToursTheme.outlineVariant,
                width: 1,
                style: hasImage ? BorderStyle.none : BorderStyle.solid,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasImage
                ? Image.network(
                    imageLink,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 40,
                            color: ToursTheme.danger,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Không thể tải ảnh, vui lòng kiểm tra lại URL',
                            style: TextStyle(
                              color: ToursTheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 36,
                          color: ToursTheme.outline,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Xem trước hình ảnh chính ở đây',
                          style: TextStyle(
                            color: ToursTheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryCard() {
    return _buildGlassCard(
      title: 'Lịch Trình Chi Tiết',
      icon: Icons.map_outlined,
      child: Column(
        children: [
          _buildItineraryStep(
            'Ngày 1',
            'Khởi hành & Check-in',
            'Di chuyển đến khu nghỉ dưỡng, đón đoàn và tổ chức tiệc chào mừng.',
            true,
          ),
          _buildItineraryStep(
            'Ngày 2',
            'Khám Phá Điểm Đến',
            'Tham quan các kỳ quan chính, trải nghiệm các trò chơi mạo hiểm dã ngoại.',
            true,
          ),
          _buildItineraryStep(
            'Ngày 3',
            'Mua Sắm & Trở Về',
            'Thời gian hoạt động tự do mua sắm quà lưu niệm và xe đưa tiễn ra sân bay.',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryStep(
    String day,
    String title,
    String description,
    bool hasNext,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ToursTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: ToursTheme.primary.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                day,
                style: const TextStyle(
                  color: ToursTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            if (hasNext)
              Container(
                width: 1.5,
                height: 50,
                color: ToursTheme.outlineVariant,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: ToursTheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

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
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button + Breadcrumbs
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Quản lý Tour',
                      style: ToursTheme.textBodySm.copyWith(
                        color: ToursTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: ToursTheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Chỉnh Sửa Tour',
                      style: TextStyle(
                        color: ToursTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: General Info & Itinerary
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildGeneralInfoCard(),
                            const SizedBox(height: 20),
                            _buildGalleryCard(),
                            const SizedBox(height: 20),
                            _buildItineraryCard(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Right Column: Price/Status & Stats
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildPricingStatusCard(),
                            const SizedBox(height: 20),
                            _buildPerformanceCard(),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildGeneralInfoCard(),
                      const SizedBox(height: 20),
                      _buildPricingStatusCard(),
                      const SizedBox(height: 20),
                      _buildPerformanceCard(),
                      const SizedBox(height: 20),
                      _buildGalleryCard(),
                      const SizedBox(height: 20),
                      _buildItineraryCard(),
                    ],
                  ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ToursTheme.primary,
                      foregroundColor: Colors.black,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ToursTheme.radiusLg,
                        ),
                      ),
                    ),
                    onPressed: _isSaving ? null : _submit,
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Cập nhật Tour',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
