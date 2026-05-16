class Ticket {

  int id;
  String titre;
  String description;
  String statut;
  String localisation;
  String typeProbleme;
  int utilisateurId;
  String auteurUsername;

  Ticket({
    required this.id,
    required this.titre,
    required this.description,
    required this.statut,
    required this.localisation,
    required this.typeProbleme,
    required this.utilisateurId,
    required this.auteurUsername,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      statut: json['statut'],
      localisation: json['localisation'],
      typeProbleme: json['type_probleme'],
      utilisateurId: json['utilisateur_id'],
      auteurUsername: json['auteur_username'] ?? 'Inconnu',
    );
  }
}