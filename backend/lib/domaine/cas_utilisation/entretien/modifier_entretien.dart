import '../../depots/depot_entretien.dart';
import '../../entites/entretien.dart';

class ModifierEntretien {
  final DepotEntretien _depot;

  ModifierEntretien({
    required DepotEntretien depot,
  }) : _depot = depot;

  Future<Entretien> executer({
    required String utilisateurId,
    required Entretien entretien,
  }) {
    return _depot.modifier(
      utilisateurId: utilisateurId,
      entretien: entretien,
    );
  }
}