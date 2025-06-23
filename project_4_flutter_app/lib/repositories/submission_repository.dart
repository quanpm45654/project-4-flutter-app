import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/submission.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class SubmissionRepository {
  Future<List<Submission>> fetchSubmissionList(int assignment_id) async {
    final http.Response httpResponse = await http.get(
      Uri.parse('$apiBaseUrl/submissions?assignment_id=$assignment_id'),
    );

    if (httpResponse.statusCode == 200) {
      return (jsonDecode(httpResponse.body) as List)
          .map((json) => Submission.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<Submission> fetchSubmission(int id) async {
    final http.Response httpResponse = await http.get(
      Uri.parse('$apiBaseUrl/submissions/$id'),
    );

    if (httpResponse.statusCode == 200) {
      return Submission.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<Submission> createSubmission(Submission submission) async {
    final http.Response httpResponse = await http.post(
      Uri.parse('$apiBaseUrl/submissions'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(submission.toJson()),
    );

    if (httpResponse.statusCode == 201) {
      return Submission.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<Submission> updateSubmission(Submission submission) async {
    final http.Response httpResponse = await http.put(
      Uri.parse('$apiBaseUrl/submissions/${submission.submission_id}'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(submission.toJson()),
    );

    if (httpResponse.statusCode == 200) {
      return Submission.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<void> deleteSubmission(int id) async {
    final http.Response httpResponse = await http.delete(
      Uri.parse('$apiBaseUrl/submissions/$id'),
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
