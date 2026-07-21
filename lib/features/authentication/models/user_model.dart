import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int? userId;
  final String fullName;
  final String email;
  final String? phone;
  final String password;
  final String role;

  const UserModel({
    this.userId,
    required this.fullName,
    required this.email,
    this.phone,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'] as int?,
      fullName: map['full_name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String?,
      password: map['password'] as String,
      role: map['role'] as String,
    );
  }

  @override
  List<Object?> get props => [userId, fullName, email, phone, password, role];
}
