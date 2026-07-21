import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../tours/presentation/theme/tours_theme.dart';
import '../../../tours/presentation/widgets/admin_layout.dart';
import '../view_models/categories_viewmodel.dart';

class CreateCategoryScreen extends ConsumerStatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  ConsumerState<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends ConsumerState<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _shortNameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  String _status = 'active';
  String _icon = 'explore';
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
    _shortNameCtrl.dispose();
    _descCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final title = _titleCtrl.text;
    final shortName = _shortNameCtrl.text;
    final desc = _descCtrl.text;
    final imageUrl = _imageCtrl.text.trim();

    final success = await ref.read(categoriesViewModelProvider.notifier).addCategory(
          title: title,
          shortName: shortName.isNotEmpty ? shortName : null,
          description: desc.isNotEmpty ? desc : null,
          icon: _icon,
          imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
          status: _status,
        );

    setState(() => _isSaving = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm danh mục mới thành công!'),
            backgroundColor: ToursTheme.success,
          ),
        );
        context.go('/admin/categories');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Có lỗi xảy ra khi thêm danh mục mới!'),
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
      title: 'Thông Tin Danh Mục',
      icon: Icons.article_outlined,
      child: Column(
        children: [
          TextFormField(
            controller: _titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Tên danh mục *',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title, size: 20, color: ToursTheme.onSurfaceVariant),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập tên danh mục' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _shortNameCtrl,
            decoration: const InputDecoration(
              labelText: 'Tên hiển thị ngắn',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.short_text, size: 20, color: ToursTheme.onSurfaceVariant),
            ),
            style: const TextStyle(color: Colors.white),
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
          ),
        ],
      ),
    );
  }

  Widget _buildConfigCard() {
    final imageLink = _imageCtrl.text.trim();
    final hasImage = imageLink.isNotEmpty && imageLink.startsWith('http');

    return _buildBentoCard(
      title: 'Cấu Hình & Trạng Thái',
      icon: Icons.settings_suggest_outlined,
      child: Column(
        children: [
          // Select Icon
          DropdownButtonFormField<String>(
            value: _icon,
            decoration: const InputDecoration(
              labelText: 'Chọn Icon đại diện',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.palette_outlined, size: 20, color: ToursTheme.onSurfaceVariant),
            ),
            dropdownColor: ToursTheme.surfaceContainerHigh,
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(value: 'explore', child: Row(children: [Icon(Icons.explore_outlined, color: ToursTheme.primary, size: 20), SizedBox(width: 8), Text('La bàn (Explore)')])),
              DropdownMenuItem(value: 'location_city', child: Row(children: [Icon(Icons.location_city_outlined, color: ToursTheme.primary, size: 20), SizedBox(width: 8), Text('Thành phố (City)')])),
              DropdownMenuItem(value: 'beach', child: Row(children: [Icon(Icons.beach_access_outlined, color: ToursTheme.primary, size: 20), SizedBox(width: 8), Text('Bãi biển (Beach)')])),
              DropdownMenuItem(value: 'directions_boat', child: Row(children: [Icon(Icons.directions_boat_outlined, color: ToursTheme.primary, size: 20), SizedBox(width: 8), Text('Du thuyền (Boat)')])),
              DropdownMenuItem(value: 'landscape', child: Row(children: [Icon(Icons.landscape_outlined, color: ToursTheme.primary, size: 20), SizedBox(width: 8), Text('Núi non (Mountain)')])),
              DropdownMenuItem(value: 'forest', child: Row(children: [Icon(Icons.park_outlined, color: ToursTheme.primary, size: 20), SizedBox(width: 8), Text('Rừng cây (Forest)')])),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _icon = val);
            },
          ),
          const SizedBox(height: 16),

          // Banner Image URL
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

          // Image Preview
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 120,
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
                          Icon(Icons.broken_image, size: 30, color: ToursTheme.danger),
                          SizedBox(height: 4),
                          Text(
                            'Không thể tải ảnh',
                            style: TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, size: 30, color: ToursTheme.outline),
                        SizedBox(height: 4),
                        Text(
                          'Xem trước hình ảnh hiển thị ở đây',
                          style: TextStyle(color: ToursTheme.onSurfaceVariant, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 16),

          // Publication Status
          DropdownButtonFormField<String>(
            value: _status,
            decoration: const InputDecoration(
              labelText: 'Trạng thái hoạt động',
              labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.visibility, size: 20, color: ToursTheme.onSurfaceVariant),
            ),
            dropdownColor: ToursTheme.surfaceContainerHigh,
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(value: 'active', child: Text('Hoạt động (Active)')),
              DropdownMenuItem(value: 'inactive', child: Text('Ngưng hoạt động (Inactive)')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _status = val);
            },
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
        currentMenu: 'Categories',
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
                      onPressed: () => context.go('/admin/categories'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Quản lý Danh mục',
                      style: ToursTheme.textBodySm.copyWith(color: ToursTheme.onSurfaceVariant),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 16, color: ToursTheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    const Text(
                      'Thêm Danh Mục Mới',
                      style: TextStyle(color: ToursTheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Responsive Grid Layout
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Basic Info
                      Expanded(
                        flex: 3,
                        child: _buildBasicInfoCard(),
                      ),
                      const SizedBox(width: 20),
                      // Right Column: Configs
                      Expanded(
                        flex: 2,
                        child: _buildConfigCard(),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildBasicInfoCard(),
                      const SizedBox(height: 20),
                      _buildConfigCard(),
                    ],
                  ),
                const SizedBox(height: 36),

                // Save Button
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
                                'Tạo Danh Mục',
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
