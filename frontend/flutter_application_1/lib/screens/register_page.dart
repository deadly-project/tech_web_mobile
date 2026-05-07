import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final nom = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  void register() async {
    await ApiService.register(nom.text, email.text, password.text);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void test() async {
    await ApiService.test();
    // ignore: use_build_context_synchronously
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Column(
        children: [
          TextField(controller: nom, decoration: InputDecoration(labelText: "Nom")),
          TextField(controller: email, decoration: InputDecoration(labelText: "Email")),
          TextField(controller: password, decoration: InputDecoration(labelText: "Password"), obscureText: true),

          ElevatedButton(
            onPressed: register,
            child: Text("Créer compte"),
          ),
          // ElevatedButton(
          //   onPressed: test,
          //   child: Text("Test connectivité"),
          // ),


        ],
      ),
    );
  }
}