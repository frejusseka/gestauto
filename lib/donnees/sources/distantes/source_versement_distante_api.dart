import 'package:dio/dio.dart';

import '../../../domaine/entites/versement.dart';
import '../../modeles/versement_modele.dart';

class SourceVersementDistanteApi {
  final Dio _dio;

  SourceVersementDistanteApi({
    required this._dio,
  });

  Future<List<Versement>> obtenirTous() async {
    final reponse = await _dio.get(
      '/protegee/versements',
    );

    final donnees =
        reponse.data as Map<String, dynamic>;

    final versements =
        donnees['versements'] as List<dynamic>;

    return versements
        .map(
          (element) => VersementModele.fromJson(
            element as Map<String, dynamic>,
          ).toEntite(),
        )
        .toList();
  }

  Future<Versement> creer({
    required String vehiculeId,
    required DateTime date,
    required double montantAttendu,
    required double montantVerse,
  }) async {
    final reponse = await _dio.post(
      '/protegee/versements',
      data: {
        'vehiculeId': vehiculeId,
        'date': date.toIso8601String(),
        'montantAttendu': montantAttendu,
        'montantVerse': montantVerse,
      },
    );

    final donnees =
        reponse.data as Map<String, dynamic>;

    final versementJson =
        donnees['versement'] as Map<String, dynamic>;

    return VersementModele.fromJson(
      versementJson,
    ).toEntite();
  }
}