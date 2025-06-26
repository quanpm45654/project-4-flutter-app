import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class AssignmentRepository {
  Future<List<Assignment>> fetchClassAssignmentList({
    required int class_id,
    required int lecturer_id,
  }) async {
    final httpResponse = await http
        .get(
          Uri.parse('$apiBaseUrlAndroid/assignments?class_id=$class_id&lecturer_id=$lecturer_id'),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode == 200) {
      return (jsonDecode(httpResponse.body) as List<dynamic>)
          .map((json) => Assignment.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('${httpResponse.statusCode} error fetchClassAssignmentList');
    }
  }

  Future<List<Assignment>> fetchAssignmentList({
    required int lecturer_id,
  }) async {
    final httpResponse = await http
        .get(
          Uri.parse('$apiBaseUrlAndroid/assignments?lecturer_id=$lecturer_id'),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode == 200) {
      return (jsonDecode(httpResponse.body) as List<dynamic>)
          .map((json) => Assignment.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('${httpResponse.statusCode} error fetchAssignmentList');
    }
  }

  Future<Assignment> createAssignment({required Assignment assignment}) async {
    final httpResponse = await http
        .post(
          Uri.parse('$apiBaseUrlAndroid/assignments'),
          headers: <String, String>{
            HttpHeaders.authorizationHeader: 'token',
          },
          body: jsonEncode(
            assignment.toJson(),
          ),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode == 201) {
      return Assignment.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error createAssignment');
    }
  }

  Future<Assignment> updateAssignment({
    required int assignment_id,
    required Assignment assignment,
  }) async {
    final httpResponse = await http
        .put(
          Uri.parse('$apiBaseUrlAndroid/assignments/$assignment_id'),
          headers: <String, String>{
            HttpHeaders.authorizationHeader: 'token',
          },
          body: jsonEncode(
            assignment.toJson(),
          ),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode == 200) {
      return Assignment.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error updateAssignment');
    }
  }
}
