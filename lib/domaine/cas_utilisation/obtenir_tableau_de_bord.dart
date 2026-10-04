import '../depots/depot_tableau_de_bord.dart';
import '../entites/tableau_de_bord.dart';

class ObtenirTableauDeBord {
  final DepotTableauDeBord _depot;

  ObtenirTableauDeBord({
    required this._depot,
  });

  Future<TableauDeBord> executer() {
    return _depot.obtenir();
  }
}