import '../../depots/depot_entretien.dart';
import '../../entites/entretien.dart';

class CreerEntretien {
  final DepotEntretien _depot;

  CreerEntretien({
    required DepotEntretien depot,
  }) : _depot = depot;

  Future<Entretien> executer({
    required String utilisateurId,
    required Entretien entretien,
  }) {
    return _depot.creer(
      utilisateurId: utilisateurId,
      entretien: entretien,
    );
  }
}