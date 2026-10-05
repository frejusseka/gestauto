import '../../depots/depot_panne.dart';
import '../../entites/panne.dart';

class CreerPanne {
  final DepotPanne _depot;

  CreerPanne({
    required DepotPanne depot,
  }) : _depot = depot;

  Future<Panne> executer({
    required String utilisateurId,
    required Panne panne,
  }) {
    return _depot.creer(
      utilisateurId: utilisateurId,
      panne: panne,
    );
  }
}