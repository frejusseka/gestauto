import '../../depots/depot_vehicule.dart';
import '../../entites/vehicule.dart';

class ObtenirVehicules {
  final DepotVehicule _depot;

  ObtenirVehicules({
    required DepotVehicule depot,
  }) : _depot = depot;

  Future<List<Vehicule>> executer({
    required String utilisateurId,
  }) {
    return _depot.obtenirTous(utilisateurId);
  }
}