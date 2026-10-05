import '../depots/depot_categorie_depense.dart';
import '../entites/categorie_depense.dart';

class ObtenirCategoriesDepense {
  final DepotCategorieDepense _depot;

  ObtenirCategoriesDepense({
    required this._depot,
  });

  Future<List<CategorieDepense>> executer() {
    return _depot.obtenirTous();
  }
}