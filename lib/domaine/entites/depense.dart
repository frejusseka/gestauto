class Depense {
  final String id;
  final String vehiculeId;
  final String categorieId;
  final DateTime date;
  final double montant;
  final String? description;

  Depense({
    required this.id,
    required this.vehiculeId,
    required this.categorieId,
    required this.date,
    required this.montant,
    this.description,
  });
}