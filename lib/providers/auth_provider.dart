import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/shared_prefs.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Future<bool> login(String email, String password) async {
    final res = await AuthService.login(email, password);
    if (res != null) {
      _token = res.token;
      _user = res.user;
      await SharedPrefs.saveToken(_token!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    final res = await AuthService.register(name, email, password);
    if (res != null) {
      _token = res.token;
      _user = res.user;
      await SharedPrefs.saveToken(_token!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await AuthService.logout(_token ?? '');
    _token = null;
    _user = null;
    await SharedPrefs.removeToken();
    notifyListeners();
  }
}
