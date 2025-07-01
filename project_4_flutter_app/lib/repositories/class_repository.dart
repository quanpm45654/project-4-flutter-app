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

  Future<void> fetchClassList(int lecturer_id) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse('$apiBaseUrl/classes?lecturer_id=$lecturer_id'),
          )
          .timeout(const Duration(seconds: 30));

      if (httpResponse.statusCode == 200) {
        _classList = (jsonDecode(httpResponse.body) as List)
            .map((json) => Class.fromJson(json as Map<String, dynamic>))
            .toList();
        _classList.sort((a, b) => b.class_id.compareTo(a.class_id));
        _isSuccess = true;
      } else {
        throw Exception(
          '${httpResponse.statusCode} error ${jsonDecode(httpResponse.body)}',
        );
      }
    } catch (error) {
      _errorMessage = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createClass(Class classObject) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessageSnackBar = '';
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
        classObject.class_id = jsonDecode(httpResponse.body) as int;
        _classList.add(classObject);
        _classList.sort((a, b) => b.class_id.compareTo(a.class_id));
        _isSuccess = true;
      } else {
        throw Exception(
          '${httpResponse.statusCode} error ${jsonDecode(httpResponse.body)}',
        );
      }
    } catch (error) {
      _errorMessageSnackBar = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateClass(Class classObject) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessageSnackBar = '';
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
        int index = _classList.indexWhere(
          (a) => a.class_id == classObject.class_id,
        );
        if (index != -1) {
          _classList[index] = classObject;
        }
        _isSuccess = true;
      } else {
        throw Exception(
          '${httpResponse.statusCode} error ${jsonDecode(httpResponse.body)}',
        );
      }
    } catch (error) {
      _errorMessageSnackBar = 'An error has occurred, please try again';
      developer.log(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteClass(int class_id) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessageSnackBar = '';
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
        _classList.removeWhere((a) => a.class_id == class_id);
        _isSuccess = true;
      } else {
        throw Exception(
          '${httpResponse.statusCode} error ${jsonDecode(httpResponse.body)}',
        );
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
