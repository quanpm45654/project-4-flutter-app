import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/teacher.dart';
import '../utils/constants.dart';

class TeacherRepository extends ChangeNotifier {
  Teacher? _teacher;
  bool _isLoading = false;
  bool _isSuccess = false;
  String _errorMessage = '';
  String _errorMessageSnackBar = '';

  Teacher? get teacher => _teacher;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String get errorMessage => _errorMessage;

  String get errorMessageSnackBar => _errorMessageSnackBar;

  Future<void> fetchTeacher(int teacher_id) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('$apiBaseUrl/api/teachers/$teacher_id'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        _teacher = Teacher.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
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

  Future<void> editProfile(Teacher teacher) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessageSnackBar = '';
    notifyListeners();

    try {
      final response = await http
          .patch(
            Uri.parse('$apiBaseUrl/api/teachers/${teacher.id}'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(teacher.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        _isSuccess = true;
      } else {
        _isSuccess = false;
        _errorMessageSnackBar =
            'An error has occurred: ${jsonDecode(response.body)}, please try again';
      }
    } catch (error) {
      _isSuccess = false;
      _errorMessageSnackBar = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(String old_password, String new_password, int teacher_id) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessageSnackBar = '';
    notifyListeners();

    try {
      final response = await http
          .patch(
            Uri.parse('$apiBaseUrl/api/teachers/$teacher_id/password'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({'old_password': old_password, 'new_password': new_password}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        _isSuccess = true;
      } else {
        _isSuccess = false;
        _errorMessageSnackBar =
            'An error has occurred: ${jsonDecode(response.body)}, please try again';
      }
    } catch (error) {
      _isSuccess = false;
      _errorMessageSnackBar = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
