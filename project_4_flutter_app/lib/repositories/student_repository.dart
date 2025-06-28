import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/student.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class StudentRepository extends ChangeNotifier {
  List<Student> _studentList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Student> get studentList => _studentList;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  Future<void> fetchClassStudentList({required num class_id}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse('$apiBaseUrlAndroid/students?class_id=$class_id'),
          )
          .timeout(const Duration(seconds: 10));

      if (httpResponse.statusCode == 200) {
        _studentList = (jsonDecode(httpResponse.body) as List)
            .map((json) => Student.fromJson(json as Map<String, dynamic>))
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
}
