import '../depots/depot_vehicule.dart';

class SupprimerVehicule {
  final DepotVehicule _depot;

  SupprimerVehicule({
    required this._depot,
  });

  Future<void> executer(String id) {
    return _depot.supprimer(id);
  }
}