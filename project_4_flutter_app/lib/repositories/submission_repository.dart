import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_4_flutter_app/models/submission.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class SubmissionRepository {
  Future<List<Submission>> fetchSubmissionList({required int? assignment_id}) async {
    final httpResponse = await http
        .get(
          Uri.parse('$apiBaseUrlAndroid/submissions?assignment_id=$assignment_id'),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (httpResponse.statusCode == 200) {
      return (jsonDecode(httpResponse.body) as List)
          .map((json) => Submission.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('${httpResponse.statusCode} error fetchSubmissionList');
    }
  }
}
