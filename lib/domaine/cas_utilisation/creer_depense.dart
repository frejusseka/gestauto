import '../depots/depot_depense.dart';
import '../entites/depense.dart';

class CreerDepense {
  final DepotDepense _depot;

  CreerDepense({
    required this._depot,
  });

  Future<Depense> executer({
    required String vehiculeId,
    required String categorieId,
    required DateTime date,
    required double montant,
    String? description,
  }) {
    return _depot.creer(
      vehiculeId: vehiculeId,
      categorieId: categorieId,
      date: date,
      montant: montant,
      description: description,
    );
  }
}