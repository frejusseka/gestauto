import '../../depots/depot_versement.dart';
import '../../entites/versement.dart';

class CreerVersement {
  final DepotVersement _depot;

  CreerVersement({
    required DepotVersement depot,
  }) : _depot = depot;

  Future<Versement> executer({
    required String utilisateurId,
    required Versement versement,
  }) {
    return _depot.creer(
      utilisateurId: utilisateurId,
      versement: versement,
    );
  }
}