class Depense {
  final String id;
  final String vehiculeId;
  final String categorie;
  final String description;
  final double montant;
  final DateTime date;
  final String? justificatif;

  Depense({
    required this.id,
    required this.vehiculeId,
    required this.categorie,
    required this.description,
    required this.montant,
    required this.date,
    this.justificatif,
  });
}