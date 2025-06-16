import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/shared_prefs.dart';

class ApiService {
  static Future<Map<String, String>> getHeaders({bool withAuth = false}) async {
    String? token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      if (withAuth && token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String url, {bool withAuth = false}) async {
    return await http.get(Uri.parse(url),
        headers: await getHeaders(withAuth: withAuth));
  }

  static Future<http.Response> post(String url, Map<String, dynamic> body,
      {bool withAuth = false}) async {
    return await http.post(Uri.parse(url),
        headers: await getHeaders(withAuth: withAuth), body: jsonEncode(body));
  }

  static Future<http.Response> put(String url, Map<String, dynamic> body,
      {bool withAuth = false}) async {
    return await http.put(Uri.parse(url),
        headers: await getHeaders(withAuth: withAuth), body: jsonEncode(body));
  }

  static Future<http.Response> delete(String url,
      {bool withAuth = false}) async {
    return await http.delete(Uri.parse(url),
        headers: await getHeaders(withAuth: withAuth));
  }
}
