import '../entites/categorie_depense.dart';

abstract class DepotCategorieDepense {
  Future<List<CategorieDepense>> obtenirTous({
    required String utilisateurId,
  });

  Future<CategorieDepense?> obtenirParId({
    required String utilisateurId,
    required String categorieId,
  });

  Future<CategorieDepense> creer({
    required CategorieDepense categorie,
  });

  Future<CategorieDepense> modifier({
    required CategorieDepense categorie,
  });

  Future<void> supprimer({
    required String utilisateurId,
    required String categorieId,
  });
}