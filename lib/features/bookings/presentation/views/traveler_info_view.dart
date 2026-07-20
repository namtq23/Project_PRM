import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../view_models/booking_view_model.dart';
import '../../models/booking_flow_models.dart';
import '../../../../app/router/route_paths.dart';

class TravelerInfoView extends ConsumerStatefulWidget {
  const TravelerInfoView({super.key, this.startArgs});

  final BookingStartArgs? startArgs;

  @override
  ConsumerState<TravelerInfoView> createState() => _TravelerInfoViewState();
}

class _TravelerInfoViewState extends ConsumerState<TravelerInfoView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;
  bool _showDateError = false;

  @override
  void initState() {
    super.initState();
    final startArgs = widget.startArgs;
    if (startArgs != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(bookingViewModelProvider.notifier)
            .startBooking(
              tourId: startArgs.tourId,
              basePrice: startArgs.basePrice,
            );
      });
    }
    final draft = ref.read(bookingViewModelProvider);
    final initialTraveler = startArgs == null
        ? draft.travelerInfo
        : const TravelerInfo();
    _nameController = TextEditingController(text: initialTraveler.contactName);
    _phoneController = TextEditingController(
      text: initialTraveler.contactPhone,
    );
    _notesController = TextEditingController(
      text: initialTraveler.specialNotes,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final draft = ref.read(bookingViewModelProvider);
    final hasSelectedDate = draft.travelerInfo.selectedDate != null;
    setState(() => _showDateError = !hasSelectedDate);
    if (_formKey.currentState!.validate() && hasSelectedDate) {
      ref
          .read(bookingViewModelProvider.notifier)
          .updateTravelerInfo(
            draft.travelerInfo.copyWith(
              contactName: _nameController.text,
              contactPhone: _phoneController.text,
              specialNotes: _notesController.text,
            ),
          );
      context.push(RoutePaths.bookingPayment);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingViewModelProvider);
    final travelerInfo = draft.travelerInfo;

    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin người đi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chi tiết liên hệ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Vui lòng nhập tên'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập SĐT';
                  }
                  if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
                    return 'SĐT không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Số lượng khách',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildCounter(
                'Người lớn',
                travelerInfo.adultCount,
                (val) => ref
                    .read(bookingViewModelProvider.notifier)
                    .updateTravelerInfo(travelerInfo.copyWith(adultCount: val)),
              ),
              _buildCounter(
                'Trẻ em (Dưới 12 tuổi)',
                travelerInfo.childCount,
                (val) => ref
                    .read(bookingViewModelProvider.notifier)
                    .updateTravelerInfo(travelerInfo.copyWith(childCount: val)),
                min: 0,
              ),
              const SizedBox(height: 24),
              Text(
                'Ngày khởi hành',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate:
                        travelerInfo.selectedDate ??
                        DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _showDateError = false);
                    ref
                        .read(bookingViewModelProvider.notifier)
                        .updateTravelerInfo(
                          travelerInfo.copyWith(selectedDate: date),
                        );
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    travelerInfo.selectedDate != null
                        ? DateFormat(
                            'dd/MM/yyyy',
                          ).format(travelerInfo.selectedDate!)
                        : 'Chọn ngày khởi hành',
                  ),
                ),
              ),
              if (_showDateError)
                const Padding(
                  padding: EdgeInsets.only(top: 6, left: 12),
                  child: Text(
                    'Vui lòng chọn ngày khởi hành',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú đặc biệt',
                  border: OutlineInputBorder(),
                  hintText: 'Ví dụ: Dị ứng hải sản, cần phòng tầng thấp...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _onContinue,
                  child: const Text('Tiếp tục'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounter(
    String label,
    int value,
    ValueChanged<int> onChanged, {
    int min = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              IconButton(
                onPressed: value > min ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              SizedBox(
                width: 30,
                child: Text('$value', textAlign: TextAlign.center),
              ),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
