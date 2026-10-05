import '../../depots/depot_document.dart';
import '../../entites/document.dart';

class ObtenirDocuments {
  final DepotDocument _depot;

  ObtenirDocuments({
    required DepotDocument depot,
  }) : _depot = depot;

  Future<List<Document>> executer({
    required String utilisateurId,
  }) {
    return _depot.obtenirTous(
      utilisateurId: utilisateurId,
    );
  }
}