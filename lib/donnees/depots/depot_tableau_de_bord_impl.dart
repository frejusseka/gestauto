import '../../domaine/depots/depot_tableau_de_bord.dart';
import '../../domaine/entites/tableau_de_bord.dart';
import '../sources/distantes/source_tableau_de_bord_distante.dart';

class DepotTableauDeBordImpl
    implements DepotTableauDeBord {
  final SourceTableauDeBordDistante _sourceDistante;

  DepotTableauDeBordImpl({
    required this._sourceDistante,
  });

  @override
  Future<TableauDeBord> obtenir() {
    return _sourceDistante.obtenir();
  }
}