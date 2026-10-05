import '../depots/depot_panne.dart';
import '../entites/panne.dart';

class CreerPanne {
  final DepotPanne _depot;

  CreerPanne({
    required this._depot,
  });

  Future<Panne> executer({
    required Panne panne,
  }) {
    return _depot.creer(
      panne: panne,
    );
  }
}