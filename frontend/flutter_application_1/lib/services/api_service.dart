import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://198.168.88.200:3000";

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

  static Future test() async{
    try {

      final res = await http.get(
        Uri.parse("$baseUrl/test"),
      );

      print("STATUS : ${res.statusCode}");
      print("BODY : ${res.body}");

      return json.decode(res.body);

    } catch (e) {

      print("ERREUR : $e");

    }
  }
}