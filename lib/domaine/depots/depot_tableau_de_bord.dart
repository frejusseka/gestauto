import '../entites/tableau_de_bord.dart';

abstract class DepotTableauDeBord {
  Future<TableauDeBord> obtenir();
}