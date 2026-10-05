import '../entites/document.dart';

abstract class DepotDocument {
  Future<List<Document>> obtenirTous({
    required String utilisateurId,
  });

  Future<List<Document>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  });

  Future<Document?> obtenirParId({
    required String utilisateurId,
    required String documentId,
  });

  Future<Document> creer({
    required String utilisateurId,
    required Document document,
  });

  Future<Document> modifier({
    required String utilisateurId,
    required Document document,
  });

  Future<void> supprimer({
    required String utilisateurId,
    required String documentId,
  });
}