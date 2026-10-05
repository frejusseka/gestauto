import '../../depots/depot_vehicule.dart';
import '../../entites/vehicule.dart';

class CreerVehicule {
  final DepotVehicule _depot;

  CreerVehicule({
    required DepotVehicule depot,
  }) : _depot = depot;

  Future<Vehicule> executer(Vehicule vehicule) {
    return _depot.creer(vehicule);
  }
}