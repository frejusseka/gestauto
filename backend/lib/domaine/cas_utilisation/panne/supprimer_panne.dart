import '../../depots/depot_panne.dart';

class SupprimerPanne {
  final DepotPanne _depot;

  SupprimerPanne({
    required DepotPanne depot,
  }) : _depot = depot;

  Future<void> executer({
    required String utilisateurId,
    required String panneId,
  }) {
    return _depot.supprimer(
      utilisateurId: utilisateurId,
      panneId: panneId,
    );
  }
}