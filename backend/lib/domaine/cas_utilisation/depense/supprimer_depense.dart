import '../../depots/depot_depense.dart';

class SupprimerDepense {
  final DepotDepense _depot;

  SupprimerDepense({
    required DepotDepense depot,
  }) : _depot = depot;

  Future<void> executer({
    required String utilisateurId,
    required String depenseId,
  }) {
    return _depot.supprimer(
      utilisateurId: utilisateurId,
      depenseId: depenseId,
    );
  }
}