import '../../depots/depot_vehicule.dart';
import '../../entites/vehicule.dart';

class ObtenirVehicule {
  final DepotVehicule _depot;

  ObtenirVehicule({
    required DepotVehicule depot,
  }) : _depot = depot;

  Future<Vehicule?> executer({
    required String utilisateurId,
    required String vehiculeId,
  }) {
    return _depot.obtenirParId(
      utilisateurId: utilisateurId,
      vehiculeId: vehiculeId,
    );
  }
}