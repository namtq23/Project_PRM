class UserManagementModel {
  const UserManagementModel({
    required this.id,
    this.firebaseUid,
    required this.email,
    required this.fullName,
    this.phone,
    this.avatarUrl,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.lastActivity,
  });

  final int id;
  final String? firebaseUid;
  final String email;
  final String fullName;
  final String? phone;
  final String? avatarUrl;
  final String role; // 'admin', 'customer', 'support'
  final String status; // 'active', 'banned'
  final DateTime createdAt;
  final String lastActivity;

  factory UserManagementModel.fromMap(Map<String, Object?> map) =>
      UserManagementModel(
        id: map['id']! as int,
        firebaseUid: map['firebase_uid'] as String?,
        email: map['email']! as String,
        fullName: map['full_name']! as String,
        phone: map['phone'] as String?,
        avatarUrl: map['avatar_url'] as String?,
        role: (map['role'] as String?) ?? 'customer',
        status: (map['status'] as String?) ?? 'active',
        createdAt: DateTime.parse(map['created_at']! as String),
        lastActivity: (map['last_activity'] as String?) ?? 'Active Now',
      );

  Map<String, Object?> toMap() => {
    if (id != 0) 'id': id,
    if (firebaseUid != null) 'firebase_uid': firebaseUid,
    'email': email,
    'full_name': fullName,
    if (phone != null) 'phone': phone,
    if (avatarUrl != null) 'avatar_url': avatarUrl,
    'role': role,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': DateTime.now().toIso8601String(),
  };

  UserManagementModel copyWith({
    int? id,
    String? firebaseUid,
    String? email,
    String? fullName,
    String? phone,
    String? avatarUrl,
    String? role,
    String? status,
    DateTime? createdAt,
    String? lastActivity,
  }) => UserManagementModel(
    id: id ?? this.id,
    firebaseUid: firebaseUid ?? this.firebaseUid,
    email: email ?? this.email,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    role: role ?? this.role,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    lastActivity: lastActivity ?? this.lastActivity,
  );
}
