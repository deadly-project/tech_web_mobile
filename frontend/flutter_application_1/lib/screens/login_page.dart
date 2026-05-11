import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_page.dart';
import '../services/api_service.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage ({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  final email = TextEditingController();
  final password = TextEditingController();

  void login() async {
    final res = await ApiService.login(email.text, password.text);
    print(res);
    if (res['token'] != null) {
      final token = res["token"];
      print(token);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", token);

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (_) => const DashboardPage(),
      ),
    );
    } else {
      print("Erreur");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          TextField(controller: email, decoration: InputDecoration(labelText: "Email")),
          TextField(controller: password, decoration: InputDecoration(labelText: "Password"), obscureText: true),

          ElevatedButton(
            onPressed: login,
            child: Text("Se connecter"),
          ),

          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => RegisterPage()));
            },
            child: Text("Créer un compte"),
          )
        ],
      ),
    );
  }
}