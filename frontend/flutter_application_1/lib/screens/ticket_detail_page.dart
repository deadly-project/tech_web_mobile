// ticket_detail_page.dart

import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../services/api_service_ticket.dart';

class TicketDetailPage extends StatefulWidget {

  final Ticket ticket;

  const TicketDetailPage({
    super.key,
    required this.ticket,
  });

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {

  final ApiServiceTicket api = ApiServiceTicket();

  final commentController = TextEditingController();

  bool loading = false;

  List commentaires = [];

  Color getStatusColor(String status) {

    switch (status) {

      case "EN_ATTENTE":
        return Colors.orange;

      case "EN_COURS":
        return Colors.blue;

      case "RESOLU":
        return Colors.green;

      default:
        return Colors.red;
    }
  }

  Future<void> addComment() async {

    if (commentController.text.isEmpty) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await api.dio.post(
        "/tickets/${widget.ticket.id}/comment",
        data: {
          "auteur": "Technicien",
          "message": commentController.text
        },
      );

      setState(() {

        commentaires.add({
          "auteur": "Technicien",
          "message": commentController.text
        });

      });

      commentController.clear();

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    } finally {

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> updateStatus(String status) async {

    try {

      await api.updateStatus(widget.ticket.id, status);

      setState(() {
        widget.ticket.statut = status;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Statut mis à jour"),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Détail Ticket"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              widget.ticket.titre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(

              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),

              decoration: BoxDecoration(
                color: getStatusColor(widget.ticket.statut),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Text(
                widget.ticket.statut,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.ticket.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Changer le statut",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Wrap(

              spacing: 10,

              children: [

                ElevatedButton(
                  onPressed: () {
                    updateStatus("EN_ATTENTE");
                  },
                  child: const Text("EN_ATTENTE"),
                ),

                ElevatedButton(
                  onPressed: () {
                    updateStatus("EN_COURS");
                  },
                  child: const Text("EN_COURS"),
                ),

                ElevatedButton(
                  onPressed: () {
                    updateStatus("RESOLU");
                  },
                  child: const Text("RESOLU"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Commentaires",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: commentController,

              decoration: InputDecoration(

                hintText: "Ajouter un commentaire",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                suffixIcon: IconButton(

                  onPressed: loading ? null : addComment,

                  icon: loading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ...commentaires.map((comment) {

              return Card(

                child: ListTile(

                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),

                  title: Text(comment["auteur"]),

                  subtitle: Text(comment["message"]),
                ),
              );

            }).toList()
          ],
        ),
      ),
    );
  }
}