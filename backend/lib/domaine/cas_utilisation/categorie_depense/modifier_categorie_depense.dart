import '../../depots/depot_categorie_depense.dart';
import '../../entites/categorie_depense.dart';

class ModifierCategorieDepense {
  final DepotCategorieDepense _depot;

  ModifierCategorieDepense({
    required DepotCategorieDepense depot,
  }) : _depot = depot;

  Future<CategorieDepense> executer({
    required CategorieDepense categorie,
  }) {
    return _depot.modifier(
      categorie: categorie,
    );
  }
}