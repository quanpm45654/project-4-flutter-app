import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id') as int?;
  }
}
