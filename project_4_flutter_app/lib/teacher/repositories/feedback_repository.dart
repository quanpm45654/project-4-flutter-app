import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart' hide Feedback;
import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/teacher/models/feedback.dart';
import 'package:project_4_flutter_app/teacher/utils/constants.dart';

class FeedbackRepository extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSuccess = false;
  String _errorMessageSnackBar = '';

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String get errorMessageSnackBar => _errorMessageSnackBar;

  Future<void> sendFeedback(Feedback feedback) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessageSnackBar = '';
    notifyListeners();

    try {
      final response = await http
          .put(
            Uri.parse('$apiBaseUrl/api/teacher/feedbacks'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(feedback.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        _isSuccess = true;
      } else {
        _errorMessageSnackBar =
            'An error has occurred: ${jsonDecode(response.body)}, please try again';
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
