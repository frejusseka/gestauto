import '../../depots/depot_panne.dart';
import '../../entites/panne.dart';

class ObtenirPannes {
  final DepotPanne _depot;

  ObtenirPannes({
    required DepotPanne depot,
  }) : _depot = depot;

  Future<List<Panne>> executer({
    required String utilisateurId,
  }) {
    return _depot.obtenirTous(
      utilisateurId: utilisateurId,
    );
  }
}