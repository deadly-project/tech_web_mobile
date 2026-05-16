import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service_ticket.dart';
import '../models/ticket_model.dart';

import 'login_page.dart';
import 'speedtest_page.dart';
import 'ticket_detail_page.dart';
import 'create_ticket_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends State<DashboardPage> {

  ApiServiceTicket api = ApiServiceTicket();

  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  /*
  |--------------------------------------------------------------------------
  | LOAD TICKETS
  |--------------------------------------------------------------------------
  */

  void loadTickets() async {

    try {

      final data = await api.getTickets();

      setState(() {

        tickets = data
            .map<Ticket>(
              (e) => Ticket.fromJson(e),
            )
            .toList();
      });

    } catch (e) {
      print(e);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | COLOR STATUS
  |--------------------------------------------------------------------------
  */

  Color getColor(String status) {

    switch (status) {

      case 'EN_ATTENTE':
        return Colors.orange;

      case 'EN_COURS':
        return Colors.blue;

      case 'RESOLU':
        return Colors.green;

      default:
        return Colors.red;
    }
  }

  /*
  |--------------------------------------------------------------------------
  | LOGOUT
  |--------------------------------------------------------------------------
  */

  void logout() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.remove("token");

    if (!mounted) return;

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      /*
      |--------------------------------------------------------------------------
      | DRAWER MENU
      |--------------------------------------------------------------------------
      */

      drawer: Drawer(

        child: ListView(

          padding: EdgeInsets.zero,

          children: [

            const DrawerHeader(

              decoration: BoxDecoration(
                color: Colors.blue,
              ),

              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Speed Test'),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SpeedTestPage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: logout,
            ),
          ],
        ),
      ),

      /*
      |--------------------------------------------------------------------------
      | APP BAR + BOUTON AJOUT
      |--------------------------------------------------------------------------
      */

      appBar: AppBar(

        title: const Text('Dashboard Tickets'),

        actions: [

          IconButton(
            
            icon: const Icon(Icons.add),

            tooltip: "Créer ticket",

            onPressed: () {

              Navigator.push(

                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const CreateTicketPage(),
                ),
              ).then((value) {

                // refresh après création
                loadTickets();
              });
            },
          ),
        ],
      ),

      /*
      |--------------------------------------------------------------------------
      | BODY
      |--------------------------------------------------------------------------
      */

      body: ListView.builder(

        itemCount: tickets.length,

        itemBuilder: (_, index) {

          final t = tickets[index];

          return Card(

            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),

            child: ListTile(

              /*
              |--------------------------------------------------------------------------
              | OUVRIR DETAILS
              |--------------------------------------------------------------------------
              */

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        TicketDetailPage(
                      ticket: t,
                    ),
                  ),
                ).then((value) {

                  // refresh après modification statut/commentaire
                  loadTickets();
                });
              },

              title: Text(t.titre),

              subtitle: Text(t.description),

              trailing: Container(

                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  color: getColor(t.statut),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  t.statut,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}