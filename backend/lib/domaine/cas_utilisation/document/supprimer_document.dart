import '../../depots/depot_document.dart';

class SupprimerDocument {
  final DepotDocument _depot;

  SupprimerDocument({
    required DepotDocument depot,
  }) : _depot = depot;

  Future<void> executer({
    required String utilisateurId,
    required String documentId,
  }) {
    return _depot.supprimer(
      utilisateurId: utilisateurId,
      documentId: documentId,
    );
  }
}