import '../../depots/depot_type_document.dart';

class SupprimerTypeDocument {
  final DepotTypeDocument _depot;

  SupprimerTypeDocument({
    required DepotTypeDocument depot,
  }) : _depot = depot;

  Future<void> executer({
    required String utilisateurId,
    required String typeDocumentId,
  }) {
    return _depot.supprimer(
      utilisateurId: utilisateurId,
      typeDocumentId: typeDocumentId,
    );
  }
}