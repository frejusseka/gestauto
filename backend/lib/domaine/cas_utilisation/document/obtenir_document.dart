import '../../depots/depot_document.dart';
import '../../entites/document.dart';

class ObtenirDocument {
  final DepotDocument _depot;

  ObtenirDocument({
    required DepotDocument depot,
  }) : _depot = depot;

  Future<Document?> executer({
    required String utilisateurId,
    required String documentId,
  }) {
    return _depot.obtenirParId(
      utilisateurId: utilisateurId,
      documentId: documentId,
    );
  }
}