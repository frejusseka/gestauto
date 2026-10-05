import '../../depots/depot_vehicule.dart';

class SupprimerVehicule {
  final DepotVehicule _depot;

  SupprimerVehicule({
    required DepotVehicule depot,
  }) : _depot = depot;

  Future<void> executer({
    required String utilisateurId,
    required String vehiculeId,
  }) {
    return _depot.supprimer(
      utilisateurId: utilisateurId,
      vehiculeId: vehiculeId,
    );
  }
}