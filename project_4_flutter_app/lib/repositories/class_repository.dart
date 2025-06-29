import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class ClassRepository extends ChangeNotifier {
  List<Class> _classList = [];
  bool _isLoading = false;
  bool _isSuccess = false;
  String _errorMessage = '';
  String _errorMessageSnackBar = '';

  List<Class> get classList => _classList;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String get errorMessage => _errorMessage;

  String get errorMessageSnackBar => _errorMessageSnackBar;

  Future<void> fetchClassList({required num lecturer_id}) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse('$apiBaseUrl/classes?lecturer_id=$lecturer_id'),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _classList = (jsonDecode(httpResponse.body) as List).map((json) => Class.fromJson(json as Map<String, dynamic>)).toList();
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

  Future<void> createClass({required Class classObject}) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      final httpResponse = await http
          .post(
            Uri.parse('$apiBaseUrl/classes'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(classObject.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _isSuccess = true;
        await fetchClassList(lecturer_id: 2);
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

  Future<void> updateClass({required Class classObject}) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      final httpResponse = await http
          .patch(
            Uri.parse('$apiBaseUrl/classes/${classObject.class_id}'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(classObject.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _isSuccess = true;
        int index = _classList.indexWhere((a) => a.class_id == classObject.class_id);
        if (index != -1) {
          _classList[index] = classObject;
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

  Future<void> deleteClass({required num class_id}) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      final httpResponse = await http
          .delete(
            Uri.parse('$apiBaseUrl/classes/$class_id'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _isSuccess = true;
        _classList.removeWhere((a) => a.class_id == class_id);
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
