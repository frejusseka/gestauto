import 'package:dio/dio.dart';

import '../../../domaine/entites/depense.dart';
import '../../modeles/depense_modele.dart';

class SourceDepenseDistanteApi {
  final Dio _dio;

  SourceDepenseDistanteApi({
    required this._dio,
  });

  Future<List<Depense>> obtenirTous() async {
    final reponse = await _dio.get(
      '/protegee/depenses',
    );

    final donnees =
        reponse.data as Map<String, dynamic>;

    final depenses =
        donnees['depenses'] as List<dynamic>;

    return depenses
        .map(
          (element) => DepenseModele.fromJson(
            element as Map<String, dynamic>,
          ).toEntite(),
        )
        .toList();
  }

  Future<Depense> creer({
    required String vehiculeId,
    required String categorieId,
    required DateTime date,
    required double montant,
    String? description,
  }) async {
    final reponse = await _dio.post(
      '/protegee/depenses',
      data: {
        'vehiculeId': vehiculeId,
        'categorieId': categorieId,
        'date': date.toIso8601String(),
        'montant': montant,
        'description': description,
      },
    );

    final donnees =
        reponse.data as Map<String, dynamic>;

    final depenseJson =
        donnees['depense'] as Map<String, dynamic>;

    return DepenseModele.fromJson(
      depenseJson,
    ).toEntite();
  }
}