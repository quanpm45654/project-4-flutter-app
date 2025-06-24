import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/user.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class StudentRepository {
  Future<List<User>> fetchStudentList(int class_id) async {
    final http.Response httpResponse = await http.get(
      Uri.parse('$apiBaseUrl/classes/$class_id/students'),
    );

    if (httpResponse.statusCode == 200) {
      return (jsonDecode(httpResponse.body) as List)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<User> fetchStudent(int id) async {
    final http.Response httpResponse = await http.get(
      Uri.parse('$apiBaseUrl/users/$id'),
    );

    if (httpResponse.statusCode == 200) {
      return User.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<User> addStudent(User student, int class_id, int student_id) async {
    final http.Response httpResponse = await http.post(
      Uri.parse('$apiBaseUrl/classes/$class_id/students/$student_id'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(student.toJson()),
    );

    if (httpResponse.statusCode == 201) {
      return User.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<void> removeStudent(int class_id, int student_id) async {
    final http.Response httpResponse = await http.delete(
      Uri.parse('$apiBaseUrl/classes/$class_id/students/$student_id'),
      headers: {
        HttpHeaders.authorizationHeader: 'token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );

    if (httpResponse.statusCode != 204) {
      throw Exception('${httpResponse.statusCode} error');
    }
  }
}
