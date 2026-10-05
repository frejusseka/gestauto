import '../../depots/depot_depense.dart';
import '../../entites/depense.dart';

class CreerDepense {
  final DepotDepense _depot;

  CreerDepense({
    required DepotDepense depot,
  }) : _depot = depot;

  Future<Depense> executer({
    required String utilisateurId,
    required Depense depense,
  }) {
    return _depot.creer(
      utilisateurId: utilisateurId,
      depense: depense,
    );
  }
}