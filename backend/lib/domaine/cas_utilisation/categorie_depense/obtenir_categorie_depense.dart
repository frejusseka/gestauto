import '../../depots/depot_categorie_depense.dart';
import '../../entites/categorie_depense.dart';

class ObtenirCategorieDepense {
  final DepotCategorieDepense _depot;

  ObtenirCategorieDepense({
    required DepotCategorieDepense depot,
  }) : _depot = depot;

  Future<CategorieDepense?> executer({
    required String utilisateurId,
    required String categorieId,
  }) {
    return _depot.obtenirParId(
      utilisateurId: utilisateurId,
      categorieId: categorieId,
    );
  }
}