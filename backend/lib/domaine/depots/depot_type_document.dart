import '../entites/type_document.dart';

abstract class DepotTypeDocument {
  Future<List<TypeDocument>> obtenirTous({
    required String utilisateurId,
  });

  Future<TypeDocument?> obtenirParId({
    required String utilisateurId,
    required String typeDocumentId,
  });

  Future<TypeDocument> creer({
    required String utilisateurId,
    required TypeDocument typeDocument,
  });

  Future<TypeDocument> modifier({
    required String utilisateurId,
    required TypeDocument typeDocument,
  });

  Future<void> supprimer({
    required String utilisateurId,
    required String typeDocumentId,
  });
}