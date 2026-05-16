// ticket_detail_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ticket_model.dart';
import '../services/api_service_ticket.dart';

class TicketDetailPage extends StatefulWidget {

  final Ticket ticket;

  const TicketDetailPage({
    super.key,
    required this.ticket,
  });

  @override
  State<TicketDetailPage> createState() =>
      _TicketDetailPageState();
}

class _TicketDetailPageState
    extends State<TicketDetailPage> {

  final ApiServiceTicket api =
      ApiServiceTicket();

  final commentController =
      TextEditingController();

  bool loading = false;

  /*
  |--------------------------------------------------------------------------
  | USER DATA
  |--------------------------------------------------------------------------
  */

  String? role;

  int? userId;

  /*
  |--------------------------------------------------------------------------
  | COMMENTAIRES
  |--------------------------------------------------------------------------
  */

  List commentaires = [];

  @override
  void initState() {

    super.initState();

    initData();
  }

  /*
  |--------------------------------------------------------------------------
  | INITIALISATION
  |--------------------------------------------------------------------------
  */

  Future<void> initData() async {

    await getUserData();

    await loadComments();
  }

  /*
  |--------------------------------------------------------------------------
  | GET USER DATA
  |--------------------------------------------------------------------------
  */

  Future<void> getUserData() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    setState(() {

      role = prefs.getString("role");

      userId = prefs.getInt("userId");
    });
  }

  /*
  |--------------------------------------------------------------------------
  | LOAD COMMENTS
  |--------------------------------------------------------------------------
  */

  Future<void> loadComments() async {

    try {

      final data =
          await api.getComments(
        widget.ticket.id,
      );

      setState(() {

        commentaires = data;
      });

    } catch (e) {

      print(e);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | PERMISSIONS
  |--------------------------------------------------------------------------
  */

  bool isOwner() {

    return userId ==
        widget.ticket.utilisateurId;
  }

  bool isTechnician() {

    return role == "technicien"
        ||
        role == "admin";
  }

  bool isAdmin() {

    return role == "admin";
  }

  /*
  |--------------------------------------------------------------------------
  | STATUS COLOR
  |--------------------------------------------------------------------------
  */

  Color getStatusColor(
      String status) {

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

  /*
  |--------------------------------------------------------------------------
  | ADD COMMENT
  |--------------------------------------------------------------------------
  */

  Future<void> addComment() async {

    if (commentController.text.isEmpty) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await api.addComment(

        widget.ticket.id,

        {
          "auteur": role,
          "message":
              commentController.text
        },
      );

      setState(() {

        commentaires.add({

          "auteur": role,

          "message":
              commentController.text
        });
      });

      commentController.clear();

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Commentaire ajouté",
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      setState(() {
        loading = false;
      });
    }
  }

  /*
  |--------------------------------------------------------------------------
  | UPDATE STATUS
  |--------------------------------------------------------------------------
  */

  Future<void> updateStatus(
      String status) async {

    try {

      await api.updateStatus(
        widget.ticket.id,
        status,
      );

      setState(() {

        widget.ticket.statut =
            status;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Statut mis à jour",
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }
/*
|--------------------------------------------------------------------------
| DELETE TICKET
|--------------------------------------------------------------------------
*/

Future<void> deleteTicket() async {

  try {

    await api.deleteTicket(
      widget.ticket.id,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(

        content: Text(
          "Ticket supprimé",
        ),
      ),
    );

    Navigator.pop(context);

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  }
}

/*
|--------------------------------------------------------------------------
| CONFIRM DELETE
|--------------------------------------------------------------------------
*/

Future<void> confirmDelete() async {

  final confirm = await showDialog<bool>(

    context: context,

    builder: (context) {

      return AlertDialog(

        title: const Text(
          "Supprimer le ticket",
        ),

        content: const Text(
          "Voulez-vous vraiment supprimer ce ticket ?",
        ),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.pop(
                context,
                false,
              );
            },

            child: const Text(
              "Annuler",
            ),
          ),

          ElevatedButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),

            onPressed: () {

              Navigator.pop(
                context,
                true,
              );
            },

            child: const Text(
              "Supprimer",
            ),
          ),
        ],
      );
    },
  );

  if (confirm == true) {
    await deleteTicket();
  }
}
  /*
  |--------------------------------------------------------------------------
  | UI
  |--------------------------------------------------------------------------
  */

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Détail Ticket",
        ),

        actions: [

          /*
          |--------------------------------------------------------------------------
          | DELETE TICKET
          |--------------------------------------------------------------------------
          */

          if (isOwner() || isAdmin())

            IconButton(

              onPressed:
                  confirmDelete,

              icon: const Icon(
                Icons.delete,
              ),
            )
        ],
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /*
            |--------------------------------------------------------------------------
            | TITLE
            |--------------------------------------------------------------------------
            */

            Text(

              widget.ticket.titre,

              style: const TextStyle(

                fontSize: 24,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            /*
            |--------------------------------------------------------------------------
            | STATUS
            |--------------------------------------------------------------------------
            */

            Container(

              padding:
                  const EdgeInsets.symmetric(

                horizontal: 12,

                vertical: 8,
              ),

              decoration: BoxDecoration(

                color: getStatusColor(
                  widget.ticket.statut,
                ),

                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),

              child: Text(

                widget.ticket.statut,

                style: const TextStyle(

                  color: Colors.white,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /*
            |--------------------------------------------------------------------------
            | DESCRIPTION
            |--------------------------------------------------------------------------
            */

            const Text(

              "Description",

              style: TextStyle(

                fontWeight:
                    FontWeight.bold,

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

            /*
            |--------------------------------------------------------------------------
            | OWNER ACTIONS
            |--------------------------------------------------------------------------
            */

            if (isOwner()) ...[

              Row(

                children: [

                  ElevatedButton.icon(

                    onPressed: () {

                      /*
                      |--------------------------------------------------------------------------
                      | PAGE MODIFICATION
                      |--------------------------------------------------------------------------
                      */

                    },

                    icon: const Icon(
                      Icons.edit,
                    ),

                    label: const Text(
                      "Modifier ticket",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],

            /*
            |--------------------------------------------------------------------------
            | TECHNICIAN ACTIONS
            |--------------------------------------------------------------------------
            */

            if (isTechnician()) ...[

              const Text(

                "Changer le statut",

                style: TextStyle(

                  fontWeight:
                      FontWeight.bold,

                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 15),

              Wrap(

                spacing: 10,

                children: [

                  ElevatedButton(

                    onPressed: () {

                      updateStatus(
                        "EN_ATTENTE",
                      );
                    },

                    child: const Text(
                      "EN ATTENTE",
                    ),
                  ),

                  ElevatedButton(

                    onPressed: () {

                      updateStatus(
                        "EN_COURS",
                      );
                    },

                    child: const Text(
                      "EN COURS",
                    ),
                  ),

                  ElevatedButton(

                    onPressed: () {

                      updateStatus(
                        "RESOLU",
                      );
                    },

                    child: const Text(
                      "RESOLU",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],

            /*
            |--------------------------------------------------------------------------
            | COMMENTS
            |--------------------------------------------------------------------------
            */

            const Text(

              "Commentaires",

              style: TextStyle(

                fontWeight:
                    FontWeight.bold,

                fontSize: 18,
              ),
            ),

            const SizedBox(height: 15),

            /*
            |--------------------------------------------------------------------------
            | COMMENT INPUT
            |--------------------------------------------------------------------------
            */

            if (isTechnician()) ...[

              TextField(

                controller:
                    commentController,

                decoration:
                    InputDecoration(

                  hintText:
                      "Ajouter un commentaire",

                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),

                  suffixIcon:
                      IconButton(

                    onPressed:
                        loading
                            ? null
                            : addComment,

                    icon: loading

                        ? const Padding(

                            padding:
                                EdgeInsets
                                    .all(
                              10,
                            ),

                            child:
                                CircularProgressIndicator(),
                          )

                        : const Icon(
                            Icons.send,
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],

            /*
            |--------------------------------------------------------------------------
            | COMMENT LIST
            |--------------------------------------------------------------------------
            */

            ...commentaires.map(

              (comment) {

                return Card(

                  child: ListTile(

                    leading:
                        const CircleAvatar(

                      child: Icon(
                        Icons.person,
                      ),
                    ),

                    title: Text(
                      comment["auteur"]
                          .toString(),
                    ),

                    subtitle: Text(
                      comment["message"]
                          .toString(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}