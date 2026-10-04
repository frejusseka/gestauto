import '../../../domaine/entites/tableau_de_bord.dart';

abstract class SourceTableauDeBordDistante {
  Future<TableauDeBord> obtenir();
}