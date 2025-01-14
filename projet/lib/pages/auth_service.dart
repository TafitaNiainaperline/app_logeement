import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserSession(String userId, String nom, String telephone) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
  await prefs.setString('nom', nom);
  await prefs.setString('telephone', telephone);
}

Future<Map<String, String?>> getUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'userId': prefs.getString('userId'),
    'nom': prefs.getString('nom'),
    'telephone': prefs.getString('telephone'),
  };
}
