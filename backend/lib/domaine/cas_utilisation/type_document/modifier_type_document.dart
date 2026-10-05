import '../../depots/depot_type_document.dart';
import '../../entites/type_document.dart';

class ModifierTypeDocument {
  final DepotTypeDocument _depot;

  ModifierTypeDocument({
    required DepotTypeDocument depot,
  }) : _depot = depot;

  Future<TypeDocument> executer({
    required String utilisateurId,
    required TypeDocument typeDocument,
  }) {
    return _depot.modifier(
      utilisateurId: utilisateurId,
      typeDocument: typeDocument,
    );
  }
}