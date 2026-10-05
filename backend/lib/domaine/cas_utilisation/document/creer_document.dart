import '../../depots/depot_document.dart';
import '../../entites/document.dart';

class CreerDocument {
  final DepotDocument _depot;

  CreerDocument({
    required DepotDocument depot,
  }) : _depot = depot;

  Future<Document> executer({
    required String utilisateurId,
    required Document document,
  }) {
    return _depot.creer(
      utilisateurId: utilisateurId,
      document: document,
    );
  }
}