import '../entites/categorie_depense.dart';

abstract class DepotCategorieDepense {
  Future<List<CategorieDepense>> obtenirTous();

  Future<CategorieDepense> creer({
    required String nom,
  });
}