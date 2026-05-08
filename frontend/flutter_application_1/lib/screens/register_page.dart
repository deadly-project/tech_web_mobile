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
    try {
      await ApiService.register(nom.text, email.text, password.text);
      // ignore: use_build_context_synchronously
      //Navigator.pop(context);
      if (!mounted) return;
    bool closed = false;

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.green,
        content: const Text(
          "Utilisateur créé avec succès ✅",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!mounted) return;

              closed = true;

              ScaffoldMessenger.of(context)
                  .hideCurrentMaterialBanner();

              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    // Vide les champs
    nom.clear();
    email.clear();
    password.clear();

    // Attend 5 secondes
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted || closed) return;

    // cacher la bannière
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

    // Retourne à la page précédente
    Navigator.pop(context);

  } catch (e) {
      if (!mounted) return;

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.red,
        content: Text(
          "Erreur : $e",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!mounted) return;

              ScaffoldMessenger.of(context)
                  .hideCurrentMaterialBanner();
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    }
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