import '../depots/depot_vehicule.dart';
import '../entites/vehicule.dart';

class AjouterVehicule {
  final DepotVehicule _depot;

  AjouterVehicule({
    required this._depot,
  });

  Future<void> executer(Vehicule vehicule) {
    return _depot.ajouter(vehicule);
  }
}