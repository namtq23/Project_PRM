class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.avatarUrl,
  });

  final int id;
  final String email;
  final String fullName;
  final String? phone;
  final String? avatarUrl;

  factory ProfileModel.fromMap(Map<String, Object?> map) => ProfileModel(
    id: map['id']! as int,
    email: map['email']! as String,
    fullName: map['full_name']! as String,
    phone: map['phone'] as String?,
    avatarUrl: map['avatar_url'] as String?,
  );
}
