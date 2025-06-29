import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class AssignmentRepository extends ChangeNotifier {
  List<Assignment> _assignmentList = [];
  bool _isLoading = false;
  bool _isSuccess = false;
  String _errorMessage = '';
  String _errorMessageSnackBar = '';

  List<Assignment> get assignmentList => _assignmentList;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String get errorMessage => _errorMessage;

  String get errorMessageSnackBar => _errorMessageSnackBar;

  Future<void> fetchAssignmentList({required num class_id, required num lecturer_id}) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse('$apiBaseUrl/assignments?class_id=$class_id&lecturer_id=$lecturer_id'),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _assignmentList = (jsonDecode(httpResponse.body) as List<dynamic>).map((json) => Assignment.fromJson(json as Map<String, dynamic>)).toList();
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

  Future<void> createAssignment({required Assignment assignment}) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      final httpResponse = await http
          .post(
            Uri.parse('$apiBaseUrl/assignments'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(assignment.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _isSuccess = true;
        await fetchAssignmentList(class_id: assignment.class_id, lecturer_id: 2);
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

  Future<void> updateAssignment({required Assignment assignment}) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      final httpResponse = await http
          .patch(
            Uri.parse('$apiBaseUrl/assignments/${assignment.assignment_id}'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(assignment.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _isSuccess = true;
        int index = _assignmentList.indexWhere((a) => a.assignment_id == assignment.assignment_id);
        if (index != -1) {
          _assignmentList[index] = assignment;
        }
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

  Future<void> deleteAssignment({required num assignment_id}) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      final httpResponse = await http
          .delete(
            Uri.parse('$apiBaseUrl/assignments/$assignment_id'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _isSuccess = true;
        _assignmentList.removeWhere((a) => a.assignment_id == assignment_id);
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
