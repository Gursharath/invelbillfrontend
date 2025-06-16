import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/auth_response.dart';
import '../services/api_service.dart';

class AuthService {
  static Future<AuthResponse?> login(String email, String password) async {
    final response = await ApiService.post(
      ApiConstants.login,
      {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<AuthResponse?> register(
      String name, String email, String password) async {
    final response = await ApiService.post(
      ApiConstants.register,
      {'name': name, 'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<void> logout(String token) async {
    await ApiService.post(ApiConstants.logout, {}, withAuth: true);
  }
}
