class Ticket {

  int id;
  String titre;
  String description;
  String statut;
  int utilisateurId;

  Ticket({
    required this.id,
    required this.titre,
    required this.description,
    required this.statut,
    required this.utilisateurId,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      statut: json['statut'],
      utilisateurId: json['utilisateur_id'],
    );
  }
}