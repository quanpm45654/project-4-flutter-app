import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/submission.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class SubmissionRepository extends ChangeNotifier {
  List<Submission> _submissionList = [];
  List<Map<dynamic, dynamic>> _assignedList = [];
  bool _isLoading = false;
  bool _isSuccess = false;
  String _errorMessage = '';
  String _errorMessageSnackBar = '';

  List<Submission> get submissionList => _submissionList;

  List<Map<dynamic, dynamic>> get assignedList => _assignedList;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String get errorMessage => _errorMessage;

  String get errorMessageSnackBar => _errorMessageSnackBar;

  Future<void> fetchSubmissionList(int assignment_id) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse('$apiBaseUrl/assignments/$assignment_id/submissions'),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _submissionList = (jsonDecode(httpResponse.body) as List)
            .map((json) => Submission.fromJson(json as Map<String, dynamic>))
            .toList();
        _isSuccess = true;
      } else {
        _errorMessage =
            'An error has occurred: ${jsonDecode(httpResponse.body)}, please try again';
      }
    } catch (error) {
      _errorMessage = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAssignedList(int assignment_id) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse(
              '$apiBaseUrl/assignment-students?assignment_id=$assignment_id',
            ),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _assignedList = (jsonDecode(httpResponse.body) as List).map((json) {
          return {
            'user_id': json['user_id'],
            'full_name': json['full_name'],
            'email': json['email'],
          };
        }).toList();
        _isSuccess = true;
      } else {
        _errorMessage =
            'An error has occurred: ${jsonDecode(httpResponse.body)}, please try again';
      }
    } catch (error) {
      _errorMessage = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> gradeSubmission(Submission submission) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessageSnackBar = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .patch(
            Uri.parse('$apiBaseUrl/submissions/${submission.submission_id}'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(submission.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        int index = _submissionList.indexWhere(
          (a) => a.submission_id == submission.submission_id,
        );
        if (index != -1) {
          _submissionList[index].score = submission.score;
          _submissionList[index].feedback_text = submission.feedback_text;
        }
        _isSuccess = true;
      } else {
        _errorMessageSnackBar =
            'An error has occurred: ${jsonDecode(httpResponse.body)}, please try again';
      }
    } catch (e) {
      _errorMessageSnackBar = 'An error has occurred, please try again';
      developer.log(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
