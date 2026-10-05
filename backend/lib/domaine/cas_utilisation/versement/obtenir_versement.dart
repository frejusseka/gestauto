import '../../depots/depot_versement.dart';
import '../../entites/versement.dart';

class ObtenirVersement {
  final DepotVersement _depot;

  ObtenirVersement({
    required DepotVersement depot,
  }) : _depot = depot;

  Future<Versement?> executer({
    required String utilisateurId,
    required String versementId,
  }) {
    return _depot.obtenirParId(
      utilisateurId: utilisateurId,
      versementId: versementId,
    );
  }
}