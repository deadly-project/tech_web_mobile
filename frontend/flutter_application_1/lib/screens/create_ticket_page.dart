// create_ticket_page.dart

import 'package:flutter/material.dart';
import '../services/api_service_ticket.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {

  final _formKey = GlobalKey<FormState>();

  final titreController = TextEditingController();
  final descriptionController = TextEditingController();
  final localisationController = TextEditingController();

  String typeProbleme = "Connexion";

  bool loading = false;

  final ApiServiceTicket api = ApiServiceTicket();

  final List<String> types = [
    "Connexion",
    "Routeur",
    "Switch",
    "Wifi",
    "Câble",
    "Serveur",
    "DNS",
    "Autre"
  ];

  Future<void> createTicket() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await api.createTicket({
        "titre": titreController.text,
        "description": descriptionController.text,
        "localisation": localisationController.text,
        "typeProbleme": typeProbleme
      });

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ticket créé avec succès"),
          ),
        );
        
        //Navigator.pop(context, true);
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : $e"),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    titreController.dispose();
    descriptionController.dispose();
    localisationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Créer un ticket"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Text(
                "Titre",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: titreController,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Titre obligatoire";
                  }
                  return null;
                },

                decoration: InputDecoration(
                  hintText: "Ex : Internet coupé",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Description",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: descriptionController,
                maxLines: 5,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Description obligatoire";
                  }
                  return null;
                },

                decoration: InputDecoration(
                  hintText: "Décrivez le problème...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Localisation",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: localisationController,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Localisation obligatoire";
                  }
                  return null;
                },

                decoration: InputDecoration(
                  hintText: "Ex : Bâtiment A",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Type de problème",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(

                value: typeProbleme,

                items: types.map((e) {

                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );

                }).toList(),

                onChanged: (value) {

                  setState(() {
                    typeProbleme = value!;
                  });

                },

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  onPressed: loading ? null : createTicket,

                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Envoyer le ticket",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}