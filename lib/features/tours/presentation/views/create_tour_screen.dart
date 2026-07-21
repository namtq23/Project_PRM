import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/view_models/tours_viewmodel.dart';
import '../theme/tours_theme.dart';
import '../widgets/admin_layout.dart';

class CreateTourScreen extends ConsumerStatefulWidget {
  const CreateTourScreen({super.key});

  @override
  ConsumerState<CreateTourScreen> createState() => _CreateTourScreenState();
}

class _CreateTourScreenState extends ConsumerState<CreateTourScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  String _status = 'active';
  String _category = '1';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
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
    
    final durationCleaned = _durationCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    final duration = int.tryParse(durationCleaned) ?? 0;
    
    final imageUrl = _imageCtrl.text.trim();

    final success = await ref.read(toursViewModelProvider.notifier).addTour(
          title: title,
          description: desc,
          price: price,
          durationDays: duration,
          status: _status,
          categoryId: _category,
          firestoreId: imageUrl.isNotEmpty ? imageUrl : null,
        );

    setState(() => _isSaving = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm tour mới thành công!'),
            backgroundColor: ToursTheme.success,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Có lỗi xảy ra khi thêm tour mới!'),
            backgroundColor: ToursTheme.danger,
          ),
        );
      }
    }
  }

  Widget _buildBentoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ToursTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
        border: Border.all(color: ToursTheme.outlineVariant, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
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

  Widget _buildBasicInfoCard() {
    return _buildBentoCard(
      title: 'Thông Tin Cơ Bản',
      icon: Icons.article_outlined,
      child: Column(
        children: [
          TextFormField(
            controller: _titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Tên tour',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title, size: 20, color: ToursTheme.onSurfaceVariant),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập tên tour' : null,
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
            maxLines: 4,
            validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập mô tả' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsCard() {
    return _buildBentoCard(
      title: 'Thông Số Cấu Hình',
      icon: Icons.settings_suggest_outlined,
      child: Column(
        children: [
          TextFormField(
            controller: _durationCtrl,
            decoration: const InputDecoration(
              labelText: 'Thời lượng (Ngày)',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.today, size: 20, color: ToursTheme.onSurfaceVariant),
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
            value: _category,
            decoration: const InputDecoration(
              labelText: 'Danh mục du lịch',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category, size: 20, color: ToursTheme.onSurfaceVariant),
            ),
            dropdownColor: ToursTheme.surfaceContainerHigh,
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(value: '1', child: Text('Thám Hiểm Sang Trọng')),
              DropdownMenuItem(value: '2', child: Text('Thành Thị Thượng Lưu')),
              DropdownMenuItem(value: 'Bắc Âu Xa Hoa', child: Text('Bắc Âu Xa Hoa')),
              DropdownMenuItem(value: 'Hải Trình Thượng Lưu', child: Text('Hải Trình Thượng Lưu')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _category = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    return _buildBentoCard(
      title: 'Chi Phí & Trạng Thái',
      icon: Icons.payments_outlined,
      child: Column(
        children: [
          TextFormField(
            controller: _priceCtrl,
            decoration: const InputDecoration(
              labelText: 'Giá (VNĐ)',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.money, size: 20, color: ToursTheme.onSurfaceVariant),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Vui lòng nhập giá';
              final priceCleaned = val.replaceAll(RegExp(r'[^0-9.]'), '');
              if (double.tryParse(priceCleaned) == null) return 'Giá trị phải là số';
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _status,
            decoration: const InputDecoration(
              labelText: 'Trạng thái phát hành',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.visibility, size: 20, color: ToursTheme.onSurfaceVariant),
            ),
            dropdownColor: ToursTheme.surfaceContainerHigh,
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(value: 'active', child: Text('Hoạt động (Active)')),
              DropdownMenuItem(value: 'draft', child: Text('Nháp (Draft)')),
              DropdownMenuItem(value: 'inactive', child: Text('Không hoạt động (Inactive)')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _status = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard() {
    final imageLink = _imageCtrl.text.trim();
    final hasImage = imageLink.isNotEmpty && imageLink.startsWith('http');

    return _buildBentoCard(
      title: 'Hình Ảnh Trực Quan',
      icon: Icons.image_outlined,
      child: Column(
        children: [
          TextFormField(
            controller: _imageCtrl,
            decoration: const InputDecoration(
              labelText: 'Đường dẫn ảnh nền (URL)',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              hintText: 'https://...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.link, size: 20, color: ToursTheme.onSurfaceVariant),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          // Preview Box
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: ToursTheme.surface,
              borderRadius: BorderRadius.circular(ToursTheme.radiusDefault),
              border: Border.all(
                color: hasImage ? Colors.transparent : ToursTheme.outlineVariant,
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
                          Icon(Icons.broken_image, size: 40, color: ToursTheme.danger),
                          SizedBox(height: 8),
                          Text(
                            'Không thể tải ảnh, vui lòng kiểm tra lại URL',
                            style: TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, size: 36, color: ToursTheme.outline),
                        SizedBox(height: 8),
                        Text(
                          'Xem trước hình ảnh hiển thị ở đây',
                          style: TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
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
                      style: ToursTheme.textBodySm.copyWith(color: ToursTheme.onSurfaceVariant),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 16, color: ToursTheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    const Text(
                      'Thêm Tour Mới',
                      style: TextStyle(color: ToursTheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Basic Info & Image Preview
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildBasicInfoCard(),
                            const SizedBox(height: 20),
                            _buildImageCard(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Right Column: Specs & Pricing
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildSpecsCard(),
                            const SizedBox(height: 20),
                            _buildPricingCard(),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildBasicInfoCard(),
                      const SizedBox(height: 20),
                      _buildSpecsCard(),
                      const SizedBox(height: 20),
                      _buildPricingCard(),
                      const SizedBox(height: 20),
                      _buildImageCard(),
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
                        borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
                      ),
                    ),
                    onPressed: _isSaving ? null : _submit,
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.rocket_launch, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Phát hành Tour',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
