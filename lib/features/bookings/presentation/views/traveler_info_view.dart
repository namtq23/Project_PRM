import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_paths.dart';
import '../../models/booking_flow_models.dart';
import '../view_models/booking_view_model.dart';
import '../widgets/booking_currency.dart';
import '../widgets/booking_design.dart';

class TravelerInfoView extends ConsumerStatefulWidget {
  const TravelerInfoView({super.key, this.startArgs});

  final BookingStartArgs? startArgs;

  @override
  ConsumerState<TravelerInfoView> createState() => _TravelerInfoViewState();
}

class _TravelerInfoViewState extends ConsumerState<TravelerInfoView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _notesController;
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
    _emailController = TextEditingController();
    _notesController = TextEditingController(
      text: initialTraveler.specialNotes,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDepartureDate(TravelerInfo travelerInfo) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate:
          travelerInfo.selectedDate ?? now.add(const Duration(days: 1)),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: BookingDesign.primary,
            onPrimary: BookingDesign.onPrimary,
            surface: BookingDesign.surface,
            onSurface: BookingDesign.text,
          ),
          dialogTheme: const DialogThemeData(
            backgroundColor: BookingDesign.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;

    setState(() => _showDateError = false);
    ref
        .read(bookingViewModelProvider.notifier)
        .updateTravelerInfo(travelerInfo.copyWith(selectedDate: date));
  }

  void _onContinue() {
    final draft = ref.read(bookingViewModelProvider);
    final hasSelectedDate = draft.travelerInfo.selectedDate != null;
    setState(() => _showDateError = !hasSelectedDate);

    if (!_formKey.currentState!.validate() || !hasSelectedDate) return;

    ref
        .read(bookingViewModelProvider.notifier)
        .updateTravelerInfo(
          draft.travelerInfo.copyWith(
            contactName: _nameController.text.trim(),
            contactPhone: _phoneController.text.trim(),
            specialNotes: _notesController.text.trim(),
          ),
        );
    context.push(RoutePaths.bookingPayment);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingViewModelProvider);
    final travelerInfo = draft.travelerInfo;

    return Scaffold(
      backgroundColor: BookingDesign.background,
      appBar: BookingAppBar(
        title: 'Thông tin đặt chỗ',
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: _BookingProgressHeader(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    children: [
                      BookingSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BookingSectionTitle(
                              icon: Icons.badge_outlined,
                              title: 'Thông tin liên hệ',
                            ),
                            const SizedBox(height: 22),
                            _BookingFormField(
                              label: 'Họ và tên',
                              controller: _nameController,
                              hintText: 'Nhập họ và tên đầy đủ',
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Vui lòng nhập họ và tên'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            _BookingFormField(
                              label: 'Số điện thoại',
                              controller: _phoneController,
                              hintText: '+84 000 000 000',
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                final normalized = value
                                    ?.replaceAll(RegExp(r'[\s-]'), '')
                                    .trim();
                                if (normalized == null || normalized.isEmpty) {
                                  return 'Vui lòng nhập số điện thoại';
                                }
                                if (!RegExp(
                                  r'^\+?\d{9,12}$',
                                ).hasMatch(normalized)) {
                                  return 'Số điện thoại không hợp lệ';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            _BookingFormField(
                              label: 'Địa chỉ Email',
                              controller: _emailController,
                              hintText: 'example@email.com',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null;
                                }
                                return RegExp(
                                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                    ).hasMatch(value.trim())
                                    ? null
                                    : 'Email không hợp lệ';
                              },
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Chúng tôi sẽ gửi vé điện tử và thông tin xác nhận qua email này.',
                              style: TextStyle(
                                color: BookingDesign.mutedText,
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      BookingSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BookingSectionTitle(
                              icon: Icons.groups_outlined,
                              title: 'Số lượng hành khách',
                            ),
                            const SizedBox(height: 22),
                            _TravelerCounter(
                              label: 'Người lớn',
                              description: 'Từ 12 tuổi trở lên',
                              value: travelerInfo.adultCount,
                              minimum: 1,
                              onChanged: (value) => ref
                                  .read(bookingViewModelProvider.notifier)
                                  .updateTravelerInfo(
                                    travelerInfo.copyWith(adultCount: value),
                                  ),
                            ),
                            const SizedBox(height: 14),
                            _TravelerCounter(
                              label: 'Trẻ em',
                              description: 'Từ 2 - 11 tuổi',
                              value: travelerInfo.childCount,
                              minimum: 0,
                              onChanged: (value) => ref
                                  .read(bookingViewModelProvider.notifier)
                                  .updateTravelerInfo(
                                    travelerInfo.copyWith(childCount: value),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      BookingSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BookingSectionTitle(
                              icon: Icons.edit_note_outlined,
                              title: 'Ghi chú đặc biệt',
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _notesController,
                              minLines: 4,
                              maxLines: 5,
                              style: const TextStyle(color: BookingDesign.text),
                              decoration: BookingDesign.fieldDecoration(
                                hintText:
                                    'Bạn có yêu cầu đặc biệt nào không? (Ví dụ: Chế độ ăn uống, hỗ trợ xe lăn...)',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      _TravelerTourSummary(
                        draft: draft,
                        showDateError: _showDateError,
                        onPickDate: () => _pickDepartureDate(travelerInfo),
                      ),
                      const SizedBox(height: 16),
                      const BookingSectionCard(
                        padding: EdgeInsets.all(16),
                        borderColor: Color(0xFF0C4A6E),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: BookingDesign.primary,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Giá đã bao gồm toàn bộ thuế và phí. Không phát sinh chi phí ẩn.',
                                style: TextStyle(
                                  color: BookingDesign.text,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
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
      bottomNavigationBar: BookingBottomBar(
        total: draft.totalCost,
        buttonLabel: 'Tiếp tục',
        onPressed: _onContinue,
      ),
    );
  }
}

class _BookingProgressHeader extends StatelessWidget {
  const _BookingProgressHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: BookingDesign.surface,
        border: Border(
          top: BorderSide(color: BookingDesign.outline.withValues(alpha: 0.35)),
        ),
      ),
      child: const Row(
        children: [
          _ProgressStep(index: 1, label: 'Hành khách', isActive: true),
          _ProgressStep(index: 2, label: 'Thanh toán'),
          _ProgressStep(index: 3, label: 'Hoàn tất'),
        ],
      ),
    );
  }
}

class _ProgressStep extends StatelessWidget {
  const _ProgressStep({
    required this.index,
    required this.label,
    this.isActive = false,
  });

  final int index;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? BookingDesign.primary : BookingDesign.subtleText;
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: isActive
              ? const Border(
                  bottom: BorderSide(color: BookingDesign.primary, width: 2),
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? BookingDesign.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: color),
              ),
              child: Text(
                '$index',
                style: TextStyle(
                  color: isActive ? BookingDesign.onPrimary : color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingFormField extends StatelessWidget {
  const _BookingFormField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: BookingDesign.text,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          style: const TextStyle(color: BookingDesign.text),
          decoration: BookingDesign.fieldDecoration(hintText: hintText),
        ),
      ],
    );
  }
}

class _TravelerCounter extends StatelessWidget {
  const _TravelerCounter({
    required this.label,
    required this.description,
    required this.value,
    required this.minimum,
    required this.onChanged,
  });

  final String label;
  final String description;
  final int value;
  final int minimum;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF20272B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: BookingDesign.outline.withValues(alpha: 0.65),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: BookingDesign.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: BookingDesign.mutedText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _RoundCounterButton(
            icon: Icons.remove,
            onPressed: value > minimum ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 50,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: BookingDesign.text,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _RoundCounterButton(
            icon: Icons.add,
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _RoundCounterButton extends StatelessWidget {
  const _RoundCounterButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(42),
        backgroundColor: BookingDesign.surfaceHigh,
        disabledBackgroundColor: BookingDesign.surfaceContainer,
        side: BorderSide(color: BookingDesign.outline.withValues(alpha: 0.75)),
      ),
      icon: Icon(icon, color: BookingDesign.primary, size: 20),
    );
  }
}

class _TravelerTourSummary extends StatelessWidget {
  const _TravelerTourSummary({
    required this.draft,
    required this.showDateError,
    required this.onPickDate,
  });

  final BookingDraft draft;
  final bool showDateError;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final traveler = draft.travelerInfo;
    final adultCost = traveler.adultCount * draft.basePrice;
    final dateLabel = traveler.selectedDate == null
        ? 'Chọn ngày khởi hành'
        : DateFormat('dd/MM/yyyy').format(traveler.selectedDate!);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: BookingDesign.surface,
          border: Border.all(
            color: BookingDesign.outline.withValues(alpha: 0.65),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 170,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    bookingTourImage(draft.tourId),
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xE6000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Text(
                      bookingTourTitle(draft.tourId),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  InkWell(
                    onTap: onPickDate,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 18,
                            color: BookingDesign.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Khởi hành: $dateLabel',
                              style: TextStyle(
                                color: showDateError
                                    ? BookingDesign.danger
                                    : BookingDesign.mutedText,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.edit_calendar_outlined,
                            color: BookingDesign.primary,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: BookingDesign.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bookingTourLocation(draft.tourId),
                          style: const TextStyle(
                            color: BookingDesign.mutedText,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: BookingDesign.outline.withValues(alpha: 0.45)),
                  const SizedBox(height: 10),
                  _SummaryPriceRow(
                    label: 'Người lớn (x${traveler.adultCount})',
                    value: formatBookingCurrency(adultCost),
                  ),
                  const SizedBox(height: 10),
                  const _SummaryPriceRow(
                    label: 'Phí dịch vụ',
                    value: 'Miễn phí',
                    valueColor: BookingDesign.success,
                  ),
                  const SizedBox(height: 16),
                  Divider(color: BookingDesign.outline.withValues(alpha: 0.45)),
                  const SizedBox(height: 10),
                  _SummaryPriceRow(
                    label: 'Tổng cộng',
                    value: formatBookingCurrency(draft.totalCost),
                    isTotal: true,
                    valueColor: BookingDesign.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryPriceRow extends StatelessWidget {
  const _SummaryPriceRow({
    required this.label,
    required this.value,
    this.valueColor = BookingDesign.text,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isTotal ? BookingDesign.text : BookingDesign.mutedText,
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: isTotal ? 22 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
