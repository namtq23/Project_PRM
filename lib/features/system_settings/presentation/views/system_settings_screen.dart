import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/system_settings_model.dart';
import '../view_models/system_settings_view_model.dart';

abstract class _StitchTokens {
  static const Color background = Color(0xFF0C1324);
  static const Color surfaceLow = Color(0xFF151B2D);
  static const Color surfaceContainer = Color(0xFF191F31);
  static const Color surfaceHigh = Color(0xFF23293C);
  static const Color surfaceHighest = Color(0xFF2E3447);

  static const Color onSurface = Color(0xFFDCE1FB);
  static const Color onSurfaceVariant = Color(0xFFBDC8D1);

  static const Color primary = Color(0xFF8ED5FF);
  static const Color primaryContainer = Color(0xFF38BDF8);
  static const Color onPrimaryContainer = Color(0xFF004965);

  static const Color secondaryContainer = Color(0xFF3F465C);
  static const Color onSecondaryContainer = Color(0xFFADB4CE);

  static const Color outlineVariant = Color(0xFF3E484F);

  static const Color statusGreen = Color(0xFF4ADE80);
  static const Color warningAmber = Color(0xFFFBBF24);
  static const Color error = Color(0xFFFFB4AB);
}

class SystemSettingsScreen extends ConsumerStatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  ConsumerState<SystemSettingsScreen> createState() =>
      _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends ConsumerState<SystemSettingsScreen> {
  int _activeTabIndex =
      0; // 0: General, 1: Payment, 2: Notifications, 3: Permissions

  late TextEditingController _platformNameController;
  late TextEditingController _supportEmailController;
  late TextEditingController _supportPhoneController;
  late TextEditingController _companyAddressController;
  late TextEditingController _metaTitleController;
  late TextEditingController _generalTermsController;

  bool _bookingConfirmations = true;
  bool _internalAlerts = true;
  bool _reviewInvitations = false;
  bool _isFormInitialized = false;

  @override
  void initState() {
    super.initState();
    _platformNameController = TextEditingController();
    _supportEmailController = TextEditingController();
    _supportPhoneController = TextEditingController();
    _companyAddressController = TextEditingController();
    _metaTitleController = TextEditingController();
    _generalTermsController = TextEditingController();
  }

  @override
  void dispose() {
    _platformNameController.dispose();
    _supportEmailController.dispose();
    _supportPhoneController.dispose();
    _companyAddressController.dispose();
    _metaTitleController.dispose();
    _generalTermsController.dispose();
    super.dispose();
  }

  void _populateForm(SystemSettingsModel settings) {
    if (!_isFormInitialized) {
      _platformNameController.text = settings.platformName;
      _supportEmailController.text = settings.supportEmail;
      _supportPhoneController.text = settings.supportPhone;
      _companyAddressController.text = settings.companyAddress;
      _metaTitleController.text = settings.metaTitleTemplate;
      _generalTermsController.text = settings.generalTerms;
      _bookingConfirmations = settings.bookingConfirmationsEnabled;
      _internalAlerts = settings.internalAlertsEnabled;
      _reviewInvitations = settings.reviewInvitationsEnabled;
      _isFormInitialized = true;
    }
  }

  void _resetForm(SystemSettingsModel settings) {
    setState(() {
      _platformNameController.text = settings.platformName;
      _supportEmailController.text = settings.supportEmail;
      _supportPhoneController.text = settings.supportPhone;
      _companyAddressController.text = settings.companyAddress;
      _metaTitleController.text = settings.metaTitleTemplate;
      _generalTermsController.text = settings.generalTerms;
      _bookingConfirmations = settings.bookingConfirmationsEnabled;
      _internalAlerts = settings.internalAlertsEnabled;
      _reviewInvitations = settings.reviewInvitationsEnabled;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form values reset to current configuration'),
        backgroundColor: _StitchTokens.surfaceHighest,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveForm(SystemSettingsModel currentSettings) {
    final updated = currentSettings.copyWith(
      platformName: _platformNameController.text.trim(),
      supportEmail: _supportEmailController.text.trim(),
      supportPhone: _supportPhoneController.text.trim(),
      companyAddress: _companyAddressController.text.trim(),
      metaTitleTemplate: _metaTitleController.text.trim(),
      generalTerms: _generalTermsController.text.trim(),
      bookingConfirmationsEnabled: _bookingConfirmations,
      internalAlertsEnabled: _internalAlerts,
      reviewInvitationsEnabled: _reviewInvitations,
    );

    ref.read(systemSettingsViewModelProvider.notifier).updateSettings(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('System configuration saved successfully!'),
        backgroundColor: _StitchTokens.primaryContainer,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showMaintenanceModeConfirmDialog(
    BuildContext context,
    bool targetState,
  ) {
    if (!targetState) {
      // Direct turn OFF maintenance mode
      ref
          .read(systemSettingsViewModelProvider.notifier)
          .toggleMaintenanceMode(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã tắt chế độ bảo trì hệ thống.'),
          backgroundColor: _StitchTokens.primaryContainer,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Confirmation dialog when turning ON maintenance mode
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _StitchTokens.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _StitchTokens.outlineVariant),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: _StitchTokens.warningAmber,
            ),
            SizedBox(width: 8),
            Text(
              'Xác nhận bật bảo trì',
              style: TextStyle(
                color: _StitchTokens.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Bật chế độ bảo trì sẽ khiến người dùng không thể truy cập ứng dụng, bạn có chắc chắn?',
          style: TextStyle(
            color: _StitchTokens.onSurfaceVariant,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Hủy',
              style: TextStyle(color: _StitchTokens.onSurfaceVariant),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref
                  .read(systemSettingsViewModelProvider.notifier)
                  .toggleMaintenanceMode(true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã kích hoạt chế độ bảo trì hệ thống!'),
                  backgroundColor: _StitchTokens.warningAmber,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: _StitchTokens.warningAmber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Xác nhận bật',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(systemSettingsViewModelProvider);

    return Scaffold(
      backgroundColor: _StitchTokens.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(context),
            Expanded(
              child: settingsAsync.when(
                data: (settings) {
                  _populateForm(settings);
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPageHeader(),
                            const SizedBox(height: 24),
                            _buildMainTabContainer(settings),
                            const SizedBox(height: 24),
                            _buildBentoAdvancedSection(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: _StitchTokens.primaryContainer,
                  ),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: _StitchTokens.error,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load settings: $error',
                        style: const TextStyle(
                          color: _StitchTokens.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () =>
                            ref.invalidate(systemSettingsViewModelProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: _StitchTokens.background,
        border: Border(bottom: BorderSide(color: _StitchTokens.outlineVariant)),
      ),
      child: Row(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Voyage Admin',
                style: TextStyle(
                  color: _StitchTokens.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'EXECUTIVE SUITE',
                style: TextStyle(
                  color: _StitchTokens.onSurfaceVariant,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(
              Icons.notifications_none,
              color: _StitchTokens.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Help',
            icon: const Icon(
              Icons.help_outline,
              color: _StitchTokens.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: _StitchTokens.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Admin User',
                      style: TextStyle(
                        color: _StitchTokens.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ADMINISTRATOR',
                      style: TextStyle(
                        color: _StitchTokens.onSurfaceVariant,
                        fontSize: 9,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _StitchTokens.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  child: const Text(
                    'AU',
                    style: TextStyle(
                      color: _StitchTokens.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'System Settings',
          style: TextStyle(
            color: _StitchTokens.primary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Configure the global platform parameters and integration gateways.',
          style: TextStyle(color: _StitchTokens.onSurfaceVariant, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildMainTabContainer(SystemSettingsModel settings) {
    return Container(
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Column(
        children: [
          // Tab Header Bar
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: _StitchTokens.outlineVariant),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabButton('General Settings', 0),
                  _buildTabButton('Payment Gateways', 1),
                  _buildTabButton('Email Notifications', 2),
                  _buildTabButton('Staff Permissions', 3),
                ],
              ),
            ),
          ),
          // Tab Body Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildTabBodyContent(settings),
          ),
          // Footer Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: _StitchTokens.surfaceHighest,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border(
                top: BorderSide(color: _StitchTokens.outlineVariant),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => _resetForm(settings),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _StitchTokens.onSurfaceVariant,
                    side: const BorderSide(color: _StitchTokens.outlineVariant),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Discard Changes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _saveForm(settings),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _StitchTokens.primaryContainer,
                    foregroundColor: _StitchTokens.onPrimaryContainer,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Configuration',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isActive = _activeTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _activeTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive
                  ? _StitchTokens.primaryContainer
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? _StitchTokens.primaryContainer
                : _StitchTokens.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBodyContent(SystemSettingsModel settings) {
    switch (_activeTabIndex) {
      case 0:
        return _buildGeneralSettingsTab(settings);
      case 1:
        return _buildPaymentGatewaysTab();
      case 2:
        return _buildNotificationsTab();
      case 3:
        return _buildPermissionsTab();
      default:
        return _buildGeneralSettingsTab(settings);
    }
  }

  Widget _buildGeneralSettingsTab(SystemSettingsModel settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // System Maintenance Mode Banner & Switch
        _buildMaintenanceModeSection(settings),
        const SizedBox(height: 32),
        // Grid 2 Columns: Contact Information & General Terms/SEO
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 800;
            return Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1: Contact Information
                if (isDesktop)
                  Expanded(child: _buildContactInfoSection())
                else
                  _buildContactInfoSection(),
                if (isDesktop)
                  const SizedBox(width: 32)
                else
                  const SizedBox(height: 32),
                // Column 2: General Terms & Conditions & SEO
                if (isDesktop)
                  Expanded(child: _buildTermsAndSeoSection())
                else
                  _buildTermsAndSeoSection(),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMaintenanceModeSection(SystemSettingsModel settings) {
    final isMaintenance = settings.isMaintenanceMode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isMaintenance
            ? _StitchTokens.warningAmber.withValues(alpha: 0.08)
            : _StitchTokens.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMaintenance
              ? _StitchTokens.warningAmber.withValues(alpha: 0.4)
              : _StitchTokens.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMaintenance
                  ? _StitchTokens.warningAmber.withValues(alpha: 0.2)
                  : _StitchTokens.primaryContainer.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isMaintenance
                  ? Icons.build_circle_outlined
                  : Icons.cloud_done_outlined,
              color: isMaintenance
                  ? _StitchTokens.warningAmber
                  : _StitchTokens.primaryContainer,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'System Maintenance Mode',
                      style: TextStyle(
                        color: isMaintenance
                            ? _StitchTokens.warningAmber
                            : _StitchTokens.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isMaintenance
                            ? _StitchTokens.warningAmber.withValues(alpha: 0.2)
                            : _StitchTokens.statusGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isMaintenance ? 'MAINTENANCE ACTIVE' : 'LIVE ONLINE',
                        style: TextStyle(
                          color: isMaintenance
                              ? _StitchTokens.warningAmber
                              : _StitchTokens.statusGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Khi bật chế độ bảo trì, người dùng thông thường sẽ không thể truy cập ứng dụng. Chỉ tài khoản Master Admin mới có quyền truy cập.',
                  style: TextStyle(
                    color: _StitchTokens.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isMaintenance,
            activeThumbColor: _StitchTokens.warningAmber,
            activeTrackColor: _StitchTokens.warningAmber.withValues(alpha: 0.3),
            inactiveThumbColor: _StitchTokens.onSurfaceVariant,
            inactiveTrackColor: _StitchTokens.surfaceHighest,
            onChanged: (val) => _showMaintenanceModeConfirmDialog(context, val),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            color: _StitchTokens.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _platformNameController,
          label: 'Platform Name',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _supportEmailController,
          label: 'Support Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _supportPhoneController,
          label: 'Support Phone / Hotline',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _companyAddressController,
          label: 'Company Head Office Address',
        ),
        const SizedBox(height: 16),
        // Brand Logo Replace Tile
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _StitchTokens.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _StitchTokens.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _StitchTokens.surfaceHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  color: _StitchTokens.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Main Brand Logo',
                      style: TextStyle(
                        color: _StitchTokens.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Recommended: 512x512px SVG or PNG',
                      style: TextStyle(
                        color: _StitchTokens.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _StitchTokens.secondaryContainer,
                  foregroundColor: _StitchTokens.onSecondaryContainer,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Replace',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndSeoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'General Terms & SEO Metadata',
          style: TextStyle(
            color: _StitchTokens.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _metaTitleController,
          label: 'Meta Title Template',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _generalTermsController,
          label: 'Global Description & Terms Overview',
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _StitchTokens.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: _StitchTokens.onSurface, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: _StitchTokens.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _StitchTokens.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: _StitchTokens.primaryContainer,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentGatewaysTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Integration Gateways',
          style: TextStyle(
            color: _StitchTokens.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              children: [
                // Stripe Card
                Expanded(
                  flex: isWide ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _StitchTokens.surfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _StitchTokens.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF635BFF,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.payments,
                                color: Color(0xFF635BFF),
                                size: 28,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _StitchTokens.statusGreen.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: const Text(
                                'Connected',
                                style: TextStyle(
                                  color: _StitchTokens.statusGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Stripe Payment Gateway',
                          style: TextStyle(
                            color: _StitchTokens.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Handle credit card payments, subscriptions, and Apple/Google Pay integration.',
                          style: TextStyle(
                            color: _StitchTokens.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _StitchTokens.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _StitchTokens.outlineVariant,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'sk_live_....4v8x',
                                style: TextStyle(
                                  color: _StitchTokens.onSurfaceVariant,
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                              Icon(
                                Icons.visibility_outlined,
                                color: _StitchTokens.onSurfaceVariant,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isWide)
                  const SizedBox(width: 16)
                else
                  const SizedBox(height: 16),
                // PayPal Card
                Expanded(
                  flex: isWide ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _StitchTokens.surfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _StitchTokens.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF003087,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Color(0xFF003087),
                                size: 28,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _StitchTokens.surfaceHighest,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: const Text(
                                'Disconnected',
                                style: TextStyle(
                                  color: _StitchTokens.onSurfaceVariant,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'PayPal Commerce',
                          style: TextStyle(
                            color: _StitchTokens.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Enable express checkout and local payment methods for international travelers.',
                          style: TextStyle(
                            color: _StitchTokens.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _StitchTokens.primaryContainer,
                              foregroundColor: _StitchTokens.onPrimaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Connect Account',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Notification Triggers',
          style: TextStyle(
            color: _StitchTokens.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        _buildNotificationTile(
          icon: Icons.mail_outline,
          title: 'Booking Confirmations',
          subtitle: 'Sent to customers immediately after successful payment.',
          value: _bookingConfirmations,
          onChanged: (val) => setState(() => _bookingConfirmations = val),
        ),
        const SizedBox(height: 12),
        _buildNotificationTile(
          icon: Icons.admin_panel_settings_outlined,
          title: 'Internal New Booking Alert',
          subtitle: 'Notify sales team when a new luxury tour is booked.',
          value: _internalAlerts,
          onChanged: (val) => setState(() => _internalAlerts = val),
        ),
        const SizedBox(height: 12),
        _buildNotificationTile(
          icon: Icons.rate_review_outlined,
          title: 'Review Invitations',
          subtitle: 'Automated request sent 3 days after tour completion.',
          value: _reviewInvitations,
          onChanged: (val) => setState(() => _reviewInvitations = val),
        ),
      ],
    );
  }

  Widget _buildNotificationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _StitchTokens.primaryContainer.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _StitchTokens.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _StitchTokens.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _StitchTokens.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: _StitchTokens.primaryContainer,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsTab() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Staff Role Matrix & Access Control',
            style: TextStyle(
              color: _StitchTokens.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Master Administrators have full access. Support specialists are restricted to customer bookings and reviews moderation.',
            style: TextStyle(
              color: _StitchTokens.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoAdvancedSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        return Flex(
          direction: isDesktop ? Axis.horizontal : Axis.vertical,
          children: [
            // Security & System Health Card
            Expanded(
              flex: isDesktop ? 2 : 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _StitchTokens.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _StitchTokens.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: _StitchTokens.primary,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'System Health & Security',
                              style: TextStyle(
                                color: _StitchTokens.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Monitor global API connectivity, encryption certificates, and database integrity.',
                          style: TextStyle(
                            color: _StitchTokens.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: _StitchTokens.primaryContainer,
                          child: Text(
                            'SA',
                            style: TextStyle(
                              fontSize: 9,
                              color: _StitchTokens.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Last security audit: 2 hours ago',
                          style: TextStyle(
                            color: _StitchTokens.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isDesktop)
              const SizedBox(width: 16)
            else
              const SizedBox(height: 16),
            // Performance Cache Hit Card
            Expanded(
              flex: isDesktop ? 1 : 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _StitchTokens.primary.withValues(alpha: 0.15),
                      _StitchTokens.surfaceContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _StitchTokens.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.speed,
                      color: _StitchTokens.primary,
                      size: 36,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Performance',
                      style: TextStyle(
                        color: _StitchTokens.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Global cache hit rate: 98.4%',
                      style: TextStyle(
                        color: _StitchTokens.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.984,
                        minHeight: 6,
                        backgroundColor: _StitchTokens.surfaceHighest,
                        color: _StitchTokens.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
