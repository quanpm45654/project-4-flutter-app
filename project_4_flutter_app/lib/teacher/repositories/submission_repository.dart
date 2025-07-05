import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/submission.dart';
import '../utils/constants.dart';

class SubmissionRepository extends ChangeNotifier {
  List<Submission> _submissionList = [];
  bool _isLoading = false;
  bool _isSuccess = false;
  String _errorMessage = '';

  List<Submission> get submissionList => _submissionList;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String get errorMessage => _errorMessage;

  Future<void> fetchSubmissionList(int assignment_id) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('$apiBaseUrl/api/teacher/assignments/$assignment_id/submissions'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        _submissionList = (jsonDecode(response.body) as List)
            .map((json) => Submission.fromJson(json as Map<String, dynamic>))
            .toList();
        _isSuccess = true;
      } else {
        _isSuccess = false;
        _errorMessage = 'An error has occurred: ${jsonDecode(response.body)}, please try again';
      }
    } catch (error) {
      _isSuccess = false;
      _errorMessage = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
