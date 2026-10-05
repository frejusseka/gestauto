import '../../depots/depot_versement.dart';
import '../../entites/versement.dart';

class ObtenirVersements {
  final DepotVersement _depot;

  ObtenirVersements({
    required DepotVersement depot,
  }) : _depot = depot;

  Future<List<Versement>> executer({
    required String utilisateurId,
  }) {
    return _depot.obtenirTous(
      utilisateurId: utilisateurId,
    );
  }
}