import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://10.42.0.1:3000/api/auth";

  static Future register(String username, String email, String password) async {
    final res = await http.post(Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username,
          "email": email,
          "password": password
        }));

    return json.decode(res.body);
  }

  static Future login(String username, String password) async {
    final res = await http.post(Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username,
          "password": password
        }));

    return json.decode(res.body);
  }

}