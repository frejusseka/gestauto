import 'package:dio/dio.dart';

import '../../../domaine/entites/categorie_depense.dart';
import '../../modeles/categorie_depense_modele.dart';

class SourceCategorieDepenseDistanteApi {
  final Dio _dio;

  SourceCategorieDepenseDistanteApi({
    required this._dio,
  });

  Future<List<CategorieDepense>> obtenirTous() async {
    final reponse = await _dio.get(
      '/protegee/categories_depenses',
    );

    final donnees =
        reponse.data as Map<String, dynamic>;

    final categories =
        donnees['categories'] as List<dynamic>;

    return categories
        .map(
          (element) =>
              CategorieDepenseModele.fromJson(
            element as Map<String, dynamic>,
          ).toEntite(),
        )
        .toList();
  }

  Future<CategorieDepense> creer({
    required String nom,
  }) async {
    final reponse = await _dio.post(
      '/protegee/categories_depenses',
      data: {
        'nom': nom,
      },
    );

    final donnees =
        reponse.data as Map<String, dynamic>;

    final categorieJson =
        donnees['categorie'] as Map<String, dynamic>;

    return CategorieDepenseModele.fromJson(
      categorieJson,
    ).toEntite();
  }
}