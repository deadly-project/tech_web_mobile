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
    "Connexion", "Routeur", "Switch", "Wifi", "Câble", "Serveur", "DNS", "Autre"
  ];

  Future<void> createTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

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
            content: Text("Ticket créé avec succès ✅"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => loading = false);
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Nouveau Ticket"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Section Titre et Type
              _buildFormCard(
                children: [
                  _buildLabel("Informations générales"),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: titreController,
                    label: "Titre du problème",
                    hint: "Ex: Panne totale fibre",
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown(),
                ],
              ),
              
              const SizedBox(height: 20),

              // Section Détails
              _buildFormCard(
                children: [
                  _buildLabel("Détails de l'incident"),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: localisationController,
                    label: "Localisation",
                    hint: "Ex: Bureau 204, Bâtiment B",
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: descriptionController,
                    label: "Description",
                    hint: "Expliquez le problème en quelques mots...",
                    icon: Icons.description_outlined,
                    maxLines: 4,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Bouton d'envoi
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading ? null : createTicket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Envoyer le ticket",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour grouper les champs dans des "cartes" blanches
  Widget _buildFormCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) => (value == null || value.isEmpty) ? "Ce champ est requis" : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: typeProbleme,
      items: types.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (value) => setState(() => typeProbleme = value!),
      decoration: InputDecoration(
        labelText: "Type de problème",
        prefixIcon: const Icon(Icons.category_outlined, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}