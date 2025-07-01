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

  Future<void> fetchAssignmentList(int class_id) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse('$apiBaseUrl/assignments?class_id=$class_id'),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _assignmentList = (jsonDecode(httpResponse.body) as List<dynamic>)
            .map((json) => Assignment.fromJson(json as Map<String, dynamic>))
            .toList();
        _assignmentList.sort(
          (a, b) => b.assignment_id.compareTo(a.assignment_id),
        );
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

  Future<void> createAssignment(Assignment assignment) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessageSnackBar = '';
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
        assignment.assignment_id = jsonDecode(httpResponse.body) as int;
        _assignmentList.add(assignment);
        _assignmentList.sort(
          (a, b) => b.assignment_id.compareTo(a.assignment_id),
        );
        _isSuccess = true;
      } else {
        _errorMessageSnackBar =
            'An error has occurred: ${jsonDecode(httpResponse.body)}, please try again';
      }
    } catch (error) {
      _errorMessageSnackBar = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAssignment(Assignment assignment) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessageSnackBar = '';
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
        int index = _assignmentList.indexWhere(
          (a) => a.assignment_id == assignment.assignment_id,
        );
        if (index != -1) {
          _assignmentList[index] = assignment;
        }
        _isSuccess = true;
      } else {
        _errorMessageSnackBar =
            'An error has occurred: ${jsonDecode(httpResponse.body)}, please try again';
      }
    } catch (error) {
      _errorMessageSnackBar = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAssignment(int assignment_id) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessageSnackBar = '';
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
        _assignmentList.removeWhere((a) => a.assignment_id == assignment_id);
        _isSuccess = true;
      } else {
        _errorMessageSnackBar =
            'An error has occurred: ${jsonDecode(httpResponse.body)}, please try again';
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
