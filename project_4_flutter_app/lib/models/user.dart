import 'package:project_4_flutter_app/utils/enums.dart';

class User {
  final int id;
  final String full_name;
  final String email;
  final String password_hash;
  final Role role;

  User({
    required this.id,
    required this.full_name,
    required this.email,
    required this.password_hash,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': full_name,
    'email': email,
    'password_hash': password_hash,
    'role': role,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      full_name: json['full_name'] as String,
      email: json['email'] as String,
      password_hash: json['password_hash'] as String,
      role: json['role'] as Role,
    );
  }
}