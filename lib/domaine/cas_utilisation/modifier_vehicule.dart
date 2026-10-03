import '../depots/depot_vehicule.dart';
import '../entites/vehicule.dart';

class ModifierVehicule {
  final DepotVehicule _depot;

  ModifierVehicule({
    required this._depot,
  });

  Future<void> executer(Vehicule vehicule) {
    return _depot.modifier(vehicule);
  }
}