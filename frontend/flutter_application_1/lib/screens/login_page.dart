import 'package:flutter/material.dart';
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

    if (res['token'] != null) {
      print("Login OK");
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