class SystemSettingsModel {
  const SystemSettingsModel({
    required this.platformName,
    required this.supportEmail,
    required this.supportPhone,
    required this.companyAddress,
    required this.generalTerms,
    required this.isMaintenanceMode,
    required this.metaTitleTemplate,
    required this.bookingConfirmationsEnabled,
    required this.internalAlertsEnabled,
    required this.reviewInvitationsEnabled,
  });

  final String platformName;
  final String supportEmail;
  final String supportPhone;
  final String companyAddress;
  final String generalTerms;
  final bool isMaintenanceMode;
  final String metaTitleTemplate;
  final bool bookingConfirmationsEnabled;
  final bool internalAlertsEnabled;
  final bool reviewInvitationsEnabled;

  factory SystemSettingsModel.defaults() => const SystemSettingsModel(
    platformName: 'Voyage Luxury Travel',
    supportEmail: 'concierge@voyage.luxury',
    supportPhone: '+1 (800) 555-8692',
    companyAddress: '100 Executive Way, Suite 400, New York, NY',
    generalTerms:
        'Curated luxury travel experiences for the executive traveler. Discover the world\'s most exclusive destinations with Voyage Admin Suite.',
    isMaintenanceMode: false,
    metaTitleTemplate: '{destination} | Exclusive Tours by Voyage',
    bookingConfirmationsEnabled: true,
    internalAlertsEnabled: true,
    reviewInvitationsEnabled: false,
  );

  factory SystemSettingsModel.fromMap(
    Map<String, dynamic> map,
  ) => SystemSettingsModel(
    platformName: (map['platform_name'] as String?) ?? 'Voyage Luxury Travel',
    supportEmail:
        (map['support_email'] as String?) ?? 'concierge@voyage.luxury',
    supportPhone: (map['support_phone'] as String?) ?? '+1 (800) 555-8692',
    companyAddress:
        (map['company_address'] as String?) ??
        '100 Executive Way, Suite 400, New York, NY',
    generalTerms:
        (map['general_terms'] as String?) ??
        'Curated luxury travel experiences for the executive traveler. Discover the world\'s most exclusive destinations with Voyage Admin Suite.',
    isMaintenanceMode: (map['is_maintenance_mode'] as bool?) ?? false,
    metaTitleTemplate:
        (map['meta_title_template'] as String?) ??
        '{destination} | Exclusive Tours by Voyage',
    bookingConfirmationsEnabled:
        (map['booking_confirmations_enabled'] as bool?) ?? true,
    internalAlertsEnabled: (map['internal_alerts_enabled'] as bool?) ?? true,
    reviewInvitationsEnabled:
        (map['review_invitations_enabled'] as bool?) ?? false,
  );

  Map<String, dynamic> toMap() => {
    'platform_name': platformName,
    'support_email': supportEmail,
    'support_phone': supportPhone,
    'company_address': companyAddress,
    'general_terms': generalTerms,
    'is_maintenance_mode': isMaintenanceMode,
    'meta_title_template': metaTitleTemplate,
    'booking_confirmations_enabled': bookingConfirmationsEnabled,
    'internal_alerts_enabled': internalAlertsEnabled,
    'review_invitations_enabled': reviewInvitationsEnabled,
  };

  SystemSettingsModel copyWith({
    String? platformName,
    String? supportEmail,
    String? supportPhone,
    String? companyAddress,
    String? generalTerms,
    bool? isMaintenanceMode,
    String? metaTitleTemplate,
    bool? bookingConfirmationsEnabled,
    bool? internalAlertsEnabled,
    bool? reviewInvitationsEnabled,
  }) => SystemSettingsModel(
    platformName: platformName ?? this.platformName,
    supportEmail: supportEmail ?? this.supportEmail,
    supportPhone: supportPhone ?? this.supportPhone,
    companyAddress: companyAddress ?? this.companyAddress,
    generalTerms: generalTerms ?? this.generalTerms,
    isMaintenanceMode: isMaintenanceMode ?? this.isMaintenanceMode,
    metaTitleTemplate: metaTitleTemplate ?? this.metaTitleTemplate,
    bookingConfirmationsEnabled:
        bookingConfirmationsEnabled ?? this.bookingConfirmationsEnabled,
    internalAlertsEnabled: internalAlertsEnabled ?? this.internalAlertsEnabled,
    reviewInvitationsEnabled:
        reviewInvitationsEnabled ?? this.reviewInvitationsEnabled,
  );
}
