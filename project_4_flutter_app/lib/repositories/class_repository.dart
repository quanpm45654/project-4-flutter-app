import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class ClassRepository {
  Future<List<Class>> fetchClassList({required int lecturer_id}) async {
    final httpResponse = await http
        .get(
          Uri.parse('$apiBaseUrlAndroid/classes?lecturer_id=$lecturer_id'),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode == 200) {
      return (jsonDecode(httpResponse.body) as List)
          .map((json) => Class.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('${httpResponse.statusCode} error fetchClassList');
    }
  }

  Future<Class> createClass({required Class classObject}) async {
    final httpResponse = await http
        .post(
          Uri.parse('$apiBaseUrlAndroid/classes'),
          headers: <String, String>{
            HttpHeaders.authorizationHeader: 'token',
          },
          body: jsonEncode(
            classObject.toJson(),
          ),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode == 201) {
      return Class.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error createClass');
    }
  }

  Future<Class> updateClass({required int class_id, required Class classObject}) async {
    final httpResponse = await http
        .put(
          Uri.parse('$apiBaseUrlAndroid/classes/$class_id'),
          headers: <String, String>{
            HttpHeaders.authorizationHeader: 'token',
          },
          body: jsonEncode(
            classObject.toJson(),
          ),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode == 200) {
      return Class.fromJson(jsonDecode(httpResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('${httpResponse.statusCode} error updateClass');
    }
  }
}
