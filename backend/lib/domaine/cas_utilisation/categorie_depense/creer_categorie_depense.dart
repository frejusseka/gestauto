import '../../depots/depot_categorie_depense.dart';
import '../../entites/categorie_depense.dart';

class CreerCategorieDepense {
  final DepotCategorieDepense _depot;

  CreerCategorieDepense({
    required DepotCategorieDepense depot,
  }) : _depot = depot;

  Future<CategorieDepense> executer({
    required CategorieDepense categorie,
  }) {
    return _depot.creer(
      categorie: categorie,
    );
  }
}