import '../depots/depot_vehicule.dart';
import '../entites/resultat_vehicules.dart';

class ObtenirVehicules {
  final DepotVehicule _depot;

  ObtenirVehicules({
    required this._depot,
  });

  Future<ResultatVehicules> executer() {
    return _depot.obtenirTous();
  }
}