import '../../depots/depot_entretien.dart';
import '../../entites/entretien.dart';

class ObtenirEntretien {
  final DepotEntretien _depot;

  ObtenirEntretien({
    required DepotEntretien depot,
  }) : _depot = depot;

  Future<Entretien?> executer({
    required String utilisateurId,
    required String entretienId,
  }) {
    return _depot.obtenirParId(
      utilisateurId: utilisateurId,
      entretienId: entretienId,
    );
  }
}