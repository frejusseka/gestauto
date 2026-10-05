import '../../depots/depot_entretien.dart';
import '../../entites/entretien.dart';

class ObtenirEntretiens {
  final DepotEntretien _depot;

  ObtenirEntretiens({
    required DepotEntretien depot,
  }) : _depot = depot;

  Future<List<Entretien>> executer({
    required String utilisateurId,
  }) {
    return _depot.obtenirTous(
      utilisateurId: utilisateurId,
    );
  }
}