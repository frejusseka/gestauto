class Document {
  final String id;
  final String vehiculeId;
  final String type;
  final String numero;
  final DateTime dateEmission;
  final DateTime? dateExpiration;
  final String? justificatif;

  Document({
    required this.id,
    required this.vehiculeId,
    required this.type,
    required this.numero,
    required this.dateEmission,
    this.dateExpiration,
    this.justificatif,
  });
}