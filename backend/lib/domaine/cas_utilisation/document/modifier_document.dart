import '../../depots/depot_document.dart';
import '../../entites/document.dart';

class ModifierDocument {
  final DepotDocument _depot;

  ModifierDocument({
    required DepotDocument depot,
  }) : _depot = depot;

  Future<Document> executer({
    required String utilisateurId,
    required Document document,
  }) {
    return _depot.modifier(
      utilisateurId: utilisateurId,
      document: document,
    );
  }
}