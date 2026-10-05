import '../../domaine/depots/depot_categorie_depense.dart';
import '../../domaine/entites/categorie_depense.dart';
import '../sources/distantes/source_categorie_depense_distante_api.dart';

class DepotCategorieDepenseImpl
    implements DepotCategorieDepense {
  final SourceCategorieDepenseDistanteApi
      _sourceDistante;

  DepotCategorieDepenseImpl({
    required this._sourceDistante,
  });

  @override
  Future<List<CategorieDepense>> obtenirTous() {
    return _sourceDistante.obtenirTous();
  }

  @override
  Future<CategorieDepense> creer({
    required String nom,
  }) {
    return _sourceDistante.creer(
      nom: nom,
    );
  }
}