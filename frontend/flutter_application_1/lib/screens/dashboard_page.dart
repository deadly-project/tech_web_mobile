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
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  ApiServiceTicket api = ApiServiceTicket();
  List<Ticket> tickets = [];
  
  // Variables pour stocker les infos de l'utilisateur connecté
  String currentUsername = "";
  String currentUserRole = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    loadTickets();
  }

  /*
  |--------------------------------------------------------------------------
  | LOAD USER INFO (Pour le profil du Drawer)
  |--------------------------------------------------------------------------
  */
  void _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUsername = prefs.getString("username") ?? "Utilisateur";
      currentUserRole = prefs.getString("role") ?? "Client";
    });
  }

  /*
  |--------------------------------------------------------------------------
  | FONCTION POUR GÉNÉRER LES INITIALES
  |--------------------------------------------------------------------------
  */
  String _getInitials(String name) {
    if (name.isEmpty) return "U";
    List<String> nameParts = name.trim().split(" ");
    if (nameParts.length > 1) {
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    }
    return nameParts[0][0].toUpperCase();
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
        tickets = data.map<Ticket>((e) => Ticket.fromJson(e)).toList();
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
        return Colors.amber.shade700;
      case 'EN_COURS':
        return Colors.blue.shade600;
      case 'RESOLU':
        return Colors.green.shade600;
      default:
        return Colors.red.shade600;
    }
  }

  String _formatStatus(String status) {
    return status.replaceAll('_', ' ');
  }

  /*
  |--------------------------------------------------------------------------
  | LOGOUT
  |--------------------------------------------------------------------------
  */
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Nettoie toutes les préférences

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
    // Calcul des statistiques pour les badges du haut
    int enAttente = tickets.where((t) => t.statut == 'EN_ATTENTE').length;
    int enCours = tickets.where((t) => t.statut == 'EN_COURS').length;
    int resolu = tickets.where((t) => t.statut == 'RESOLU').length;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade50, // Fond épuré pour faire ressortir les cartes

      /*
      |--------------------------------------------------------------------------
      | DRAWER MENU (Avec profil de l'utilisateur connecté)
      |--------------------------------------------------------------------------
      */
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  _getInitials(currentUsername),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              accountName: Text(
                currentUsername,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(
                "Rôle : ${currentUserRole.toUpperCase()}",
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_rounded, color: Colors.blue),
              title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.speed_rounded, color: Colors.blueGrey),
              title: const Text('Speed Test'),
              onTap: () {
                Navigator.pop(context); // Ferme le Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SpeedTestPage(),
                  ),
                );
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text('Déconnexion', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
              onTap: logout,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      /*
      |--------------------------------------------------------------------------
      | APP BAR MODERNE
      |--------------------------------------------------------------------------
      */
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text(
          'Mes Tickets',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          // Petit raccourci profil cliquable en haut à droite
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            key: const ValueKey('profile_avatar_padding'),
            child: GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                radius: 18,
                child: Text(
                  _getInitials(currentUsername),
                  style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),

      /*
      |--------------------------------------------------------------------------
      | BODY (Liste des tickets avec Titre et Créateur regroupés)
      |--------------------------------------------------------------------------
      */
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Statistiques Rapides
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBadge("Attente", enAttente, Colors.amber.shade700),
                _buildStatBadge("En cours", enCours, Colors.blue.shade600),
                _buildStatBadge("Résolus", resolu, Colors.green.shade600),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Text(
              "Flux d'activité",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ),

          // Liste des tickets
          Expanded(
            child: tickets.isEmpty
                ? const Center(
                    child: Text(
                      "Aucun ticket pour le moment.",
                      style: TextStyle(color: Colors.black45, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: tickets.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemBuilder: (_, index) {
                      final t = tickets[index];
                      final statusColor = getColor(t.statut);
                      final creatorColor = Colors.blueGrey.shade600;

                      return Card(
                        elevation: 2,
                        shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TicketDetailPage(ticket: t),
                              ),
                            ).then((value) => loadTickets());
                          },
                          child: Container(
                            // Bordure colorée à gauche selon le statut
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color: statusColor, width: 5),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Partie Gauche : Titre + Badge Créateur collés côte à côte
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Titre ajustable
                                          Flexible(
                                            child: Text(
                                              t.titre,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          
                                          // Badge Créateur avec son Icône (à côté du titre)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: creatorColor.withAlpha(25),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.person_outline_rounded,
                                                  size: 13,
                                                  color: creatorColor,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  t.auteurUsername,
                                                  style: TextStyle(
                                                    color: creatorColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Partie Droite : Badge Statut isolé tout à droite
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: statusColor.withAlpha(30),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _formatStatus(t.statut),
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Divider(height: 1, color: Colors.black12),
                                ),
                                // Description courte du ticket
                                Row(
                                  children: [
                                    Icon(Icons.subject_rounded, size: 16, color: Colors.grey.shade400),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        t.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      /*
      |--------------------------------------------------------------------------
      | FLOATING ACTION BUTTON
      |--------------------------------------------------------------------------
      */
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTicketPage(),
            ),
          ).then((value) => loadTickets());
        },
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        label: const Text(
          "Nouveau Ticket",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  // Widget d'aide pour construire les badges de statistiques du haut
  Widget _buildStatBadge(String title, int count, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}