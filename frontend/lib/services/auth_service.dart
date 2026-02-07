import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/user_model.dart';

// Adeegga Aqoonsiga (Auth Service)
class AuthService {
  // Register
  Future<User> register(String name, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      final userData = jsonDecode(response.body);
      return User.fromJson(userData);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Diiwangelintu way fashilantay');
    }
  }

  // Galitaanka (Login)
  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      final user = User.fromJson(userData);
      await _saveUser(user);
      return user;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login-ku waa fashilmay');
    }
  }

  // Kaydinta xogta isticmaalaha
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, user.token ?? '');
    await prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
  }

  // Ka bixitaanka (Logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
  }

  // Helitaanka isticmaalaha hadda jira
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }
}
