import '../../depots/depot_categorie_depense.dart';
import '../../entites/categorie_depense.dart';

class ObtenirCategoriesDepense {
  final DepotCategorieDepense _depot;

  ObtenirCategoriesDepense({
    required DepotCategorieDepense depot,
  }) : _depot = depot;

  Future<List<CategorieDepense>> executer({
    required String utilisateurId,
  }) {
    return _depot.obtenirTous(
      utilisateurId: utilisateurId,
    );
  }
}