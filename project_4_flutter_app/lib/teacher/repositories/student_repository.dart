import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/teacher/models/student.dart';
import 'package:project_4_flutter_app/teacher/utils/constants.dart';

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
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('$apiBaseUrl/api/teacher/classes/$class_id/students'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        _studentList = (jsonDecode(response.body) as List)
            .map((json) => Student.fromJson(json as Map<String, dynamic>))
            .toList();
        _studentList.sort((a, b) => b.enrollment_id.compareTo(a.enrollment_id));
        _isSuccess = true;
      } else {
        _errorMessage = 'An error has occurred: ${jsonDecode(response.body)}, please try again';
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
    _errorMessageSnackBar = '';
    notifyListeners();

    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/teacher/classes/$class_id/students'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        fetchClassStudentList(class_id);
        _studentList.sort((a, b) => b.enrollment_id.compareTo(a.enrollment_id));
        _isSuccess = true;
      } else {
        _errorMessageSnackBar =
            'An error has occurred: ${jsonDecode(response.body)}, please try again';
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
    _errorMessageSnackBar = '';
    notifyListeners();

    try {
      final response = await http
          .delete(
            Uri.parse(
              '$apiBaseUrl/api/teacher/classes/$class_id/students/$student_id',
            ),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        _studentList.removeWhere((a) => a.id == student_id);
        _isSuccess = true;
      } else {
        _errorMessageSnackBar =
            'An error has occurred: ${jsonDecode(response.body)}, please try again';
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
