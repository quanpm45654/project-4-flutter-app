import 'package:project_4_flutter_app/utils/enums.dart';
import 'package:project_4_flutter_app/utils/functions.dart';

class Student {
  int user_id;
  String full_name;
  String email;
  Role role;
  DateTime joined_at;

  Student(
    this.user_id,
    this.full_name,
    this.email,
    this.role,
    this.joined_at,
  );

  Map<String, dynamic> toJson() => {
    'user_id': user_id,
    'full_name': full_name,
    'email': email,
    'role': role.toString(),
  };

  factory Student.fromJson(Map<String, dynamic> json) {
    var user_id = json['user_id'] as int;
    var full_name = json['full_name'] as String;
    var email = json['email'] as String;
    var role = CustomParser.parseRole(json['role'] as String);
    var joined_at = DateTime.parse(json['joined_at'] as String);

    return Student(user_id, full_name, email, role, joined_at);
  }
}
