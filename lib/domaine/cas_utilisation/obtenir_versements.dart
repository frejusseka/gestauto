import '../depots/depot_versement.dart';
import '../entites/versement.dart';

class ObtenirVersements {
  final DepotVersement _depot;

  ObtenirVersements({
    required this._depot,
  });

  Future<List<Versement>> executer() {
    return _depot.obtenirTous();
  }
}