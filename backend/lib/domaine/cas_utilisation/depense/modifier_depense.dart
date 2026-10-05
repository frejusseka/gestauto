import '../../depots/depot_depense.dart';
import '../../entites/depense.dart';

class ModifierDepense {
  final DepotDepense _depot;

  ModifierDepense({
    required DepotDepense depot,
  }) : _depot = depot;

  Future<Depense> executer({
    required String utilisateurId,
    required Depense depense,
  }) {
    return _depot.modifier(
      utilisateurId: utilisateurId,
      depense: depense,
    );
  }
}