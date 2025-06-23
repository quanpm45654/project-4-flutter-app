import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class AssignmentRepository {
  Future<List<Assignment>> fetchAssignmentList() async {
    final http.Response httpResponse = await http.get(
      Uri.parse('$apiBaseUrl/assignments'),
    );

    if (httpResponse.statusCode == 200) {
      return (jsonDecode(httpResponse.body) as List)
          .map((json) => Assignment.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<Assignment> fetchAssignment(int id) async {
    final http.Response httpResponse = await http.get(
      Uri.parse('$apiBaseUrl/assignments/$id'),
    );

    if (httpResponse.statusCode == 200) {
      return Assignment.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<Assignment> createAssignment(Assignment assignment) async {
    final http.Response httpResponse = await http.post(
      Uri.parse('$apiBaseUrl/assignments'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(assignment.toJson()),
    );

    if (httpResponse.statusCode == 201) {
      return Assignment.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<Assignment> updateAssignment(Assignment assignment) async {
    final http.Response httpResponse = await http.put(
      Uri.parse('$apiBaseUrl/assignments/${assignment.assignment_id}'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(assignment.toJson()),
    );

    if (httpResponse.statusCode == 200) {
      return Assignment.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<void> deleteAssignment(int id) async {
    final http.Response httpResponse = await http.delete(
      Uri.parse('$apiBaseUrl/assignments/$id'),
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
