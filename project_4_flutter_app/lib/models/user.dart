import 'package:project_4_flutter_app/utils/enums.dart';
import 'package:project_4_flutter_app/utils/functions.dart';

class User {
  final int user_id;
  final String full_name;
  final String email;
  final Role role;

  User({
    required this.user_id,
    required this.full_name,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'user_id': user_id,
    'full_name': full_name,
    'email': email,
    'role': role,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user_id: json['user_id'] as int,
      full_name: json['full_name'] as String,
      email: json['email'] as String,
      role: CustomParser.parseRole(json['role'] as String),
    );
  }
}
