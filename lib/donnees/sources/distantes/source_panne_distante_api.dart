import 'package:dio/dio.dart';

import '../../modeles/panne_modele.dart';

class SourcePanneDistanteApi {
  final Dio _dio;

  SourcePanneDistanteApi({
    required this._dio,
  });

  Future<List<PanneModele>> obtenirTous() async {
    final reponse = await _dio.get(
      '/api/protegee/pannes',
    );

    final donnees = reponse.data as Map<String, dynamic>;

    final pannesJson =
        donnees['pannes'] as List<dynamic>;

    return pannesJson
        .map(
          (json) => PanneModele.depuisJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<PanneModele> creer({
    required PanneModele panne,
  }) async {
    final reponse = await _dio.post(
      '/api/protegee/pannes',
      data: {
        'vehiculeId': panne.vehiculeId,
        'date': panne.date.toIso8601String(),
        'description': panne.description,
        'gravite': panne.gravite.name,
        'resolue': panne.resolue,
        'dateResolution':
            panne.dateResolution?.toIso8601String(),
      },
    );

    final donnees =
        reponse.data as Map<String, dynamic>;

    return PanneModele.depuisJson(
      donnees['panne'] as Map<String, dynamic>,
    );
  }

  Future<PanneModele> modifier({
    required PanneModele panne,
  }) async {
    final reponse = await _dio.put(
      '/api/protegee/pannes/${panne.id}',
      data: {
        'vehiculeId': panne.vehiculeId,
        'date': panne.date.toIso8601String(),
        'description': panne.description,
        'gravite': panne.gravite.name,
        'resolue': panne.resolue,
        'dateResolution':
            panne.dateResolution?.toIso8601String(),
      },
    );

    final donnees =
        reponse.data as Map<String, dynamic>;

    return PanneModele.depuisJson(
      donnees['panne'] as Map<String, dynamic>,
    );
  }

  Future<void> supprimer({
    required String panneId,
  }) async {
    await _dio.delete(
      '/api/protegee/pannes/$panneId',
    );
  }
}