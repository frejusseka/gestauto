import '../../depots/depot_panne.dart';
import '../../entites/panne.dart';

class ObtenirPanne {
  final DepotPanne _depot;

  ObtenirPanne({
    required DepotPanne depot,
  }) : _depot = depot;

  Future<Panne?> executer({
    required String utilisateurId,
    required String panneId,
  }) {
    return _depot.obtenirParId(
      utilisateurId: utilisateurId,
      panneId: panneId,
    );
  }
}