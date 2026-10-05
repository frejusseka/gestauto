import '../depots/depot_panne.dart';
import '../entites/panne.dart';

class ObtenirPannes {
  final DepotPanne _depot;

  ObtenirPannes({
    required this._depot,
  });

  Future<List<Panne>> executer() {
    return _depot.obtenirTous();
  }
}