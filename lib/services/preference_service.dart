import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String tokenKey = "token";
  static const String userNameKey = "username";
  static const String userIdKey = "user_id";
  static const String roleKey = "role";
  

  Future<void> saveLogin({
    required String token,
    required int userId,
    required String username,
    required String role,
    
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(tokenKey, token);
    await prefs.setInt(userIdKey, userId);
    await prefs.setString(userNameKey, username);
    await prefs.setString(roleKey, role);
    
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  
}