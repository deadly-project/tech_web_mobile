class Ticket {

  int id;
  String titre;
  String description;
  String statut;

  Ticket({
    required this.id,
    required this.titre,
    required this.description,
    required this.statut,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      statut: json['statut'],
    );
  }
}