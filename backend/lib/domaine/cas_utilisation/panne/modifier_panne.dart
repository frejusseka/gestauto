import '../../depots/depot_panne.dart';
import '../../entites/panne.dart';

class ModifierPanne {
  final DepotPanne _depot;

  ModifierPanne({
    required DepotPanne depot,
  }) : _depot = depot;

  Future<Panne> executer({
    required String utilisateurId,
    required Panne panne,
  }) {
    return _depot.modifier(
      utilisateurId: utilisateurId,
      panne: panne,
    );
  }
}