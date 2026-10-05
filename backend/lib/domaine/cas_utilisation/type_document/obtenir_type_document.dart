import '../../depots/depot_type_document.dart';
import '../../entites/type_document.dart';

class ObtenirTypeDocument {
  final DepotTypeDocument _depot;

  ObtenirTypeDocument({
    required DepotTypeDocument depot,
  }) : _depot = depot;

  Future<TypeDocument?> executer({
    required String utilisateurId,
    required String typeDocumentId,
  }) {
    return _depot.obtenirParId(
      utilisateurId: utilisateurId,
      typeDocumentId: typeDocumentId,
    );
  }
}