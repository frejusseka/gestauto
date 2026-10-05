import '../depots/depot_panne.dart';
import '../entites/panne.dart';

class ModifierPanne {
  final DepotPanne _depot;

  ModifierPanne({
    required this._depot,
  });

  Future<Panne> executer({
    required Panne panne,
  }) {
    return _depot.modifier(
      panne: panne,
    );
  }
}