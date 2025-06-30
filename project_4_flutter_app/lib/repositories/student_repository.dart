import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/student.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class StudentRepository extends ChangeNotifier {
  List<Student> _studentList = [];
  bool _isLoading = false;
  bool _isSuccess = false;
  String _errorMessage = '';
  String _errorMessageSnackBar = '';

  List<Student> get studentList => _studentList;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String get errorMessage => _errorMessage;

  String get errorMessageSnackBar => _errorMessageSnackBar;

  Future<void> fetchClassStudentList(int class_id) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse('$apiBaseUrl/students?class_id=$class_id'),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _studentList = (jsonDecode(httpResponse.body) as List).map((json) => Student.fromJson(json as Map<String, dynamic>)).toList();
        _isSuccess = true;
      } else {
        throw Exception('${httpResponse.statusCode} error');
      }
    } catch (error) {
      _errorMessage = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addStudentToClass(int class_id, String email) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      final httpResponse = await http
          .post(
            Uri.parse('$apiBaseUrl/students'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({'email': email, 'class_id': class_id}),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _isSuccess = true;
        await fetchClassStudentList(class_id);
      } else {
        throw Exception('${httpResponse.statusCode} error');
      }
    } catch (error) {
      _errorMessageSnackBar = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeStudentFromClass(int class_id, int student_id) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      final httpResponse = await http
          .delete(
            Uri.parse('$apiBaseUrl/students'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({'student_id': student_id, 'class_id': class_id}),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _isSuccess = true;
        _studentList.removeWhere((a) => a.user_id == student_id);
      } else {
        throw Exception('${httpResponse.statusCode} error');
      }
    } catch (error) {
      _errorMessageSnackBar = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
