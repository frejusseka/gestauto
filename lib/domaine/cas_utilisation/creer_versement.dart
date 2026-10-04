import '../depots/depot_versement.dart';
import '../entites/versement.dart';

class CreerVersement {
  final DepotVersement _depot;

  CreerVersement({
    required this._depot,
  });

  Future<Versement> executer({
    required String vehiculeId,
    required DateTime date,
    required double montantAttendu,
    required double montantVerse,
  }) {
    return _depot.creer(
      vehiculeId: vehiculeId,
      date: date,
      montantAttendu: montantAttendu,
      montantVerse: montantVerse,
    );
  }
}