import '../../depots/depot_type_document.dart';
import '../../entites/type_document.dart';

class ObtenirTypesDocuments {
  final DepotTypeDocument _depot;

  ObtenirTypesDocuments({
    required DepotTypeDocument depot,
  }) : _depot = depot;

  Future<List<TypeDocument>> executer({
    required String utilisateurId,
  }) {
    return _depot.obtenirTous(
      utilisateurId: utilisateurId,
    );
  }
}