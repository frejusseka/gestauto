import '../../depots/depot_versement.dart';

class SupprimerVersement {
  final DepotVersement _depot;

  SupprimerVersement({
    required DepotVersement depot,
  }) : _depot = depot;

  Future<void> executer({
    required String utilisateurId,
    required String versementId,
  }) {
    return _depot.supprimer(
      utilisateurId: utilisateurId,
      versementId: versementId,
    );
  }
}