import '../../depots/depot_depense.dart';
import '../../entites/depense.dart';

class ObtenirDepenses {
  final DepotDepense _depot;

  ObtenirDepenses({
    required DepotDepense depot,
  }) : _depot = depot;

  Future<List<Depense>> executer({
    required String utilisateurId,
  }) {
    return _depot.obtenirTous(
      utilisateurId: utilisateurId,
    );
  }
}