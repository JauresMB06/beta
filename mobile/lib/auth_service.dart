import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<bool> register(String email, String password, String fullName, bool isDoctor) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "full_name": fullName,
        "is_doctor": isDoctor ? 1 : 0,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/token"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: "username=$email&password=$password",
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["access_token"];
    }
    return null;
  }
}