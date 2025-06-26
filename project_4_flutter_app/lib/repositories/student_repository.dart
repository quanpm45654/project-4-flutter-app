import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/user.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class StudentRepository {
  Future<List<User>> fetchStudentList({int? class_id}) async {
    final httpResponse = await http
        .get(
          Uri.parse('$apiBaseUrlAndroid/users?class_id=$class_id'),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode == 200) {
      return (jsonDecode(httpResponse.body) as List)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('${httpResponse.statusCode} error fetchStudentList');
    }
  }
}
