import '../depots/depot_panne.dart';

class SupprimerPanne {
  final DepotPanne _depot;

  SupprimerPanne({
    required this._depot,
  });

  Future<void> executer({
    required String panneId,
  }) {
    return _depot.supprimer(
      panneId: panneId,
    );
  }
}