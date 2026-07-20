import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/tour_model.dart';
import '../../presentation/view_models/tours_viewmodel.dart';
import '../theme/tours_theme.dart';

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
  void dispose() {
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
    final price = double.parse(_priceCtrl.text);
    final duration = int.parse(_durationCtrl.text);
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

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ToursTheme.background,
        colorScheme: const ColorScheme.dark(
          primary: ToursTheme.primary,
          secondary: ToursTheme.secondary,
          surface: ToursTheme.surface,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ToursTheme.surfaceContainerHigh,
          title: const Text(
            'Thêm Tour Mới',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tên tour',
                      labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập tên tour' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Mô tả',
                      labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLines: 4,
                    validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập mô tả' : null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Giá (VNĐ)',
                            labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Vui lòng nhập giá';
                            if (double.tryParse(val) == null) return 'Giá trị phải là số';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _durationCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Thời lượng (Ngày)',
                            labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Vui lòng nhập số ngày';
                            if (int.tryParse(val) == null) return 'Số ngày phải là số nguyên';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _imageCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Đường dẫn ảnh nền (Tùy chọn)',
                      labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
                      hintText: 'https://...',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                      labelText: 'Danh mục',
                      labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
                      border: OutlineInputBorder(),
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
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(
                      labelText: 'Trạng thái',
                      labelStyle: TextStyle(color: ToursTheme.onSurfaceVariant),
                      border: OutlineInputBorder(),
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
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ToursTheme.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ToursTheme.radiusLg),
                        ),
                      ),
                      onPressed: _isSaving ? null : _submit,
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              'Phát hành Tour',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
