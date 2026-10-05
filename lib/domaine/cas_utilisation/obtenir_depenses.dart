import '../depots/depot_depense.dart';
import '../entites/depense.dart';

class ObtenirDepenses {
  final DepotDepense _depot;

  ObtenirDepenses({
    required this._depot,
  });

  Future<List<Depense>> executer() {
    return _depot.obtenirTous();
  }
}