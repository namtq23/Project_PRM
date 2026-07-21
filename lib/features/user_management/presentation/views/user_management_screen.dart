import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../core/widgets/admin_scaffold.dart';
import '../../models/user_management_model.dart';
import '../view_models/user_management_view_model.dart';

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

  static const Color tertiary = Color(0xFFC2CDE5);

  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);

  static const Color outlineVariant = Color(0xFF3E484F);
}

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRoleFilter = 'All Roles';
  String _selectedStatusFilter = 'All Statuses';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showInviteUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = 'customer';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: _StitchTokens.surfaceContainer,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _StitchTokens.outlineVariant),
          ),
          title: const Text(
            'Invite / Create New User',
            style: TextStyle(
              color: _StitchTokens.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(
                      color: _StitchTokens.onSurface,
                      fontSize: 14,
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? 'Please enter full name'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(
                        color: _StitchTokens.onSurfaceVariant,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: _StitchTokens.surfaceLow,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: _StitchTokens.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: _StitchTokens.primaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(
                      color: _StitchTokens.onSurface,
                      fontSize: 14,
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Please enter email' : null,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: const TextStyle(
                        color: _StitchTokens.onSurfaceVariant,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: _StitchTokens.surfaceLow,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: _StitchTokens.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: _StitchTokens.primaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedRole,
                    dropdownColor: _StitchTokens.surfaceContainer,
                    style: const TextStyle(
                      color: _StitchTokens.onSurface,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      labelText: 'System Role',
                      labelStyle: const TextStyle(
                        color: _StitchTokens.onSurfaceVariant,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: _StitchTokens.surfaceLow,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: _StitchTokens.outlineVariant,
                        ),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'customer',
                        child: Text('Customer'),
                      ),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      DropdownMenuItem(
                        value: 'support',
                        child: Text('Support'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedRole = val);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: _StitchTokens.onSurfaceVariant),
              ),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  ref
                      .read(userManagementViewModelProvider.notifier)
                      .createUser(
                        fullName: nameController.text.trim(),
                        email: emailController.text.trim(),
                        role: selectedRole,
                      );
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User invitation sent successfully!'),
                      backgroundColor: _StitchTokens.primaryContainer,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: _StitchTokens.primaryContainer,
                foregroundColor: _StitchTokens.onPrimaryContainer,
              ),
              child: const Text('Send Invite'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeRoleDialog(BuildContext context, UserManagementModel user) {
    String selectedRole = user.role;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: _StitchTokens.surfaceContainer,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _StitchTokens.outlineVariant),
          ),
          title: Text(
            'Change Role: ${user.fullName}',
            style: const TextStyle(
              color: _StitchTokens.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRoleOptionTile(
                label: 'Customer',
                value: 'customer',
                description: 'Standard traveler permissions',
                selectedValue: selectedRole,
                onSelect: (val) => setDialogState(() => selectedRole = val),
              ),
              _buildRoleOptionTile(
                label: 'Admin',
                value: 'admin',
                description: 'Full executive administrative access',
                selectedValue: selectedRole,
                onSelect: (val) => setDialogState(() => selectedRole = val),
              ),
              _buildRoleOptionTile(
                label: 'Support',
                value: 'support',
                description: 'Customer service and moderation capabilities',
                selectedValue: selectedRole,
                onSelect: (val) => setDialogState(() => selectedRole = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: _StitchTokens.onSurfaceVariant),
              ),
            ),
            FilledButton(
              onPressed: () {
                ref
                    .read(userManagementViewModelProvider.notifier)
                    .changeUserRole(user.id, selectedRole);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Updated role for ${user.fullName}'),
                    backgroundColor: _StitchTokens.primaryContainer,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: _StitchTokens.primaryContainer,
                foregroundColor: _StitchTokens.onPrimaryContainer,
              ),
              child: const Text('Save Role'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOptionTile({
    required String label,
    required String value,
    required String description,
    required String selectedValue,
    required ValueChanged<String> onSelect,
  }) {
    final isSelected = selectedValue == value;
    return ListTile(
      onTap: () => onSelect(value),
      title: Text(
        label,
        style: const TextStyle(color: _StitchTokens.onSurface),
      ),
      subtitle: Text(
        description,
        style: const TextStyle(
          color: _StitchTokens.onSurfaceVariant,
          fontSize: 11,
        ),
      ),
      leading: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? _StitchTokens.primaryContainer
                : _StitchTokens.outlineVariant,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: _StitchTokens.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  void _showBanConfirmDialog(BuildContext context, UserManagementModel user) {
    final isBanned = user.status == 'banned';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _StitchTokens.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _StitchTokens.outlineVariant),
        ),
        title: Text(
          isBanned ? 'Unban Account?' : 'Ban / Restrict User?',
          style: TextStyle(
            color: isBanned ? _StitchTokens.primary : _StitchTokens.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          isBanned
              ? 'This will restore full system access for ${user.fullName}.'
              : 'This will restrict access for ${user.fullName} and flag the account in executive audits.',
          style: const TextStyle(color: _StitchTokens.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: _StitchTokens.onSurfaceVariant),
            ),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(userManagementViewModelProvider.notifier)
                  .toggleUserStatus(user.id, user.status);
              Navigator.pop(dialogContext);
            },
            style: FilledButton.styleFrom(
              backgroundColor: isBanned
                  ? _StitchTokens.primaryContainer
                  : _StitchTokens.error,
              foregroundColor: isBanned
                  ? _StitchTokens.onPrimaryContainer
                  : Colors.white,
            ),
            child: Text(isBanned ? 'Unban Account' : 'Confirm Ban'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(userManagementViewModelProvider);

    return AdminScaffold(
      currentPath: RoutePaths.adminUsers,
      body: Scaffold(
        backgroundColor: _StitchTokens.background,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _StitchTokens.primaryContainer.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => _showInviteUserDialog(context),
            backgroundColor: _StitchTokens.primaryContainer,
            foregroundColor: _StitchTokens.onPrimaryContainer,
            elevation: 4,
            child: const Icon(Icons.add, size: 28),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopHeader(context),
              Expanded(
                child: usersAsync.when(
                  data: (users) {
                    final filteredUsers = users.where((u) {
                      final query = _searchController.text.toLowerCase();
                      final searchMatch =
                          u.fullName.toLowerCase().contains(query) ||
                          u.email.toLowerCase().contains(query) ||
                          u.role.toLowerCase().contains(query) ||
                          u.status.toLowerCase().contains(query);

                      final roleMatch =
                          _selectedRoleFilter == 'All Roles' ||
                          u.role.toLowerCase() ==
                              _selectedRoleFilter.toLowerCase();

                      final statusMatch =
                          _selectedStatusFilter == 'All Statuses' ||
                          u.status.toLowerCase() ==
                              _selectedStatusFilter.toLowerCase();

                      return searchMatch && roleMatch && statusMatch;
                    }).toList();

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPageHeader(context),
                          const SizedBox(height: 24),
                          _buildBentoStats(users),
                          const SizedBox(height: 24),
                          _buildFilterBar(),
                          const SizedBox(height: 16),
                          _buildUserTable(filteredUsers),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: _StitchTokens.primaryContainer,
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: _StitchTokens.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Error loading users: $error',
                            style: const TextStyle(
                              color: _StitchTokens.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () =>
                                ref.invalidate(userManagementViewModelProvider),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
          if (MediaQuery.of(context).size.width < 900) ...[
            IconButton(
              icon: const Icon(Icons.menu, color: _StitchTokens.onSurface),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const SizedBox(width: 8),
          ],
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
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: _StitchTokens.onSurfaceVariant,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _StitchTokens.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
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
                      'Alex Rivera',
                      style: TextStyle(
                        color: _StitchTokens.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'MASTER ADMIN',
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
                    'AR',
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

  Widget _buildPageHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        final titleWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'User Management',
              style: TextStyle(
                color: _StitchTokens.onSurface,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Oversee the Voyage community. Manage administrative permissions, monitor account standing, and review registration trends across your global traveler base.',
              style: TextStyle(
                color: _StitchTokens.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        );

        return Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isMobile) titleWidget else Expanded(child: titleWidget),
            if (isMobile) const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.filter_list,
                    size: 18,
                    color: _StitchTokens.onSurface,
                  ),
                  label: const Text(
                    'Advanced Filters',
                    style: TextStyle(
                      color: _StitchTokens.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _StitchTokens.surfaceHigh,
                    side: const BorderSide(color: _StitchTokens.outlineVariant),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showInviteUserDialog(context),
                  icon: const Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 18,
                    color: _StitchTokens.onPrimaryContainer,
                  ),
                  label: const Text(
                    'Invite User',
                    style: TextStyle(
                      color: _StitchTokens.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _StitchTokens.primaryContainer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBentoStats(List<UserManagementModel> users) {
    final totalUsersCount = users.length;
    final activeCount = users.where((u) => u.status == 'active').length;
    final bannedCount = users.where((u) => u.status == 'banned').length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 550
            ? 2
            : 1;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.2,
          children: [
            _BentoUserCard(
              label: 'TOTAL USERS',
              value: '$totalUsersCount',
              badgeText: '+12%',
              badgeColor: _StitchTokens.primaryContainer,
            ),
            _BentoUserCard(
              label: 'ACTIVE NOW',
              value: '$activeCount',
              livePulse: true,
            ),
            _BentoUserCard(
              label: 'NEW REGISTRATIONS',
              value: '482',
              subtext: 'This week',
            ),
            _BentoUserCard(
              label: 'FLAGGED / BANNED',
              value: '$bannedCount',
              valueColor: _StitchTokens.error,
              icon: Icons.gavel,
              iconColor: _StitchTokens.error,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: isWide ? 260 : constraints.maxWidth,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    color: _StitchTokens.onSurface,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search members, roles, status...',
                    hintStyle: const TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 18,
                      color: _StitchTokens.onSurfaceVariant,
                    ),
                    filled: true,
                    fillColor: _StitchTokens.surfaceLow,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: _StitchTokens.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: _StitchTokens.primaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: isWide ? 160 : (constraints.maxWidth - 16) / 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedRoleFilter,
                  dropdownColor: _StitchTokens.surfaceContainer,
                  style: const TextStyle(
                    color: _StitchTokens.onSurface,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _StitchTokens.surfaceLow,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: _StitchTokens.outlineVariant,
                      ),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'All Roles',
                      child: Text('All Roles'),
                    ),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    DropdownMenuItem(
                      value: 'customer',
                      child: Text('Customer'),
                    ),
                    DropdownMenuItem(value: 'support', child: Text('Support')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedRoleFilter = val);
                    }
                  },
                ),
              ),
              SizedBox(
                width: isWide ? 160 : (constraints.maxWidth - 16) / 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedStatusFilter,
                  dropdownColor: _StitchTokens.surfaceContainer,
                  style: const TextStyle(
                    color: _StitchTokens.onSurface,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _StitchTokens.surfaceLow,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: _StitchTokens.outlineVariant,
                      ),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'All Statuses',
                      child: Text('All Statuses'),
                    ),
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'banned', child: Text('Banned')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedStatusFilter = val);
                    }
                  },
                ),
              ),
              IconButton(
                onPressed: () =>
                    ref.invalidate(userManagementViewModelProvider),
                tooltip: 'Refresh list',
                icon: const Icon(
                  Icons.refresh,
                  color: _StitchTokens.onSurfaceVariant,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: _StitchTokens.surfaceLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: _StitchTokens.outlineVariant),
                  ),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserTable(List<UserManagementModel> users) {
    return Container(
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                _StitchTokens.surfaceHigh.withValues(alpha: 0.5),
              ),
              dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.hovered)) {
                  return _StitchTokens.surfaceHighest;
                }
                return _StitchTokens.surfaceLow;
              }),
              horizontalMargin: 24,
              columnSpacing: 32,
              columns: const [
                DataColumn(
                  label: Text(
                    'USER PROFILE',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ROLE',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'STATUS',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'JOIN DATE',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'LAST ACTIVITY',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                DataColumn(
                  numeric: true,
                  label: Text(
                    'ACTIONS',
                    style: TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
              rows: users.isEmpty
                  ? [
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'No members matching criteria',
                              style: TextStyle(
                                color: _StitchTokens.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const DataCell(SizedBox.shrink()),
                          const DataCell(SizedBox.shrink()),
                          const DataCell(SizedBox.shrink()),
                          const DataCell(SizedBox.shrink()),
                          const DataCell(SizedBox.shrink()),
                        ],
                      ),
                    ]
                  : users.map((u) => _buildUserRow(context, u)).toList(),
            ),
          ),
          _buildPaginationFooter(users.length),
        ],
      ),
    );
  }

  DataRow _buildUserRow(BuildContext context, UserManagementModel user) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final isBanned = user.status == 'banned';

    final nameParts = user.fullName.trim().split(' ');
    final initials = nameParts.length >= 2
        ? '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase()
        : user.fullName.isNotEmpty
        ? user.fullName[0].toUpperCase()
        : 'U';

    return DataRow(
      color: isBanned
          ? WidgetStateProperty.all(
              _StitchTokens.errorContainer.withValues(alpha: 0.05),
            )
          : null,
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isBanned
                    ? _StitchTokens.surfaceHighest
                    : _StitchTokens.secondaryContainer,
                child: isBanned
                    ? const Icon(
                        Icons.person_off,
                        size: 20,
                        color: _StitchTokens.onSurfaceVariant,
                      )
                    : Text(
                        initials,
                        style: const TextStyle(
                          color: _StitchTokens.onSecondaryContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: TextStyle(
                      color: _StitchTokens.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      decoration: isBanned ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: _StitchTokens.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(_RoleChip(role: user.role)),
        DataCell(_UserStatusBadge(status: user.status)),
        DataCell(
          Text(
            dateFormat.format(user.createdAt),
            style: const TextStyle(
              color: _StitchTokens.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
        DataCell(
          Text(
            user.lastActivity,
            style: const TextStyle(
              color: _StitchTokens.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Edit Role',
                icon: const Icon(
                  Icons.edit_note,
                  size: 20,
                  color: _StitchTokens.onSurfaceVariant,
                ),
                onPressed: () => _showChangeRoleDialog(context, user),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  size: 20,
                  color: _StitchTokens.onSurfaceVariant,
                ),
                color: _StitchTokens.surfaceContainer,
                onSelected: (action) {
                  if (action == 'toggle_ban') {
                    _showBanConfirmDialog(context, user);
                  } else if (action == 'change_role') {
                    _showChangeRoleDialog(context, user);
                  } else if (action == 'delete') {
                    ref
                        .read(userManagementViewModelProvider.notifier)
                        .deleteUser(user.id);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'change_role',
                    child: const Row(
                      children: [
                        Icon(
                          Icons.admin_panel_settings_outlined,
                          size: 16,
                          color: _StitchTokens.primary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Assign Role',
                          style: TextStyle(color: _StitchTokens.onSurface),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'toggle_ban',
                    child: Row(
                      children: [
                        Icon(
                          isBanned ? Icons.check_circle : Icons.gavel,
                          size: 16,
                          color: isBanned
                              ? _StitchTokens.primary
                              : _StitchTokens.error,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isBanned ? 'Unban Account' : 'Ban Account',
                          style: TextStyle(
                            color: isBanned
                                ? _StitchTokens.onSurface
                                : _StitchTokens.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: _StitchTokens.error,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Delete User',
                          style: TextStyle(color: _StitchTokens.error),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationFooter(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: _StitchTokens.surfaceContainer,
        border: Border(top: BorderSide(color: _StitchTokens.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing 1-$count of 12,842 users',
            style: const TextStyle(
              color: _StitchTokens.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          Row(
            children: const [
              _PageNavBtn(icon: Icons.chevron_left),
              SizedBox(width: 4),
              _PageNavBtn(text: '1', isActive: true),
              SizedBox(width: 4),
              _PageNavBtn(text: '2'),
              SizedBox(width: 4),
              _PageNavBtn(text: '3'),
              SizedBox(width: 4),
              _PageNavBtn(icon: Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }
}

class _BentoUserCard extends StatelessWidget {
  const _BentoUserCard({
    required this.label,
    required this.value,
    this.valueColor,
    this.badgeText,
    this.badgeColor,
    this.livePulse = false,
    this.subtext,
    this.icon,
    this.iconColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final String? badgeText;
  final Color? badgeColor;
  final bool livePulse;
  final String? subtext;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _StitchTokens.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? _StitchTokens.onSurface,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? _StitchTokens.primaryContainer)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badgeText!,
                    style: TextStyle(
                      color: badgeColor ?? _StitchTokens.primaryContainer,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (livePulse)
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: _StitchTokens.primaryContainer,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _StitchTokens.primaryContainer,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Live',
                      style: TextStyle(
                        color: _StitchTokens.primaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              if (subtext != null)
                Text(
                  subtext!,
                  style: const TextStyle(
                    color: _StitchTokens.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              if (icon != null) Icon(icon, color: iconColor, size: 22),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    final lower = role.toLowerCase();
    final isAdmin = lower == 'admin';
    final isSupport = lower == 'support';

    final bg = isAdmin
        ? _StitchTokens.surfaceHighest
        : isSupport
        ? _StitchTokens.secondaryContainer
        : _StitchTokens.surfaceHighest;

    final text = isAdmin
        ? 'Admin'
        : isSupport
        ? 'Support'
        : 'Customer';

    final textColor = isAdmin
        ? _StitchTokens.primaryContainer
        : isSupport
        ? _StitchTokens.onSecondaryContainer
        : _StitchTokens.tertiary;

    final borderColor = isAdmin
        ? _StitchTokens.primary.withValues(alpha: 0.2)
        : isSupport
        ? _StitchTokens.outlineVariant
        : _StitchTokens.tertiary.withValues(alpha: 0.2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _UserStatusBadge extends StatelessWidget {
  const _UserStatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final isBanned = status == 'banned';
    final color = isBanned
        ? _StitchTokens.error
        : _StitchTokens.primaryContainer;
    final label = isBanned ? 'Banned' : 'Active';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: isBanned
                ? [
                    BoxShadow(
                      color: _StitchTokens.error.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isBanned ? _StitchTokens.error : _StitchTokens.onSurface,
            fontSize: 12,
            fontWeight: isBanned ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _PageNavBtn extends StatelessWidget {
  const _PageNavBtn({this.icon, this.text, this.isActive = false});

  final IconData? icon;
  final String? text;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive
            ? _StitchTokens.primaryContainer
            : _StitchTokens.surfaceLow,
        borderRadius: BorderRadius.circular(6),
        border: isActive
            ? null
            : Border.all(color: _StitchTokens.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(6),
          child: Center(
            child: icon != null
                ? Icon(icon, size: 18, color: _StitchTokens.onSurfaceVariant)
                : Text(
                    text ?? '',
                    style: TextStyle(
                      color: isActive
                          ? _StitchTokens.onPrimaryContainer
                          : _StitchTokens.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
