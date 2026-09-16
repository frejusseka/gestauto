enum StatutPanne {
  ouverte,
  resolue,
}

class Panne {
  final String id;
  final String vehiculeId;
  final String description;
  final DateTime date;
  final int kilometrage;
  final StatutPanne statut;
  final String? notes;

  Panne({
    required this.id,
    required this.vehiculeId,
    required this.description,
    required this.date,
    required this.kilometrage,
    required this.statut,
    this.notes,
  });
}