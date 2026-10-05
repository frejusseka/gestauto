import '../../depots/depot_categorie_depense.dart';

class SupprimerCategorieDepense {
  final DepotCategorieDepense _depot;

  SupprimerCategorieDepense({
    required DepotCategorieDepense depot,
  }) : _depot = depot;

  Future<void> executer({
    required String utilisateurId,
    required String categorieId,
  }) {
    return _depot.supprimer(
      utilisateurId: utilisateurId,
      categorieId: categorieId,
    );
  }
}