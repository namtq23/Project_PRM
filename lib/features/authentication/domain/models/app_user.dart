class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.authProvider,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.firebaseUid,
    this.phone,
    this.avatarUrl,
  });

  final int id;
  final String? firebaseUid;
  final String email;
  final String fullName;
  final String? phone;
  final String? avatarUrl;
  final String authProvider;
  final String role;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory AppUser.fromMap(Map<String, Object?> map) => AppUser(
    id: map['id']! as int,
    firebaseUid: map['firebase_uid'] as String?,
    email: map['email']! as String,
    fullName: map['full_name']! as String,
    phone: map['phone'] as String?,
    avatarUrl: map['avatar_url'] as String?,
    authProvider: map['auth_provider']! as String,
    role: map['role']! as String,
    status: map['status']! as String,
    createdAt: DateTime.parse(map['created_at']! as String),
    updatedAt: DateTime.parse(map['updated_at']! as String),
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'firebase_uid': firebaseUid,
    'email': email,
    'full_name': fullName,
    'phone': phone,
    'avatar_url': avatarUrl,
    'auth_provider': authProvider,
    'role': role,
    'status': status,
    'created_at': createdAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
  };
}
