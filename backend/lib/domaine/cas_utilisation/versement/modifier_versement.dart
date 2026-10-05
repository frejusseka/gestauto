import '../../depots/depot_versement.dart';
import '../../entites/versement.dart';

class ModifierVersement {
  final DepotVersement _depot;

  ModifierVersement({
    required DepotVersement depot,
  }) : _depot = depot;

  Future<Versement> executer({
    required String utilisateurId,
    required Versement versement,
  }) {
    return _depot.modifier(
      utilisateurId: utilisateurId,
      versement: versement,
    );
  }
}