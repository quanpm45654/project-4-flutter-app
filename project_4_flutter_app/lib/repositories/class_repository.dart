import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class ClassRepository {
  Future<List<Class>> fetchClassList(int lecturer_id) async {
    final http.Response httpResponse = await http.get(
      Uri.parse('$apiBaseUrl/classes?lecturer_id=$lecturer_id'),
    );

    if (httpResponse.statusCode == 200) {
      return (jsonDecode(httpResponse.body) as List)
          .map((json) => Class.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<Class> fetchClass(int id) async {
    final http.Response httpResponse = await http.get(
      Uri.parse('$apiBaseUrl/classes/$id'),
    );

    if (httpResponse.statusCode == 200) {
      return Class.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<Class> createClass(Class classObject) async {
    final http.Response httpResponse = await http.post(
      Uri.parse('$apiBaseUrl/classes'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(classObject.toJson()),
    );

    if (httpResponse.statusCode == 201) {
      return Class.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<Class> updateClass(Class classObject) async {
    final http.Response httpResponse = await http.put(
      Uri.parse('$apiBaseUrl/classes/${classObject.id}'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(classObject.toJson()),
    );

    if (httpResponse.statusCode == 200) {
      return Class.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error');
    }
  }

  Future<void> deleteClass(int id) async {
    final http.Response httpResponse = await http.delete(
      Uri.parse('$apiBaseUrl/classes/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );

    if (httpResponse.statusCode != 204) {
      throw Exception('${httpResponse.statusCode} error');
    }
  }
}
