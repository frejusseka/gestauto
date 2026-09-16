import '../depots/depot_vehicule.dart';
import '../entites/vehicule.dart';

class ObtenirVehicules {
  final DepotVehicule depot;

  ObtenirVehicules({
    required this.depot,
  });

  Future<List<Vehicule>> executer() {
    return depot.obtenirTous();
  }
}