import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://10.0.2.2:3000/api/auth";

  static Future register(String nom, String email, String password) async {
    final res = await http.post(Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nom": nom,
          "email": email,
          "password": password
        }));

    return json.decode(res.body);
  }

  static Future login(String email, String password) async {
    final res = await http.post(Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password
        }));

    return json.decode(res.body);
  }
}