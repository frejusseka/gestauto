class Entretien {
  final String id;
  final String vehiculeId;
  final String type;
  final DateTime date;
  final int kilometrage;
  final double montant;
  final int? prochainKilometrage;
  final DateTime? prochaineDate;
  final String? notes;

  Entretien({
    required this.id,
    required this.vehiculeId,
    required this.type,
    required this.date,
    required this.kilometrage,
    required this.montant,
    this.prochainKilometrage,
    this.prochaineDate,
    this.notes,
  });
}