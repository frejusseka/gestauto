import '../depots/depot_categorie_depense.dart';
import '../entites/categorie_depense.dart';

class CreerCategorieDepense {
  final DepotCategorieDepense _depot;

  CreerCategorieDepense({
    required this._depot,
  });

  Future<CategorieDepense> executer({
    required String nom,
  }) {
    return _depot.creer(
      nom: nom,
    );
  }
}