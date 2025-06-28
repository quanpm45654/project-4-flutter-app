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
  String _errorMessage = '';
  String _errorMessageSnackBar = '';

  List<Class> get classList => _classList;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  String get errorMessageSnackBar => _errorMessageSnackBar;

  Future<void> fetchClassList({required num lecturer_id}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .get(
            Uri.parse('$apiBaseUrlAndroid/classes?lecturer_id=$lecturer_id'),
          )
          .timeout(const Duration(seconds: 10));

      if (httpResponse.statusCode == 200) {
        _classList = (jsonDecode(httpResponse.body) as List)
            .map((json) => Class.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _errorMessage = '${httpResponse.statusCode} error';
        developer.log('${httpResponse.statusCode} error');
      }
    } on TimeoutException {
      _errorMessage = 'The connection has timed out, please try again';
      developer.log('The connection has timed out, please try again');
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
    _errorMessageSnackBar = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .post(
            Uri.parse('$apiBaseUrlAndroid/classes'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(classObject.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (httpResponse.statusCode == 201) {
        _classList.add(Class.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>));
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

  Future<void> updateClass({required Class classObject}) async {
    _isLoading = true;
    _errorMessageSnackBar = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .patch(
            Uri.parse('$apiBaseUrlAndroid/classes/${classObject.class_id}'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(classObject.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (httpResponse.statusCode == 200) {
        int index = _classList.indexWhere((c) => c.class_id == classObject.class_id);
        if (index != -1) {
          _classList[index] = Class.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
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

  Future<void> deleteClass({required num class_id}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final httpResponse = await http
          .delete(
            Uri.parse('$apiBaseUrlAndroid/classes/$class_id'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (httpResponse.statusCode == 204) {
        _classList.removeWhere((c) => c.class_id == class_id);
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
}
