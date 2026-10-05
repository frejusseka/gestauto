class Document {
  final String id;
  final String vehiculeId;
  final String typeDocumentId;
  final String? numero;
  final DateTime dateEmission;
  final DateTime dateExpiration;
  final String? notes;

  Document({
    required this.id,
    required this.vehiculeId,
    required this.typeDocumentId,
    this.numero,
    required this.dateEmission,
    required this.dateExpiration,
    this.notes,
  });
}