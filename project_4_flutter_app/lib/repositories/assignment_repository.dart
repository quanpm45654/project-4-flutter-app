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
  String _errorMessage = '';
  String _errorMessageSnackBar = '';

  List<Assignment> get assignmentList => _assignmentList;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  String get errorMessageSnackBar => _errorMessageSnackBar;

  Future<void> fetchClassAssignmentList({required num class_id, required num lecturer_id}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse('$apiBaseUrlAndroid/assignments?class_id=$class_id&lecturer_id=$lecturer_id'),
          )
          .timeout(const Duration(seconds: 10));

      if (httpResponse.statusCode == 200) {
        _assignmentList = (jsonDecode(httpResponse.body) as List<dynamic>)
            .map((json) => Assignment.fromJson(json as Map<String, dynamic>))
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

  Future<void> createAssignment({required Assignment assignment}) async {
    _isLoading = true;
    _errorMessageSnackBar = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .post(
            Uri.parse('$apiBaseUrlAndroid/assignments'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(assignment.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (httpResponse.statusCode == 201) {
        _assignmentList.add(
          Assignment.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>),
        );
      } else {
        _errorMessageSnackBar = '${httpResponse.statusCode} error';
        developer.log('${httpResponse.statusCode} error');
      }
    } on TimeoutException {
      _errorMessageSnackBar = 'The connection has timed out, please try again';
      developer.log('The connection has timed out');
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
    _errorMessageSnackBar = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .patch(
            Uri.parse('$apiBaseUrlAndroid/assignments/${assignment.assignment_id}'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(assignment.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (httpResponse.statusCode == 200) {
        int index = _assignmentList.indexWhere((a) => a.assignment_id == assignment.assignment_id);
        if (index != -1) {
          _assignmentList[index] = Assignment.fromJson(
            jsonDecode(httpResponse.body) as Map<String, dynamic>,
          );
        }
      } else {
        _errorMessageSnackBar = '${httpResponse.statusCode} error';
        developer.log('${httpResponse.statusCode} error');
      }
    } on TimeoutException {
      _errorMessageSnackBar = 'The connection has timed out, please try again';
      developer.log('The connection has timed out, please try again');
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
    _errorMessage = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .delete(
            Uri.parse('$apiBaseUrlAndroid/assignments/$assignment_id'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (httpResponse.statusCode == 204) {
        _assignmentList.removeWhere((a) => a.assignment_id == assignment_id);
      } else {
        _errorMessageSnackBar = '${httpResponse.statusCode} error';
        developer.log('${httpResponse.statusCode} error');
      }
    } on TimeoutException {
      _errorMessageSnackBar = 'The connection has timed out, please try again';
      developer.log('The connection has timed out, please try again');
    } catch (error) {
      _errorMessageSnackBar = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
