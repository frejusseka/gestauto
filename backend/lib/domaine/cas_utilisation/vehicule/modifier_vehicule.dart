import '../../depots/depot_vehicule.dart';
import '../../entites/vehicule.dart';

class ModifierVehicule {
  final DepotVehicule _depot;

  ModifierVehicule({
    required DepotVehicule depot,
  }) : _depot = depot;

  Future<Vehicule> executer(Vehicule vehicule) {
    return _depot.modifier(vehicule);
  }
}