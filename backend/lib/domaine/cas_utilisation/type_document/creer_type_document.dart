import '../../depots/depot_type_document.dart';
import '../../entites/type_document.dart';

class CreerTypeDocument {
  final DepotTypeDocument _depot;

  CreerTypeDocument({
    required DepotTypeDocument depot,
  }) : _depot = depot;

  Future<TypeDocument> executer({
    required String utilisateurId,
    required TypeDocument typeDocument,
  }) {
    return _depot.creer(
      utilisateurId: utilisateurId,
      typeDocument: typeDocument,
    );
  }
}