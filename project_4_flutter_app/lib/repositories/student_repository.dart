import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/user.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class StudentRepository {
  Future<List<User>> fetchStudentList({int? class_id}) async {
    final httpResponse = await http
        .get(
          Uri.parse('$apiBaseUrl/users?class_id=$class_id'),
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

  Future<User> fetchStudent(int id) async {
    final httpResponse = await http
        .get(
          Uri.parse('$apiBaseUrl/users/$id'),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode == 200) {
      return User.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error fetchStudent');
    }
  }

  Future<User> addStudent(User student, int class_id, int student_id) async {
    final httpResponse = await http
        .post(
          Uri.parse('$apiBaseUrl/classes/$class_id/students/$student_id'),
          headers: <String, String>{
            HttpHeaders.authorizationHeader: 'token',
          },
          body: jsonEncode(
            student.toJson(),
          ),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode == 201) {
      return User.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error addStudent');
    }
  }

  Future<void> removeStudent(int class_id, int student_id) async {
    final httpResponse = await http
        .delete(
          Uri.parse('$apiBaseUrl/classes/$class_id/students/$student_id'),
          headers: {
            HttpHeaders.authorizationHeader: 'token',
          },
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode != 204) {
      throw Exception('${httpResponse.statusCode} error removeStudent');
    }
  }
}
