import '../../depots/depot_depense.dart';
import '../../entites/depense.dart';

class ObtenirDepense {
  final DepotDepense _depot;

  ObtenirDepense({
    required DepotDepense depot,
  }) : _depot = depot;

  Future<Depense?> executer({
    required String utilisateurId,
    required String depenseId,
  }) {
    return _depot.obtenirParId(
      utilisateurId: utilisateurId,
      depenseId: depenseId,
    );
  }
}