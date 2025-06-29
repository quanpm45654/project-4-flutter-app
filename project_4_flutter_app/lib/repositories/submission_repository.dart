import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/submission.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class SubmissionRepository extends ChangeNotifier {
  List<Submission> _submissionList = [];
  List<Map<dynamic, dynamic>> _assignedList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Submission> get submissionList => _submissionList;

  List<Map<dynamic, dynamic>> get assignedList => _assignedList;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  Future<void> fetchSubmissionList({required num assignment_id}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse('$apiBaseUrlAndroid/submissions?assignment_id=$assignment_id'),
          )
          .timeout(const Duration(seconds: 10));

      if (httpResponse.statusCode == 200) {
        _submissionList = (jsonDecode(httpResponse.body) as List)
            .map((json) => Submission.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _errorMessage = '${httpResponse.statusCode} error';
        developer.log('${httpResponse.statusCode} error');
      }
    } on TimeoutException {
      _errorMessage = 'The connection has timed out, please try again';
      developer.log('The connection has timed out');
    } catch (error) {
      _errorMessage = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAssignedList({required num assignment_id}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse('$apiBaseUrlAndroid/assignments-students?assignment_id=$assignment_id'),
          )
          .timeout(const Duration(seconds: 10));

      if (httpResponse.statusCode == 200) {
        _assignedList = (jsonDecode(httpResponse.body) as List).map((json) {
          return {
            'user_id': json['user_id'],
            'full_name': json['full_name'],
            'email': json['email'],
          };
        }).toList();
      } else {
        _errorMessage = '${httpResponse.statusCode} error';
        developer.log('${httpResponse.statusCode} error');
      }
    } on TimeoutException {
      _errorMessage = 'The connection has timed out, please try again';
      developer.log('The connection has timed out');
    } catch (error) {
      _errorMessage = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
