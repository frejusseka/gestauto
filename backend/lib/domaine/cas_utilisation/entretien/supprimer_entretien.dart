import '../../depots/depot_entretien.dart';

class SupprimerEntretien {
  final DepotEntretien _depot;

  SupprimerEntretien({
    required DepotEntretien depot,
  }) : _depot = depot;

  Future<void> executer({
    required String utilisateurId,
    required String entretienId,
  }) {
    return _depot.supprimer(
      utilisateurId: utilisateurId,
      entretienId: entretienId,
    );
  }
}